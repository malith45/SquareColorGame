//
//  LeaderboardViewModel.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import SwiftUI

class LeaderboardViewModel: ObservableObject {
    @Published var selectedDifficulty: Difficulty = .easy
    @Published var highScores: [HighScore] = []
    
    init() {
        loadHighScores()
    }
    
    func loadHighScores() {
        highScores = StorageManager.shared.getTopScores(for: selectedDifficulty)
    }
    
    func changeDifficulty(_ difficulty: Difficulty) {
        selectedDifficulty = difficulty
        loadHighScores()
    }
    
    func getMedalIcon(for position: Int) -> String {
        switch position {
        case 0:
            return "🥇"
        case 1:
            return "🥈"
        case 2:
            return "🥉"
        default:
            return ""
        }
    }
}
