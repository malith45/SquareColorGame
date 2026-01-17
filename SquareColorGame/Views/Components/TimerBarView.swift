//
//  TimerBarView.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import SwiftUI

struct TimerBarView: View {
    let timeRemaining: TimeInterval
    let maxTime: TimeInterval
    
    private var progress: Double {
        max(0, min(1, timeRemaining / maxTime))
    }
    
    private var timerColor: Color {
        if progress > 0.5 {
            return .green
        } else if progress > 0.25 {
            return .orange
        } else {
            return .red
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(timerColor)
                Text(String(format: "%.1f", timeRemaining))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(timerColor)
                    .monospacedDigit()
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.secondary.opacity(0.2))
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [timerColor, timerColor.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress)
                        .animation(.linear(duration: 0.1), value: progress)
                }
            }
            .frame(height: 12)
        }
    }
}
