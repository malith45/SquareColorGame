//
//  DifficultySelectionView.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import SwiftUI

struct DifficultySelectionView: View {
    @State private var showInstructions = false
    @State private var showLeaderboard = false
    @State private var selectedDifficulty: Difficulty? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Title
                    VStack(spacing: 8) {
                        Text("Square Color Game")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                        
                        Text("Test your color matching skills!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // Difficulty Cards
                    VStack(spacing: 20) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            NavigationLink(
                                destination: GameView(difficulty: difficulty),
                                tag: difficulty,
                                selection: $selectedDifficulty
                            ) {
                                EmptyView()
                            }
                            .hidden()
                            
                            DifficultyCardView(difficulty: difficulty) {
                                selectedDifficulty = difficulty
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Bottom Buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            HapticManager.shared.selection()
                            showInstructions = true
                        }) {
                            Label("How to Play", systemImage: "info.circle.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            HapticManager.shared.selection()
                            showLeaderboard = true
                        }) {
                            Label("Leaderboard", systemImage: "trophy.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showInstructions) {
                InstructionsView()
            }
            .sheet(isPresented: $showLeaderboard) {
                LeaderboardView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DifficultySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DifficultySelectionView()
    }
}
