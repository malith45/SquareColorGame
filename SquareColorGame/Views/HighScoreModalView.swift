//
//  HighScoreModalView.swift
//  SquareColorGame
//
//  Created on 2026-01-17
//

import SwiftUI

struct HighScoreModalView: View {
    let score: Int
    let difficulty: Difficulty
    let onSave: (String) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var nickname: String = ""
    @State private var showingConfetti = false
    @FocusState private var isTextFieldFocused: Bool
    
    private let maxNicknameLength = 15
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Celebration Icon
                VStack(spacing: 20) {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.yellow)
                        .shadow(color: .yellow.opacity(0.5), radius: 20)
                        .scaleEffect(showingConfetti ? 1.2 : 1.0)
                        .animation(
                            .spring(response: 0.5, dampingFraction: 0.5)
                            .repeatForever(autoreverses: true),
                            value: showingConfetti
                        )
                    
                    Text("New High Score!")
                        .font(.system(size: 36, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    Text("You made it to the top 3!")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                // Score Display
                VStack(spacing: 8) {
                    Text("\(score)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                        .monospacedDigit()
                    
                    Text(difficulty.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.8))
                        .shadow(radius: 4)
                )
                
                // Nickname Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter your nickname:")
                        .font(.headline)
                    
                    TextField("Nickname", text: $nickname)
                        .textFieldStyle(.roundedBorder)
                        .focused($isTextFieldFocused)
                        .onChange(of: nickname) { newValue in
                            if newValue.count > maxNicknameLength {
                                nickname = String(newValue.prefix(maxNicknameLength))
                            }
                        }
                        .submitLabel(.done)
                        .onSubmit {
                            saveScore()
                        }
                    
                    Text("\(nickname.count)/\(maxNicknameLength)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 40)
                
                // Save Button
                Button(action: saveScore) {
                    Text("Save Score")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            nickname.isEmpty ? Color.gray : Color.green
                        )
                        .cornerRadius(12)
                }
                .disabled(nickname.isEmpty)
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            showingConfetti = true
            isTextFieldFocused = true
            HapticManager.shared.success()
        }
        .interactiveDismissDisabled()
    }
    
    private func saveScore() {
        guard !nickname.isEmpty else { return }
        HapticManager.shared.success()
        onSave(nickname)
        dismiss()
    }
}

struct HighScoreModalView_Previews: PreviewProvider {
    static var previews: some View {
        HighScoreModalView(score: 250, difficulty: .medium) { _ in }
    }
}
