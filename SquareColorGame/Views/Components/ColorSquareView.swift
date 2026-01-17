//
//  ColorSquareView.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import SwiftUI

struct ColorSquareView: View {
    let square: ColorSquare
    let isSelected: Bool
    let isHighlighted: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(square.color)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            
            if let shape = square.shape {
                Image(systemName: shape.icon)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2)
            }
            
            if isSelected {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.white, lineWidth: 4)
            }
            
            if isHighlighted {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.yellow, lineWidth: 4)
                    .shadow(color: .yellow.opacity(0.5), radius: 8)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .scaleEffect(isHighlighted ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHighlighted)
    }
}
