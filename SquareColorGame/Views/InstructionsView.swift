//
//  InstructionsView.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import SwiftUI

struct InstructionsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0
    
    private let pages: [InstructionPage] = [
        InstructionPage(
            icon: "gamecontroller.fill",
            title: "Welcome!",
            description: "Square Color Game tests your color matching skills across three difficulty levels.",
            color: .blue
        ),
        InstructionPage(
            icon: "square.fill",
            title: "Easy Mode",
            description: "Match the target color from a 3×3 grid. Find the exact matching square!\n\n+10 points per round\n+2 seconds per correct answer",
            color: .green
        ),
        InstructionPage(
            icon: "square.stack.3d.up.fill",
            title: "Medium Mode",
            description: "Watch the sequence of 2 colors, then tap them in the same order. One mistake ends the game!\n\n+20 points per round\n+3 seconds per correct answer",
            color: .orange
        ),
        InstructionPage(
            icon: "star.fill",
            title: "Hard Mode",
            description: "Match shapes AND colors in sequence. The ultimate challenge!\n\n+30 points per round\n+4 seconds per correct answer",
            color: .red
        ),
        InstructionPage(
            icon: "trophy.fill",
            title: "Compete!",
            description: "Beat the clock and climb the leaderboard. Top 3 scores per difficulty are saved!",
            color: .purple
        )
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        InstructionPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        dismiss()
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Next" : "Got It!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("How to Play")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct InstructionPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct InstructionPageView: View {
    let page: InstructionPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundColor(page.color)
                .padding()
                .background(
                    Circle()
                        .fill(page.color.opacity(0.2))
                        .frame(width: 150, height: 150)
                )
            
            Text(page.title)
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding()
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
