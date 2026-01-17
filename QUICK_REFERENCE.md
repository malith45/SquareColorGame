# Square Color Game - Quick Reference

## File Structure Quick Reference

```
SquareColorGame/
├── App/
│   └── SquareColorGameApp.swift       # @main entry point
│
├── Models/                             # Data structures
│   ├── Difficulty.swift                # Easy/Medium/Hard config
│   ├── GameState.swift                 # ready/playing/gameOver/showingSequence
│   ├── HighScore.swift                 # Leaderboard entry
│   ├── ColorSquare.swift               # Game piece (color + optional shape)
│   └── Shape.swift                     # circle/square/triangle/star/diamond/heart
│
├── ViewModels/                         # Business logic
│   ├── GameViewModel.swift             # Game logic, timer, scoring
│   └── LeaderboardViewModel.swift      # High score management
│
├── Views/                              # UI components
│   ├── DifficultySelectionView.swift  # Main menu
│   ├── GameView.swift                  # Game interface + GameOverView
│   ├── InstructionsView.swift         # Tutorial pages
│   ├── LeaderboardView.swift          # Top 3 scores
│   ├── HighScoreModalView.swift       # Nickname input
│   └── Components/
│       ├── ColorSquareView.swift      # Reusable game square
│       ├── TimerBarView.swift         # Progress bar timer
│       └── DifficultyCardView.swift   # Selection cards
│
└── Utilities/                          # Helpers
    ├── ColorGenerator.swift            # Color generation algorithms
    ├── HapticManager.swift             # Haptic feedback
    └── StorageManager.swift            # UserDefaults wrapper
```

## Common Tasks

### Adjust Difficulty Settings
**File:** `Models/Difficulty.swift`
```swift
var initialTime: TimeInterval {
    case .easy: return 10    // Change starting time
    case .medium: return 8
    case .hard: return 6
}

var timeBonus: TimeInterval {
    case .easy: return 2     // Change time bonus
    case .medium: return 3
    case .hard: return 4
}

var scorePerRound: Int {
    case .easy: return 10    // Change score per round
    case .medium: return 20
    case .hard: return 30
}
```

### Modify Color Generation
**File:** `Utilities/ColorGenerator.swift`
```swift
// Adjust color variation (higher = more different)
static func similarColor(to color: Color, variation: Double = 0.15) -> Color

// Change color range (0.0 to 1.0)
static func randomColor() -> Color {
    Color(
        red: Double.random(in: 0.2...1.0),    // Avoid too dark
        green: Double.random(in: 0.2...1.0),
        blue: Double.random(in: 0.2...1.0)
    )
}
```

### Change Leaderboard Size
**File:** `Utilities/StorageManager.swift`
```swift
func getTopScores(for difficulty: Difficulty, limit: Int = 3) -> [HighScore]
// Change limit parameter default from 3 to desired number
```

### Adjust Timer Update Rate
**File:** `ViewModels/GameViewModel.swift`
```swift
Timer.publish(every: 0.1, on: .main, in: .common)  // Change 0.1 to desired interval
    .sink { [weak self] _ in
        self?.timeRemaining -= 0.1  // Must match interval
    }
```

### Customize Animations
**File:** `Views/Components/DifficultyCardView.swift`
```swift
.animation(.spring(response: 0.3, dampingFraction: 0.6), value: state)
// response: animation duration
// dampingFraction: bounciness (0.5-1.0)
```

### Modify Grid Size
**File:** `ViewModels/GameViewModel.swift`
```swift
// Change from 3x3 to different size
private func setupEasyMode() {
    // Generate grid with one matching square
    var gridSquares: [ColorSquare] = [targetSquare]
    for _ in 1..<9 {  // Change 9 to desired total (e.g., 16 for 4x4)
        gridSquares.append(...)
    }
}
```

**File:** `Views/GameView.swift`
```swift
LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3))
// Change count: 3 to desired columns (e.g., 4 for 4x4)
```

### Add New Shapes
**File:** `Models/Shape.swift`
```swift
enum GameShape: String, CaseIterable, Codable {
    case circle
    case square
    // Add new cases here
    case pentagon
    case hexagon
    
    var icon: String {
        case .pentagon: return "pentagon.fill"  // Use SF Symbol name
        case .hexagon: return "hexagon.fill"
    }
}
```

### Change Nickname Length Limit
**File:** `Views/HighScoreModalView.swift`
```swift
private let maxNicknameLength = 15  // Change to desired length
```

### Customize Color Themes
**File:** `Views/Components/DifficultyCardView.swift`
```swift
private func gradientForDifficulty(_ difficulty: Difficulty) -> LinearGradient {
    switch difficulty {
    case .easy:
        return LinearGradient(
            colors: [Color.green, Color.green.opacity(0.7)],  // Change colors
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
```

### Adjust Haptic Feedback
**File:** `Utilities/HapticManager.swift`
```swift
func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
    // Available styles: .light, .medium, .heavy, .soft, .rigid
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
}
```

## Key SwiftUI Modifiers Used

### State Management
```swift
@StateObject          // Create and own view model
@ObservedObject       // Observe external object
@Published            // Publish changes to views
@State                // Local view state
@Binding              // Two-way binding
@Environment          // System environment values
```

### Navigation
```swift
NavigationView { }           // Navigation container
NavigationLink { }           // Navigation trigger
.navigationBarHidden(true)   // Hide nav bar
.sheet(isPresented:)         // Present modal
```

### Animations
```swift
.animation(.spring())        // Spring animation
.scaleEffect()               // Scale transform
.transition()                // View transition
withAnimation { }            // Explicit animation
```

### Layout
```swift
VStack { }                   // Vertical stack
HStack { }                   // Horizontal stack
ZStack { }                   // Depth stack
LazyVGrid { }               // Lazy grid
Spacer()                     // Flexible space
```

## Debugging Tips

### Print Debug Info
```swift
// In GameViewModel
func selectSquare(_ square: ColorSquare) {
    print("Selected square color: \(square.color)")
    print("Target color: \(targetColor)")
    print("Is match: \(colorsMatch(square.color, targetColor))")
}
```

### Test Timer Without Waiting
```swift
// Temporarily increase time bonus
var timeBonus: TimeInterval {
    case .easy: return 100  // Lots of time for testing
}
```

### Inspect View Hierarchy
```swift
// Add to any view
.border(Color.red)           // Show view bounds
.background(Color.yellow)    // Show view area
```

### Test Leaderboard
```swift
// Add test scores in StorageManager
func addTestScores() {
    let scores = [
        HighScore(nickname: "Test1", score: 100, difficulty: .easy),
        HighScore(nickname: "Test2", score: 200, difficulty: .medium),
        HighScore(nickname: "Test3", score: 300, difficulty: .hard)
    ]
    scores.forEach { addHighScore($0) }
}
```

## Common Issues & Solutions

### Issue: Colors too similar
**Solution:** Increase variation in `ColorGenerator.similarColor()`
```swift
similarColor(to: targetColor, variation: 0.3)  // Increase from 0.15
```

### Issue: Timer too fast/slow
**Solution:** Adjust update interval in `GameViewModel.startTimer()`
```swift
Timer.publish(every: 0.2, on: .main, in: .common)  // Slower updates
```

### Issue: Game too easy/hard
**Solution:** Adjust time and score values in `Difficulty.swift`

### Issue: Haptics not working
**Solution:** Test on physical device (haptics don't work in simulator)

### Issue: High scores not persisting
**Solution:** Check UserDefaults key and encoding
```swift
print(StorageManager.shared.loadHighScores())  // Debug print
```

## Performance Monitoring

### Timer Performance
```swift
func startTimer() {
    let start = Date()
    timer = Timer.publish(every: 0.1, on: .main, in: .common)
        .sink { _ in
            let elapsed = Date().timeIntervalSince(start)
            print("Timer accuracy: \(elapsed)")  // Should be ~0.1s
        }
}
```

### Color Generation Performance
```swift
let start = Date()
let colors = ColorGenerator.generateGameColors(targetColor: .red)
let elapsed = Date().timeIntervalSince(start)
print("Color generation time: \(elapsed)s")  // Should be < 0.001s
```

## SwiftUI Preview Snippets

### Preview Multiple Sizes
```swift
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 14 Pro")
            ContentView()
                .previewDevice("iPhone SE")
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
```

### Preview with Mock Data
```swift
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(difficulty: .medium)
    }
}
```

## Useful Extensions

### Add to improve color debugging
```swift
extension Color {
    func toHex() -> String {
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: nil)
        return String(format: "#%02X%02X%02X", 
            Int(r * 255), Int(g * 255), Int(b * 255))
    }
}

// Usage
print("Color: \(square.color.toHex())")
```

## Testing Checklist

- [ ] Test Easy mode gameplay
- [ ] Test Medium mode sequence
- [ ] Test Hard mode shapes + colors
- [ ] Test timer countdown
- [ ] Test time bonus addition
- [ ] Test score increment
- [ ] Test streak counter
- [ ] Test game over condition
- [ ] Test high score modal appears
- [ ] Test nickname input and save
- [ ] Test leaderboard display
- [ ] Test difficulty switching
- [ ] Test instructions pages
- [ ] Test navigation flow
- [ ] Test haptic feedback (device only)
- [ ] Test dark mode
- [ ] Test different screen sizes
- [ ] Test VoiceOver support
- [ ] Test landscape orientation (if supported)
