//
//  GameView.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(difficulty: Difficulty) {
        _viewModel = StateObject(wrappedValue: GameViewModel(difficulty: difficulty))
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        HapticManager.shared.selection()
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text(viewModel.difficulty.rawValue)
                            .font(.headline)
                        Text("Score: \(viewModel.score)")
                            .font(.title)
                            .fontWeight(.bold)
                            .monospacedDigit()
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(viewModel.streak)")
                            .font(.headline)
                            .monospacedDigit()
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Timer
                TimerBarView(
                    timeRemaining: viewModel.timeRemaining,
                    maxTime: viewModel.difficulty.initialTime
                )
                .padding(.horizontal)
                
                // Target Display
                if !viewModel.targetSquares.isEmpty {
                    VStack(spacing: 12) {
                        Text("Target:")
                            .font(.headline)
                        
                        HStack(spacing: 16) {
                            ForEach(Array(viewModel.targetSquares.enumerated()), id: \.element.id) { index, square in
                                ColorSquareView(
                                    square: square,
                                    isSelected: false,
                                    isHighlighted: viewModel.gameState == .showingSequence && index < viewModel.currentSequenceIndex
                                )
                                .frame(width: 80, height: 80)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.8))
                            .shadow(radius: 4)
                    )
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Game Grid
                if viewModel.gameState == .playing || viewModel.gameState == .showingSequence {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
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
                }
                
                Spacer()
            }
            
            // Feedback Overlay
            if viewModel.showFeedback {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        Image(systemName: viewModel.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(viewModel.isCorrect ? .green : .red)
                        
                        Text(viewModel.isCorrect ? "Correct!" : "Try Again")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .scaleEffect(viewModel.showFeedback ? 1.0 : 0.5)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.showFeedback)
                }
            }
            
            // Game Over Overlay
            if viewModel.gameState == .gameOver {
                GameOverView(
                    score: viewModel.score,
                    difficulty: viewModel.difficulty,
                    onRestart: {
                        viewModel.restartGame()
                    },
                    onExit: {
                        dismiss()
                    }
                )
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if viewModel.gameState == .ready {
                viewModel.startGame()
            }
        }
        .sheet(isPresented: $viewModel.showHighScoreModal) {
            HighScoreModalView(
                score: viewModel.score,
                difficulty: viewModel.difficulty,
                onSave: { nickname in
                    viewModel.saveHighScore(nickname: nickname)
                }
            )
        }
    }
}

struct GameOverView: View {
    let score: Int
    let difficulty: Difficulty
    let onRestart: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Game Over!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    Text("Final Score")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(score)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .monospacedDigit()
                    
                    Text(difficulty.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.1))
                )
                
                VStack(spacing: 16) {
                    Button(action: onRestart) {
                        Text("Play Again")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    
                    Button(action: onExit) {
                        Text("Back to Menu")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 40)
            }
        }
    }
}
