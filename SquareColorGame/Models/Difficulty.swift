//
//  Difficulty.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import Foundation

enum Difficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var description: String {
        switch self {
        case .easy:
            return "Match the target color from a 3×3 grid"
        case .medium:
            return "Match 2 colors in the correct sequence"
        case .hard:
            return "Match shapes and colors in sequence"
        }
    }
    
    var icon: String {
        switch self {
        case .easy:
            return "square.fill"
        case .medium:
            return "square.stack.3d.up.fill"
        case .hard:
            return "star.fill"
        }
    }
    
    var initialTime: TimeInterval {
        switch self {
        case .easy:
            return 10
        case .medium:
            return 8
        case .hard:
            return 6
        }
    }
    
    var timeBonus: TimeInterval {
        switch self {
        case .easy:
            return 2
        case .medium:
            return 3
        case .hard:
            return 4
        }
    }
    
    var scorePerRound: Int {
        switch self {
        case .easy:
            return 10
        case .medium:
            return 20
        case .hard:
            return 30
        }
    }
}
