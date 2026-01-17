//
//  LeaderboardView.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.orange.opacity(0.2), Color.pink.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Difficulty Picker
                    Picker("Difficulty", selection: $viewModel.selectedDifficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.rawValue).tag(difficulty)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .onChange(of: viewModel.selectedDifficulty) { newValue in
                        viewModel.changeDifficulty(newValue)
                    }
                    
                    // Trophy Header
                    HStack {
                        Image(systemName: "trophy.fill")
                            .font(.title)
                            .foregroundColor(.orange)
                        Text("Top Scores")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.top)
                    
                    // Leaderboard List
                    if viewModel.highScores.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "star.slash")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            
                            Text("No scores yet")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Be the first to set a record!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(Array(viewModel.highScores.enumerated()), id: \.element.id) { index, score in
                                    LeaderboardRowView(
                                        position: index,
                                        highScore: score,
                                        medal: viewModel.getMedalIcon(for: index)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Leaderboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct LeaderboardRowView: View {
    let position: Int
    let highScore: HighScore
    let medal: String
    
    private var rankColor: Color {
        switch position {
        case 0: return .yellow
        case 1: return .gray
        case 2: return .orange
        default: return .blue
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Medal/Position
            Text(medal)
                .font(.system(size: 40))
                .frame(width: 50)
            
            // Nickname
            VStack(alignment: .leading, spacing: 4) {
                Text(highScore.nickname)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(highScore.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Score
            Text("\(highScore.score)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(rankColor)
                .monospacedDigit()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.8))
                .shadow(color: rankColor.opacity(0.3), radius: 4, x: 0, y: 2)
        )
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
