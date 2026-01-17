//
//  StorageManager.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let highScoresKey = "highScores"
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // Save high scores
    func saveHighScores(_ scores: [HighScore]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(scores) {
            defaults.set(encoded, forKey: highScoresKey)
        }
    }
    
    // Load high scores
    func loadHighScores() -> [HighScore] {
        guard let data = defaults.data(forKey: highScoresKey) else {
            return []
        }
        
        let decoder = JSONDecoder()
        if let scores = try? decoder.decode([HighScore].self, from: data) {
            return scores
        }
        return []
    }
    
    // Get top scores for a difficulty
    func getTopScores(for difficulty: Difficulty, limit: Int = 3) -> [HighScore] {
        let allScores = loadHighScores()
        return allScores
            .filter { $0.difficulty == difficulty }
            .sorted { $0.score > $1.score }
            .prefix(limit)
            .map { $0 }
    }
    
    // Check if score qualifies for leaderboard
    func isHighScore(_ score: Int, difficulty: Difficulty) -> Bool {
        let topScores = getTopScores(for: difficulty)
        if topScores.count < 3 {
            return true
        }
        return score > (topScores.last?.score ?? 0)
    }
    
    // Add a new high score
    func addHighScore(_ highScore: HighScore) {
        var allScores = loadHighScores()
        allScores.append(highScore)
        
        // Keep only top 3 per difficulty
        let difficulty = highScore.difficulty
        var difficultyScores = allScores.filter { $0.difficulty == difficulty }
            .sorted { $0.score > $1.score }
            .prefix(3)
            .map { $0 }
        
        let otherScores = allScores.filter { $0.difficulty != difficulty }
        allScores = otherScores + difficultyScores
        
        saveHighScores(allScores)
    }
}
