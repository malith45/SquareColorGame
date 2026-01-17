//
//  HighScore.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import Foundation

struct HighScore: Codable, Identifiable {
    let id: UUID
    let nickname: String
    let score: Int
    let difficulty: Difficulty
    let date: Date
    
    init(id: UUID = UUID(), nickname: String, score: Int, difficulty: Difficulty, date: Date = Date()) {
        self.id = id
        self.nickname = nickname
        self.score = score
        self.difficulty = difficulty
        self.date = date
    }
}
