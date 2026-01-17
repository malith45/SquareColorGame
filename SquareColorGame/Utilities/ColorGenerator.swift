//
//  ColorGenerator.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import SwiftUI

struct ColorGenerator {
    // Generate a random vibrant color
    static func randomColor() -> Color {
        Color(
            red: Double.random(in: 0.2...1.0),
            green: Double.random(in: 0.2...1.0),
            blue: Double.random(in: 0.2...1.0)
        )
    }
    
    // Generate a similar color with slight variation
    static func similarColor(to color: Color, variation: Double = 0.15) -> Color {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let newRed = max(0, min(1, red + CGFloat.random(in: -variation...variation)))
        let newGreen = max(0, min(1, green + CGFloat.random(in: -variation...variation)))
        let newBlue = max(0, min(1, blue + CGFloat.random(in: -variation...variation)))
        
        return Color(red: newRed, green: newGreen, blue: newBlue)
    }
    
    // Generate array of distinct colors
    static func distinctColors(count: Int) -> [Color] {
        var colors: [Color] = []
        for _ in 0..<count {
            colors.append(randomColor())
        }
        return colors
    }
    
    // Generate colors for game grid
    static func generateGameColors(targetColor: Color, totalCount: Int = 9) -> [Color] {
        var colors: [Color] = [targetColor]
        
        // Generate similar colors for other squares
        for _ in 1..<totalCount {
            colors.append(similarColor(to: targetColor, variation: 0.2))
        }
        
        return colors.shuffled()
    }
}
