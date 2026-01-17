# Square Color Game - Visual Architecture

## App Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         App Launch                              │
│                  SquareColorGameApp.swift                       │
│                           ↓                                     │
│                 DifficultySelectionView                         │
│                    (Main Menu)                                  │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │  Easy Card   │  │ Medium Card  │  │  Hard Card   │        │
│  │   [Tap]      │  │   [Tap]      │  │   [Tap]      │        │
│  └──────────────┘  └──────────────┘  └──────────────┘        │
│         │                 │                  │                  │
│         └─────────────────┴──────────────────┘                 │
│                           ↓                                     │
└─────────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│                        GameView                                 │
│                                                                 │
│  ┌────────────────────────────────────────────────────────┐   │
│  │  Header: Score | Difficulty | Streak                   │   │
│  ├────────────────────────────────────────────────────────┤   │
│  │  Timer Bar (color-coded progress)                      │   │
│  ├────────────────────────────────────────────────────────┤   │
│  │  Target Display (1 or 2 colors/shapes)                 │   │
│  ├────────────────────────────────────────────────────────┤   │
│  │                                                         │   │
│  │              3×3 Game Grid                              │   │
│  │         [□] [□] [□]                                     │   │
│  │         [□] [□] [□]                                     │   │
│  │         [□] [□] [□]                                     │   │
│  │                                                         │   │
│  └────────────────────────────────────────────────────────┘   │
│                                                                 │
│  [Playing] → [Correct/Wrong Feedback] → [New Round]           │
│                      ↓ (Time = 0)                              │
│                  [Game Over]                                   │
└─────────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│                    Game Over Screen                             │
│                                                                 │
│            "Game Over!"                                         │
│              Score: 250                                         │
│                                                                 │
│         [Play Again]  [Back to Menu]                           │
│                  ↓                                              │
│         (If High Score)                                         │
│                  ↓                                              │
│         HighScoreModalView                                      │
│           Enter Nickname                                        │
│            [Save Score]                                         │
└─────────────────────────────────────────────────────────────────┘
```

## Component Hierarchy

```
SquareColorGameApp
└── DifficultySelectionView
    ├── DifficultyCardView (×3)
    │   └── ScaleButtonStyle
    ├── .sheet → InstructionsView
    │   └── InstructionPageView (×5)
    └── .sheet → LeaderboardView
        ├── LeaderboardViewModel
        └── LeaderboardRowView (×3)

DifficultySelectionView → NavigationLink
└── GameView
    ├── GameViewModel
    ├── TimerBarView
    ├── ColorSquareView (×9)
    │   └── [Target Display]
    │   └── [Game Grid]
    ├── FeedbackOverlay
    ├── GameOverView
    └── .sheet → HighScoreModalView
```

## Data Flow

```
User Action                ViewModel               Model/Storage
──────────                 ──────────              ─────────────
                                                   
Tap Square      ──────→   selectSquare()          ColorSquare
                          ↓
                          Check if correct
                          ↓
                          Update @Published
                          score/streak
                          ↓
View Redraws   ←──────    State changes           
                          ↓
                          Timer runs out
                          ↓
                          endGame()
                          ↓
                          Check high score    ──→  StorageManager
                          ↓                        ↓
Show Modal     ←──────    showHighScoreModal      isHighScore()
                          ↓
Enter Name                saveHighScore()     ──→  addHighScore()
                                                   ↓
                                                   UserDefaults
```

## State Machine

```
Game States:

┌──────────┐
│  .ready  │  Initial state
└──────────┘
     ↓ startGame()
┌──────────────┐
│  .playing    │  User can select squares
└──────────────┘
     ↓ showSequence() [Medium/Hard only]
┌──────────────────┐
│.showingSequence  │  Highlighting target sequence
└──────────────────┘
     ↓ sequence complete
┌──────────────┐
│  .playing    │  Back to playing
└──────────────┘
     ↓ timeRemaining = 0 or wrong answer [Medium/Hard]
┌──────────────┐
│  .gameOver   │  Show final score
└──────────────┘
     ↓ restartGame()
┌──────────┐
│  .ready  │  Ready for new game
└──────────┘
```

## Color Generation Pipeline

```
Target Color Request
        ↓
ColorGenerator.randomColor()
        ↓
    RGB Color (vibrant)
    r: 0.2-1.0
    g: 0.2-1.0
    b: 0.2-1.0
        ↓
ColorGenerator.similarColor(variation: 0.15)
        ↓
    8 Similar Colors
    Each channel ± 0.15
        ↓
    Shuffle Array
        ↓
    3×3 Grid Display
```

## Timer System Flow

```
startGame()
    ↓
Timer.publish(every: 0.1s)
    ↓
    ├──→ Update @Published timeRemaining
    │         ↓
    │    View redraws TimerBarView
    │         ↓
    │    Progress bar animates
    │         ↓
    │    Color changes (green→orange→red)
    │
    └──→ timeRemaining <= 0?
              ↓ YES
         endGame()
```

## Leaderboard System

```
Game Ends (score = 250)
        ↓
StorageManager.isHighScore(250, .medium)
        ↓
    Load all scores
        ↓
    Filter by difficulty
        ↓
    Get top 3 scores
        ↓
    Compare with new score
        ↓
    Return true/false
        ↓ (if true)
Show HighScoreModalView
        ↓
    User enters nickname
        ↓
StorageManager.addHighScore()
        ↓
    Create HighScore object
        ↓
    Load all scores
        ↓
    Append new score
        ↓
    Filter by difficulty
        ↓
    Sort by score descending
        ↓
    Take top 3
        ↓
    Combine with other difficulties
        ↓
    Save to UserDefaults (JSON)
```

## Memory Management

```
View Created
    ↓
@StateObject creates ViewModel
    ↓
ViewModel starts timer
    ↓
Timer holds [weak self]
    ↓
View dismissed
    ↓
ViewModel deinit
    ↓
Timer cancelled
    ↓
Memory released ✓
```

## Animation Timeline

```
Button Tap:
0.0s: Press detected
0.0s: Scale 1.0 → 0.95 (spring)
0.3s: Release, scale 0.95 → 1.0
0.3s: Animation complete

Correct Answer:
0.0s: Selection validated
0.0s: Haptic feedback fires
0.0s: Feedback overlay appears (scale 0.5 → 1.0)
0.3s: Score increments with animation
0.3s: Feedback fades out
0.5s: New round starts

Game Over:
0.0s: Timer reaches 0
0.0s: Game state = .gameOver
0.0s: Overlay fades in (0.3s)
0.3s: Final score displays
0.3s: Check high score
0.5s: Show modal if needed
```

## Performance Profile

```
Component              Updates/sec    Cost
─────────────────────  ───────────    ────
Timer                  10 (0.1s)      Low
TimerBarView          10             Low (animated efficiently)
Score Display         Per round      Low (text only)
Grid Squares          On round       Medium (9 views)
Color Generation      Per round      Low (<1ms)
UserDefaults          On save        Low (JSON encode)
Haptic Feedback       On action      Low (system handled)

Total Memory: < 50MB
CPU Usage: < 5% average
Battery Impact: Minimal
```

## File Dependencies

```
SquareColorGameApp.swift
    └── DifficultySelectionView.swift
        ├── DifficultyCardView.swift
        │   ├── Difficulty.swift
        │   └── HapticManager.swift
        ├── GameView.swift
        │   ├── GameViewModel.swift
        │   │   ├── Difficulty.swift
        │   │   ├── GameState.swift
        │   │   ├── ColorSquare.swift
        │   │   ├── Shape.swift
        │   │   ├── ColorGenerator.swift
        │   │   ├── HapticManager.swift
        │   │   └── StorageManager.swift
        │   ├── ColorSquareView.swift
        │   ├── TimerBarView.swift
        │   └── HighScoreModalView.swift
        ├── InstructionsView.swift
        └── LeaderboardView.swift
            ├── LeaderboardViewModel.swift
            │   ├── Difficulty.swift
            │   ├── HighScore.swift
            │   └── StorageManager.swift
            └── HighScore.swift
```

## Color Matching Logic

```
User Taps Square
      ↓
Get square.color
      ↓
Convert to UIColor
      ↓
Extract RGB components
    r1, g1, b1
      ↓
Compare with target
    r2, g2, b2
      ↓
Calculate differences
    |r1 - r2| < 0.01
    |g1 - g2| < 0.01
    |b1 - b2| < 0.01
      ↓
All within threshold?
    ↓ YES          ↓ NO
  Correct        Wrong
    ↓              ↓
  +Score      No points
  +Time       (Easy: continue)
            (Med/Hard: game over)
```

## View Lifecycle

```
App Launch
    ↓
DifficultySelectionView.onAppear
    ↓
User selects difficulty
    ↓
NavigationLink activates
    ↓
GameView initialized
    ↓
GameViewModel created (@StateObject)
    ↓
GameView.onAppear
    ↓
viewModel.startGame()
    ↓
Game plays...
    ↓
User navigates back
    ↓
GameView.onDisappear
    ↓
Timer cancelled (deinit)
    ↓
ViewModel released
    ↓
Back to DifficultySelectionView
```

## Accessibility Tree

```
DifficultySelectionView
├── "Square Color Game" (Title)
├── "Test your color matching skills" (Subtitle)
├── Button: "Easy - Match target color from 3×3 grid"
├── Button: "Medium - Match 2 colors in sequence"
├── Button: "Hard - Match shapes and colors in sequence"
├── Button: "How to Play"
└── Button: "Leaderboard"

GameView
├── Button: "Back"
├── "Easy Mode" (Header)
├── "Score: 120" (Score display)
├── "Streak: 5" (Streak display)
├── "Timer: 8.5 seconds" (Timer)
├── "Target" (Label)
├── Image: Target color square
└── Grid of 9 color squares (buttons)
    ├── Button: "Color square 1"
    ├── Button: "Color square 2"
    └── ... (7 more)
```

---

This visual architecture provides a complete understanding of how the app is structured and how data flows through the system.
