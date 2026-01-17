//
//  Shape.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import Foundation

enum GameShape: String, CaseIterable, Codable {
    case circle
    case square
    case triangle
    case star
    case diamond
    case heart
    
    var icon: String {
        switch self {
        case .circle:
            return "circle.fill"
        case .square:
            return "square.fill"
        case .triangle:
            return "triangle.fill"
        case .star:
            return "star.fill"
        case .diamond:
            return "diamond.fill"
        case .heart:
            return "heart.fill"
        }
    }
}
