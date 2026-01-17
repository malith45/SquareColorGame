//
//  ColorSquare.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import SwiftUI

struct ColorSquare: Identifiable, Equatable {
    let id = UUID()
    let color: Color
    let shape: GameShape?
    let isTarget: Bool
    
    init(color: Color, shape: GameShape? = nil, isTarget: Bool = false) {
        self.color = color
        self.shape = shape
        self.isTarget = isTarget
    }
    
    static func == (lhs: ColorSquare, rhs: ColorSquare) -> Bool {
        lhs.id == rhs.id
    }
}
