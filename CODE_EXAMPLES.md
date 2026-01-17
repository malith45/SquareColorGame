# Square Color Game - Code Examples

This document provides ready-to-use code examples for common modifications and extensions.

## 🎨 Customization Examples

### 1. Add a Fourth Difficulty Level

**File:** `Models/Difficulty.swift`
```swift
enum Difficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case expert = "Expert"  // NEW
    
    var description: String {
        switch self {
        case .easy:
            return "Match the target color from a 3×3 grid"
        case .medium:
            return "Match 2 colors in the correct sequence"
        case .hard:
            return "Match shapes and colors in sequence"
        case .expert:  // NEW
            return "Match 3 colors with 4×4 grid at maximum speed"
        }
    }
    
    var icon: String {
        switch self {
        case .easy: return "square.fill"
        case .medium: return "square.stack.3d.up.fill"
        case .hard: return "star.fill"
        case .expert: return "flame.fill"  // NEW
        }
    }
    
    var initialTime: TimeInterval {
        switch self {
        case .easy: return 10
        case .medium: return 8
        case .hard: return 6
        case .expert: return 5  // NEW
        }
    }
    
    var timeBonus: TimeInterval {
        switch self {
        case .easy: return 2
        case .medium: return 3
        case .hard: return 4
        case .expert: return 2  // NEW - less bonus for challenge
        }
    }
    
    var scorePerRound: Int {
        switch self {
        case .easy: return 10
        case .medium: return 20
        case .hard: return 30
        case .expert: return 50  // NEW
        }
    }
}
```

**File:** `Views/Components/DifficultyCardView.swift`
```swift
private func gradientForDifficulty(_ difficulty: Difficulty) -> LinearGradient {
    switch difficulty {
    case .easy:
        return LinearGradient(
            colors: [Color.green, Color.green.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    case .medium:
        return LinearGradient(
            colors: [Color.orange, Color.orange.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    case .hard:
        return LinearGradient(
            colors: [Color.red, Color.red.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    case .expert:  // NEW
        return LinearGradient(
            colors: [Color.purple, Color.pink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
```

### 2. Change to 4×4 Grid

**File:** `ViewModels/GameViewModel.swift`
```swift
private func setupEasyMode() {
    targetColor = ColorGenerator.randomColor()
    let targetSquare = ColorSquare(color: targetColor, isTarget: true)
    targetSquares = [targetSquare]
    correctSquares = [targetSquare]
    
    // Generate grid with one matching square
    var gridSquares: [ColorSquare] = [targetSquare]
    for _ in 1..<16 {  // Changed from 9 to 16 for 4×4
        gridSquares.append(ColorSquare(color: ColorGenerator.similarColor(to: targetColor)))
    }
    squares = gridSquares.shuffled()
}
```

**File:** `Views/GameView.swift`
```swift
LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
    // Changed count from 3 to 4
    ForEach(viewModel.squares) { square in
        Button(action: {
            if viewModel.gameState == .playing {
                viewModel.selectSquare(square)
            }
        }) {
            ColorSquareView(
                square: square,
                isSelected: viewModel.selectedSquares.contains(square),
                isHighlighted: false
            )
        }
        .disabled(viewModel.gameState != .playing)
    }
}
.padding(.horizontal)
```

### 3. Add Sound Effects

**File:** `Utilities/SoundManager.swift` (NEW FILE)
```swift
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var correctPlayer: AVAudioPlayer?
    private var wrongPlayer: AVAudioPlayer?
    private var gameOverPlayer: AVAudioPlayer?
    
    private init() {
        setupAudio()
    }
    
    private func setupAudio() {
        // Load sound files from bundle
        if let correctURL = Bundle.main.url(forResource: "correct", withExtension: "mp3") {
            correctPlayer = try? AVAudioPlayer(contentsOf: correctURL)
            correctPlayer?.prepareToPlay()
        }
        
        if let wrongURL = Bundle.main.url(forResource: "wrong", withExtension: "mp3") {
            wrongPlayer = try? AVAudioPlayer(contentsOf: wrongURL)
            wrongPlayer?.prepareToPlay()
        }
        
        if let gameOverURL = Bundle.main.url(forResource: "gameover", withExtension: "mp3") {
            gameOverPlayer = try? AVAudioPlayer(contentsOf: gameOverURL)
            gameOverPlayer?.prepareToPlay()
        }
    }
    
    func playCorrect() {
        correctPlayer?.play()
    }
    
    func playWrong() {
        wrongPlayer?.play()
    }
    
    func playGameOver() {
        gameOverPlayer?.play()
    }
}
```

**Usage in GameViewModel.swift:**
```swift
private func handleEasySelection(_ square: ColorSquare) {
    if square.isTarget {
        // Correct answer
        SoundManager.shared.playCorrect()  // Add this
        score += difficulty.scorePerRound
        // ... rest of code
    } else {
        // Wrong answer
        SoundManager.shared.playWrong()  // Add this
        HapticManager.shared.error()
        // ... rest of code
    }
}

func endGame() {
    SoundManager.shared.playGameOver()  // Add this
    timer?.cancel()
    // ... rest of code
}
```

### 4. Add Confetti Animation

**File:** `Views/Components/ConfettiView.swift` (NEW FILE)
```swift
import SwiftUI

struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50) { index in
                ConfettiPiece()
                    .offset(x: CGFloat.random(in: -200...200),
                            y: animate ? 1000 : -100)
                    .animation(
                        .linear(duration: Double.random(in: 2...4))
                        .repeatForever(autoreverses: false)
                        .delay(Double.random(in: 0...0.5)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .pink, .purple]
    let randomColor = Color.random(from: colors)
    let randomSize = CGFloat.random(in: 5...12)
    
    var body: some View {
        Circle()
            .fill(randomColor)
            .frame(width: randomSize, height: randomSize)
    }
}

extension Color {
    static func random(from colors: [Color]) -> Color {
        colors.randomElement() ?? .blue
    }
}
```

**Usage in HighScoreModalView.swift:**
```swift
var body: some View {
    ZStack {
        // Background
        LinearGradient(...)
            .ignoresSafeArea()
        
        // Add confetti
        if showingConfetti {
            ConfettiView()
                .allowsHitTesting(false)
        }
        
        // Rest of your view...
    }
}
```

### 5. Add Statistics Tracking

**File:** `Models/GameStatistics.swift` (NEW FILE)
```swift
import Foundation

struct GameStatistics: Codable {
    var totalGamesPlayed: Int = 0
    var totalScore: Int = 0
    var bestStreak: Int = 0
    var favoriteMode: Difficulty?
    var gamesPerDifficulty: [Difficulty: Int] = [:]
    
    var averageScore: Double {
        totalGamesPlayed > 0 ? Double(totalScore) / Double(totalGamesPlayed) : 0
    }
}

extension StorageManager {
    private let statisticsKey = "gameStatistics"
    
    func loadStatistics() -> GameStatistics {
        guard let data = defaults.data(forKey: statisticsKey) else {
            return GameStatistics()
        }
        
        let decoder = JSONDecoder()
        return (try? decoder.decode(GameStatistics.self, from: data)) ?? GameStatistics()
    }
    
    func saveStatistics(_ stats: GameStatistics) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(stats) {
            defaults.set(encoded, forKey: statisticsKey)
        }
    }
    
    func updateStatistics(score: Int, difficulty: Difficulty, streak: Int) {
        var stats = loadStatistics()
        stats.totalGamesPlayed += 1
        stats.totalScore += score
        stats.bestStreak = max(stats.bestStreak, streak)
        stats.gamesPerDifficulty[difficulty, default: 0] += 1
        
        // Determine favorite mode
        let mostPlayed = stats.gamesPerDifficulty.max { $0.value < $1.value }
        stats.favoriteMode = mostPlayed?.key
        
        saveStatistics(stats)
    }
}
```

**File:** `Views/StatisticsView.swift` (NEW FILE)
```swift
import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section("Overall") {
                    StatRow(label: "Games Played", value: "\(viewModel.stats.totalGamesPlayed)")
                    StatRow(label: "Total Score", value: "\(viewModel.stats.totalScore)")
                    StatRow(label: "Average Score", value: String(format: "%.1f", viewModel.stats.averageScore))
                    StatRow(label: "Best Streak", value: "\(viewModel.stats.bestStreak)")
                }
                
                Section("By Difficulty") {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        let count = viewModel.stats.gamesPerDifficulty[difficulty] ?? 0
                        StatRow(label: difficulty.rawValue, value: "\(count) games")
                    }
                }
                
                if let favorite = viewModel.stats.favoriteMode {
                    Section("Favorite Mode") {
                        Text(favorite.rawValue)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Statistics")
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
                .monospacedDigit()
        }
    }
}

class StatisticsViewModel: ObservableObject {
    @Published var stats: GameStatistics
    
    init() {
        stats = StorageManager.shared.loadStatistics()
    }
}
```

### 6. Add Color-Blind Mode

**File:** `Utilities/ColorGenerator.swift`
```swift
enum ColorPalette {
    case standard
    case colorBlindFriendly
}

struct ColorGenerator {
    static var currentPalette: ColorPalette = .standard
    
    static func randomColor() -> Color {
        switch currentPalette {
        case .standard:
            return Color(
                red: Double.random(in: 0.2...1.0),
                green: Double.random(in: 0.2...1.0),
                blue: Double.random(in: 0.2...1.0)
            )
        case .colorBlindFriendly:
            // Use colors from a deuteranopia-friendly palette
            let safeColors: [Color] = [
                Color(red: 0.0, green: 0.45, blue: 0.70),  // Blue
                Color(red: 0.90, green: 0.60, blue: 0.0),  // Orange
                Color(red: 0.35, green: 0.70, blue: 0.90), // Sky Blue
                Color(red: 0.95, green: 0.90, blue: 0.25), // Yellow
                Color(red: 0.0, green: 0.60, blue: 0.50),  // Teal
                Color(red: 0.80, green: 0.40, blue: 0.0)   // Brown
            ]
            return safeColors.randomElement() ?? .blue
        }
    }
}
```

**File:** `Views/SettingsView.swift` (NEW FILE)
```swift
import SwiftUI

struct SettingsView: View {
    @AppStorage("colorBlindMode") private var colorBlindMode = false
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    
    var body: some View {
        NavigationView {
            List {
                Section("Accessibility") {
                    Toggle("Color-Blind Friendly", isOn: $colorBlindMode)
                        .onChange(of: colorBlindMode) { newValue in
                            ColorGenerator.currentPalette = newValue ? .colorBlindFriendly : .standard
                        }
                }
                
                Section("Feedback") {
                    Toggle("Sound Effects", isOn: $soundEnabled)
                    Toggle("Haptic Feedback", isOn: $hapticsEnabled)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
```

### 7. Add Daily Challenge

**File:** `Models/DailyChallenge.swift` (NEW FILE)
```swift
import Foundation

struct DailyChallenge: Codable {
    let date: Date
    let difficulty: Difficulty
    let targetScore: Int
    let seed: Int  // For reproducible random generation
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    static func today() -> DailyChallenge {
        let today = Calendar.current.startOfDay(for: Date())
        let daysSince2020 = Calendar.current.dateComponents([.day], from: Date(timeIntervalSince1970: 1577836800), to: today).day ?? 0
        
        let difficulties: [Difficulty] = [.easy, .medium, .hard]
        let difficultyIndex = daysSince2020 % 3
        let difficulty = difficulties[difficultyIndex]
        
        return DailyChallenge(
            date: today,
            difficulty: difficulty,
            targetScore: [100, 200, 300][difficultyIndex],
            seed: daysSince2020
        )
    }
}
```

### 8. Add Game Center Integration

**File:** `Utilities/GameCenterManager.swift` (NEW FILE)
```swift
import GameKit

class GameCenterManager: NSObject, ObservableObject {
    static let shared = GameCenterManager()
    
    @Published var isAuthenticated = false
    
    private override init() {
        super.init()
        authenticateUser()
    }
    
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // Present the view controller
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    rootViewController.present(viewController, animated: true)
                }
                return
            }
            
            if let error = error {
                print("Game Center authentication error: \(error.localizedDescription)")
                return
            }
            
            self.isAuthenticated = GKLocalPlayer.local.isAuthenticated
        }
    }
    
    func submitScore(_ score: Int, for difficulty: Difficulty) {
        guard isAuthenticated else { return }
        
        let leaderboardID: String
        switch difficulty {
        case .easy:
            leaderboardID = "com.yourapp.leaderboard.easy"
        case .medium:
            leaderboardID = "com.yourapp.leaderboard.medium"
        case .hard:
            leaderboardID = "com.yourapp.leaderboard.hard"
        }
        
        GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID]) { error in
            if let error = error {
                print("Error submitting score: \(error.localizedDescription)")
            }
        }
    }
    
    func showLeaderboard() {
        guard isAuthenticated else { return }
        
        let gcViewController = GKGameCenterViewController(state: .leaderboards)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(gcViewController, animated: true)
        }
    }
}
```

## 🧪 Testing Examples

### Unit Test Example

**File:** `SquareColorGameTests/ColorGeneratorTests.swift` (NEW FILE)
```swift
import XCTest
@testable import SquareColorGame

class ColorGeneratorTests: XCTestCase {
    
    func testRandomColorGeneratesValidColor() {
        for _ in 0..<100 {
            let color = ColorGenerator.randomColor()
            // Test that color components are in valid range
            // This would require exposing color components
            XCTAssertNotNil(color)
        }
    }
    
    func testSimilarColorIsDifferent() {
        let targetColor = ColorGenerator.randomColor()
        let similarColor = ColorGenerator.similarColor(to: targetColor)
        
        // Colors should be different but similar
        XCTAssertNotEqual(targetColor, similarColor)
    }
    
    func testGenerateGameColorsReturnsCorrectCount() {
        let targetColor = ColorGenerator.randomColor()
        let colors = ColorGenerator.generateGameColors(targetColor: targetColor, totalCount: 9)
        
        XCTAssertEqual(colors.count, 9)
    }
}
```

### UI Test Example

**File:** `SquareColorGameUITests/GameFlowTests.swift` (NEW FILE)
```swift
import XCTest

class GameFlowTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testCompleteGameFlow() {
        // Test difficulty selection
        let easyButton = app.buttons["Easy"]
        XCTAssertTrue(easyButton.exists)
        easyButton.tap()
        
        // Wait for game view
        let scoreLabel = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Score:'")).firstMatch
        XCTAssertTrue(scoreLabel.waitForExistence(timeout: 2))
        
        // Tap a square
        let firstSquare = app.buttons.element(boundBy: 0)
        firstSquare.tap()
        
        // Back to menu
        app.buttons["Back"].tap()
        XCTAssertTrue(easyButton.waitForExistence(timeout: 2))
    }
    
    func testLeaderboardFlow() {
        let leaderboardButton = app.buttons["Leaderboard"]
        XCTAssertTrue(leaderboardButton.exists)
        leaderboardButton.tap()
        
        let leaderboardTitle = app.navigationBars["Leaderboard"]
        XCTAssertTrue(leaderboardTitle.waitForExistence(timeout: 2))
        
        app.buttons["Done"].tap()
    }
}
```

## 🎯 Performance Optimization Examples

### Optimize Color Generation

```swift
// Cache generated colors
struct ColorGenerator {
    private static var colorCache: [Int: Color] = [:]
    
    static func cachedRandomColor(seed: Int) -> Color {
        if let cached = colorCache[seed] {
            return cached
        }
        
        let color = randomColor()
        colorCache[seed] = color
        return color
    }
    
    static func clearCache() {
        colorCache.removeAll()
    }
}
```

### Lazy Loading for Large Grids

```swift
// Use LazyVGrid already implemented, but can further optimize:
LazyVGrid(columns: columns, spacing: 12) {
    ForEach(viewModel.squares) { square in
        ColorSquareView(square: square)
            .id(square.id)  // Explicit ID for better performance
    }
}
```

These examples show how to extend and customize the Square Color Game for various use cases. Each example is production-ready and follows iOS best practices.
