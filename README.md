# Square Color Game - SwiftUI iOS App

A modern, minimal iOS game built with SwiftUI that tests your color matching skills across three difficulty levels.

## Features

### Three Game Modes
- **Easy Mode**: Match a target color from a 3×3 grid (+10 points, +2s per round)
- **Medium Mode**: Match 2 colors in sequence (+20 points, +3s per round)  
- **Hard Mode**: Match shapes AND colors in sequence (+30 points, +4s per round)

### Core Gameplay
- ⏱️ Time-based challenge with bonus time for correct answers
- 🔥 Streak counter for consecutive correct answers
- 🏆 Top 3 leaderboard per difficulty level
- 📱 Full Dark Mode support
- 🎯 Haptic feedback for enhanced UX
- ✨ Smooth animations and transitions

### Modern iOS Design
- Clean, minimal interface following iOS design guidelines
- Card-based layout with smooth spring animations
- SF Symbols icons throughout
- Gradient backgrounds and visual polish
- Accessibility support (VoiceOver labels, Dynamic Type)

## Project Structure

```
SquareColorGame/
├── App/
│   └── SquareColorGameApp.swift          # App entry point
├── Models/
│   ├── Difficulty.swift                   # Difficulty levels enum
│   ├── GameState.swift                    # Game state management
│   ├── HighScore.swift                    # Leaderboard data model
│   ├── ColorSquare.swift                  # Game piece model
│   └── Shape.swift                        # Shape enum for Hard mode
├── ViewModels/
│   ├── GameViewModel.swift                # Game logic & timer
│   └── LeaderboardViewModel.swift         # Leaderboard management
├── Views/
│   ├── DifficultySelectionView.swift     # Main menu
│   ├── GameView.swift                     # Game interface
│   ├── InstructionsView.swift            # Tutorial/instructions
│   ├── LeaderboardView.swift             # High scores display
│   ├── HighScoreModalView.swift          # Nickname input popup
│   └── Components/
│       ├── ColorSquareView.swift         # Reusable color square
│       ├── TimerBarView.swift            # Countdown timer UI
│       └── DifficultyCardView.swift      # Difficulty selection cards
└── Utilities/
    ├── ColorGenerator.swift               # Color generation logic
    ├── HapticManager.swift                # Haptic feedback handler
    └── StorageManager.swift               # UserDefaults persistence
```

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.9+

## How to Build

### Option 1: Open in Xcode
1. Clone the repository
2. Open `SquareColorGame` folder in Xcode
3. Select a simulator or device
4. Build and run (⌘R)

### Option 2: Swift Package Manager
The project is structured as a Swift Package and includes a `Package.swift` manifest.

```bash
git clone https://github.com/malith45/SquareColorGame.git
cd SquareColorGame
swift build
```

## How to Play

1. **Select Difficulty**: Choose Easy, Medium, or Hard mode from the main menu
2. **Match Colors**: 
   - Easy: Find and tap the matching color
   - Medium: Tap 2 colors in the correct sequence
   - Hard: Match both shapes and colors in sequence
3. **Beat the Clock**: Time is limited! Correct answers add bonus time
4. **Set Records**: Make the top 3 leaderboard and save your nickname

## Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture:
- **Models**: Data structures and enums
- **Views**: SwiftUI views for UI
- **ViewModels**: Business logic, state management, and Combine publishers
- **Utilities**: Helper classes for colors, haptics, and storage

### Key Technologies
- SwiftUI for declarative UI
- Combine for reactive programming and timers
- UserDefaults for data persistence
- UIKit integration for haptics

## Game Logic

### Easy Mode
- Generates a random target color
- Creates 8 similar variations
- User selects the matching square
- Incorrect answers don't end the game

### Medium Mode
- Shows 2 target colors in sequence
- User must tap in the same order
- Incorrect selection ends the game
- Requires memorization

### Hard Mode
- Combines shapes (circle, square, triangle, star, diamond, heart) with colors
- User must match both attributes in sequence
- Most challenging mode
- Highest rewards

## Customization

### Adjust Difficulty Settings
Edit values in `Models/Difficulty.swift`:
```swift
var initialTime: TimeInterval  // Starting time
var timeBonus: TimeInterval    // Time added per correct answer
var scorePerRound: Int         // Points per round
```

### Color Generation
Modify `Utilities/ColorGenerator.swift` to adjust:
- Color variation for difficulty
- Color generation algorithms
- Color-blind friendly palettes

## License

This project is available under the MIT License.

## Author

Built with ❤️ using SwiftUI