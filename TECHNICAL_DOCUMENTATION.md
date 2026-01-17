# Square Color Game - Technical Documentation

## Architecture Overview

The app follows the **Model-View-ViewModel (MVVM)** architectural pattern, which provides clear separation of concerns and makes the code testable and maintainable.

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        SwiftUI Views                         │
│  ┌────────────────┐  ┌──────────┐  ┌─────────────────┐     │
│  │  Difficulty    │  │   Game   │  │  Instructions   │     │
│  │  Selection     │→│   View   │  │     View        │     │
│  └────────────────┘  └──────────┘  └─────────────────┘     │
│         ↓                  ↓                ↓                │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                        ViewModels                            │
│  ┌──────────────────────┐      ┌──────────────────────┐    │
│  │   GameViewModel      │      │  LeaderboardViewModel │    │
│  │  - Game Logic        │      │  - Score Management   │    │
│  │  - Timer Control     │      │  - Top 3 Scores       │    │
│  │  - State Management  │      └──────────────────────┘    │
│  └──────────────────────┘                                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                          Models                              │
│  ┌──────────┐  ┌────────────┐  ┌──────────┐  ┌─────────┐  │
│  │Difficulty│  │ ColorSquare│  │HighScore │  │GameState│  │
│  └──────────┘  └────────────┘  └──────────┘  └─────────┘  │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                        Utilities                             │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐  │
│  │ColorGenerator │  │StorageManager │  │HapticManager  │  │
│  └───────────────┘  └───────────────┘  └───────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

### Game Flow
```
Start → Difficulty Selection → Game View → Game Over → Leaderboard
                    ↑                          ↓
                    └──────── Restart ─────────┘
```

### State Management Flow
```
User Action → ViewModel Updates @Published Properties → SwiftUI View Redraws
```

## Key Components

### 1. Models (Data Layer)

#### Difficulty.swift
Defines three game difficulty levels with their parameters:
- `initialTime`: Starting time for the game
- `timeBonus`: Time added for correct answers
- `scorePerRound`: Points awarded per correct answer

#### ColorSquare.swift
Represents a game piece with:
- `color`: SwiftUI Color
- `shape`: Optional GameShape (for Hard mode)
- `isTarget`: Boolean indicating if it's a target square

#### HighScore.swift
Leaderboard entry with:
- `nickname`: Player name (max 15 chars)
- `score`: Final score
- `difficulty`: Difficulty level played
- `date`: Timestamp of achievement

### 2. ViewModels (Business Logic Layer)

#### GameViewModel.swift
**Responsibilities:**
- Game state management
- Timer control using Combine
- Score and streak tracking
- Game logic for all three difficulty levels
- Square generation and validation

**Key Methods:**
- `startGame()`: Initializes new game
- `setupNewRound()`: Generates new round based on difficulty
- `selectSquare(_:)`: Handles square selection
- `endGame()`: Handles game over state
- `saveHighScore(nickname:)`: Saves score to leaderboard

**Published Properties:**
```swift
@Published var gameState: GameState
@Published var score: Int
@Published var streak: Int
@Published var timeRemaining: TimeInterval
@Published var squares: [ColorSquare]
@Published var targetSquares: [ColorSquare]
```

#### LeaderboardViewModel.swift
**Responsibilities:**
- Loading high scores from storage
- Filtering scores by difficulty
- Managing leaderboard display

### 3. Views (Presentation Layer)

#### DifficultySelectionView.swift
Main menu with:
- Three difficulty cards (Easy, Medium, Hard)
- Navigation to game view
- Access to instructions and leaderboard
- Gradient background

#### GameView.swift
Main game interface featuring:
- Score and streak display
- Timer bar with color coding
- Target color/shape display
- 3×3 game grid
- Feedback animations
- Game over overlay

#### InstructionsView.swift
Tutorial with:
- Swipeable pages using TabView
- Icons and descriptions for each mode
- Skip and navigation controls

#### LeaderboardView.swift
High scores display with:
- Segmented control for difficulty selection
- Medal icons (🥇🥈🥉) for top 3
- Score cards with nickname and date
- Empty state handling

#### HighScoreModalView.swift
Celebration modal with:
- Animated star icon
- Score display
- Nickname text field (max 15 chars)
- Save functionality
- Non-dismissible until saved

### 4. Utilities (Helper Layer)

#### ColorGenerator.swift
**Color Generation Algorithms:**
```swift
// Random vibrant color
randomColor() -> Color

// Similar color with variation
similarColor(to: Color, variation: Double) -> Color

// Game grid colors
generateGameColors(targetColor: Color, totalCount: Int) -> [Color]
```

Uses HSB color space manipulation to create visually distinct but similar colors.

#### HapticManager.swift
**Haptic Feedback Patterns:**
- `success()`: UINotificationFeedbackGenerator.success
- `error()`: UINotificationFeedbackGenerator.error
- `selection()`: UISelectionFeedbackGenerator

#### StorageManager.swift
**UserDefaults Wrapper:**
```swift
// Save high scores
saveHighScores(_ scores: [HighScore])

// Load all scores
loadHighScores() -> [HighScore]

// Get top 3 for difficulty
getTopScores(for: Difficulty, limit: Int) -> [HighScore]

// Check if score qualifies
isHighScore(_ score: Int, difficulty: Difficulty) -> Bool

// Add new high score
addHighScore(_ highScore: HighScore)
```

## Game Logic Details

### Easy Mode
1. Generate random target color
2. Create 8 similar variations
3. Shuffle into 3×3 grid
4. User selects matching square
5. Wrong selection = no penalty, continue
6. Correct = +10 points, +2s, new round

### Medium Mode
1. Generate 2 distinct colors
2. Show sequence with highlighting
3. User must tap in same order
4. Wrong selection = game over
5. Correct sequence = +20 points, +3s, new round

### Hard Mode
1. Generate 2 distinct color+shape combinations
2. Show sequence with highlighting
3. User must match both color AND shape in order
4. Wrong selection = game over
5. Correct sequence = +30 points, +4s, new round

## Timer System

### Implementation
Uses Combine framework's Timer publisher:
```swift
Timer.publish(every: 0.1, on: .main, in: .common)
    .autoconnect()
    .sink { [weak self] _ in
        self?.timeRemaining -= 0.1
        if self?.timeRemaining <= 0 {
            self?.endGame()
        }
    }
```

### Time Management
- Updates every 0.1 seconds for smooth animation
- Visual feedback via colored progress bar:
  - Green: > 50% time remaining
  - Orange: 25-50% time remaining
  - Red: < 25% time remaining

## Animation System

### Spring Animations
All interactive elements use spring animations:
```swift
.animation(.spring(response: 0.3, dampingFraction: 0.6), value: state)
```

### Scale Effects
Buttons use `ScaleButtonStyle` for press feedback:
```swift
.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
```

### Feedback Animations
Correct/wrong feedback uses:
- Scale animation (0.5 → 1.0)
- Color overlay
- 0.3s duration with auto-dismiss

## Color Matching Algorithm

### Color Comparison
Uses RGB color space with threshold:
```swift
func colorsMatch(_ color1: Color, _ color2: Color) -> Bool {
    // Convert to UIColor and extract RGB components
    // Compare with threshold of 0.01 for exact match
    return abs(r1 - r2) < 0.01 && 
           abs(g1 - g2) < 0.01 && 
           abs(b1 - b2) < 0.01
}
```

### Color Generation
Similar colors are generated by:
1. Converting target to RGB
2. Adding random variation (-0.15 to +0.15 per channel)
3. Clamping to valid range (0.0 to 1.0)

## Persistence Layer

### Data Structure
```json
{
  "highScores": [
    {
      "id": "UUID",
      "nickname": "Player1",
      "score": 250,
      "difficulty": "medium",
      "date": "2026-01-17T12:00:00Z"
    }
  ]
}
```

### Storage Strategy
- Uses UserDefaults for simplicity
- JSON encoding/decoding via Codable
- Maintains only top 3 per difficulty
- Automatic sorting by score

## Accessibility Features

### VoiceOver Support
All interactive elements have accessibility labels:
- Buttons: Descriptive labels
- Scores: Numeric values with context
- Timer: Time remaining announcement

### Dynamic Type
Text scales with system font size preferences:
- Uses system font sizes
- `.monospacedDigit()` for scores
- Proper text hierarchy

### Color Accessibility
- High contrast colors
- Not relying solely on color (shapes in Hard mode)
- Support for Dark Mode

## Performance Considerations

### Memory Management
- Weak references in timer closures
- Efficient color generation
- Minimal object retention

### Rendering Optimization
- LazyVGrid for efficient grid layout
- Conditional rendering of overlays
- Hardware-accelerated animations

### Timer Precision
- 0.1s updates balance smoothness vs. performance
- Main thread updates for UI consistency
- Automatic cancellation on cleanup

## Testing Recommendations

### Unit Tests
- ColorGenerator color similarity
- Score calculation logic
- Leaderboard sorting
- Time bonus calculations

### UI Tests
- Navigation flow
- Game completion
- High score entry
- Difficulty selection

### Manual Testing
- All three difficulty levels
- Timer behavior under low time
- Haptic feedback on device
- Dark mode appearance
- Various screen sizes

## Future Enhancements

### Potential Features
1. Sound effects for actions
2. Particle effects for celebrations
3. Settings page (sound/haptic toggles)
4. Statistics tracking (games played, best streaks)
5. Social sharing of scores
6. Difficulty-specific color palettes
7. Color-blind friendly mode
8. Landscape orientation support
9. iPad-optimized layouts
10. Game Center integration

### Technical Improvements
1. SwiftData migration (iOS 17+)
2. Async/await for async operations
3. Widget support
4. Apple Watch companion app
5. iCloud sync for high scores
