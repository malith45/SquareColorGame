//
//  GameViewModel.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var gameState: GameState = .ready
    @Published var score: Int = 0
    @Published var streak: Int = 0
    @Published var timeRemaining: TimeInterval = 10
    @Published var squares: [ColorSquare] = []
    @Published var targetSquares: [ColorSquare] = []
    @Published var selectedSquares: [ColorSquare] = []
    @Published var showFeedback: Bool = false
    @Published var isCorrect: Bool = false
    @Published var showHighScoreModal: Bool = false
    @Published var currentSequenceIndex: Int = 0
    
    let difficulty: Difficulty
    private var timer: AnyCancellable?
    private var targetColor: Color = .red
    private var correctSquares: [ColorSquare] = []
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        self.timeRemaining = difficulty.initialTime
    }
    
    func startGame() {
        score = 0
        streak = 0
        timeRemaining = difficulty.initialTime
        gameState = .playing
        setupNewRound()
        startTimer()
    }
    
    func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.gameState == .playing {
                    self.timeRemaining -= 0.1
                    if self.timeRemaining <= 0 {
                        self.endGame()
                    }
                }
            }
    }
    
    func setupNewRound() {
        selectedSquares = []
        currentSequenceIndex = 0
        
        switch difficulty {
        case .easy:
            setupEasyMode()
        case .medium:
            setupMediumMode()
        case .hard:
            setupHardMode()
        }
    }
    
    private func setupEasyMode() {
        targetColor = ColorGenerator.randomColor()
        let targetSquare = ColorSquare(color: targetColor, isTarget: true)
        targetSquares = [targetSquare]
        correctSquares = [targetSquare]
        
        // Generate grid with one matching square
        var gridSquares: [ColorSquare] = [targetSquare]
        for _ in 1..<9 {
            gridSquares.append(ColorSquare(color: ColorGenerator.similarColor(to: targetColor)))
        }
        squares = gridSquares.shuffled()
    }
    
    private func setupMediumMode() {
        // Generate 2 distinct target colors
        let colors = ColorGenerator.distinctColors(count: 2)
        let target1 = ColorSquare(color: colors[0], isTarget: true)
        let target2 = ColorSquare(color: colors[1], isTarget: true)
        
        targetSquares = [target1, target2]
        correctSquares = [target1, target2]
        
        // Generate grid with both target colors and similar colors
        var gridSquares: [ColorSquare] = [target1, target2]
        for color in colors {
            for _ in 0..<3 {
                gridSquares.append(ColorSquare(color: ColorGenerator.similarColor(to: color, variation: 0.15)))
            }
        }
        
        // Ensure we have exactly 9 squares
        while gridSquares.count > 9 {
            gridSquares.removeLast()
        }
        
        squares = gridSquares.shuffled()
        
        // Show sequence animation
        showSequence()
    }
    
    private func setupHardMode() {
        // Generate 2 distinct colors and shapes
        let colors = ColorGenerator.distinctColors(count: 2)
        let shapes = GameShape.allCases.shuffled().prefix(2)
        
        let target1 = ColorSquare(color: colors[0], shape: shapes[0], isTarget: true)
        let target2 = ColorSquare(color: colors[1], shape: shapes[1], isTarget: true)
        
        targetSquares = [target1, target2]
        correctSquares = [target1, target2]
        
        // Generate grid with various shape/color combinations
        var gridSquares: [ColorSquare] = [target1, target2]
        
        for i in 0..<7 {
            let randomColor = i < 3 ? ColorGenerator.similarColor(to: colors[0]) : ColorGenerator.similarColor(to: colors[1])
            let randomShape = GameShape.allCases.randomElement()!
            gridSquares.append(ColorSquare(color: randomColor, shape: randomShape))
        }
        
        squares = gridSquares.shuffled()
        
        // Show sequence animation
        showSequence()
    }
    
    private func showSequence() {
        gameState = .showingSequence
        currentSequenceIndex = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.highlightNextInSequence()
        }
    }
    
    private func highlightNextInSequence() {
        if currentSequenceIndex < targetSquares.count {
            currentSequenceIndex += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.highlightNextInSequence()
            }
        } else {
            gameState = .playing
        }
    }
    
    func selectSquare(_ square: ColorSquare) {
        guard gameState == .playing else { return }
        
        switch difficulty {
        case .easy:
            handleEasySelection(square)
        case .medium, .hard:
            handleSequenceSelection(square)
        }
    }
    
    private func handleEasySelection(_ square: ColorSquare) {
        if square.isTarget {
            // Correct answer
            score += difficulty.scorePerRound
            streak += 1
            timeRemaining += difficulty.timeBonus
            isCorrect = true
            HapticManager.shared.success()
            showFeedbackAnimation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.setupNewRound()
            }
        } else {
            // Wrong answer - just continue
            HapticManager.shared.error()
            isCorrect = false
            showFeedbackAnimation()
        }
    }
    
    private func handleSequenceSelection(_ square: ColorSquare) {
        selectedSquares.append(square)
        
        // Check if this selection is correct so far
        let currentIndex = selectedSquares.count - 1
        if currentIndex < correctSquares.count {
            let expectedSquare = correctSquares[currentIndex]
            
            // For medium mode, check color match
            // For hard mode, check both color and shape match
            let isMatch: Bool
            if difficulty == .medium {
                isMatch = colorsMatch(square.color, expectedSquare.color)
            } else {
                isMatch = colorsMatch(square.color, expectedSquare.color) && square.shape == expectedSquare.shape
            }
            
            if !isMatch {
                // Wrong selection - game over
                gameState = .gameOver
                streak = 0
                HapticManager.shared.error()
                checkForHighScore()
                return
            }
            
            // Check if sequence is complete
            if selectedSquares.count == correctSquares.count {
                // Correct sequence!
                score += difficulty.scorePerRound
                streak += 1
                timeRemaining += difficulty.timeBonus
                isCorrect = true
                HapticManager.shared.success()
                showFeedbackAnimation()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.setupNewRound()
                }
            }
        }
    }
    
    private func colorsMatch(_ color1: Color, _ color2: Color) -> Bool {
        let ui1 = UIColor(color1)
        let ui2 = UIColor(color2)
        
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        ui1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        ui2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let threshold: CGFloat = 0.01
        return abs(r1 - r2) < threshold && abs(g1 - g2) < threshold && abs(b1 - b2) < threshold
    }
    
    private func showFeedbackAnimation() {
        showFeedback = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.showFeedback = false
        }
    }
    
    func endGame() {
        timer?.cancel()
        gameState = .gameOver
        streak = 0
        checkForHighScore()
    }
    
    private func checkForHighScore() {
        if StorageManager.shared.isHighScore(score, difficulty: difficulty) {
            showHighScoreModal = true
        }
    }
    
    func saveHighScore(nickname: String) {
        let highScore = HighScore(nickname: nickname, score: score, difficulty: difficulty)
        StorageManager.shared.addHighScore(highScore)
        showHighScoreModal = false
    }
    
    func restartGame() {
        startGame()
    }
}
