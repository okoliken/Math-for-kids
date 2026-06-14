//
//  DifficultyModal.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 14/06/2026.
//

import SwiftUI

enum Difficulty: String, CaseIterable, Identifiable {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"

    var id: String { rawValue }
}

/// Difficulty picker shown before starting a level. Presented as a playful
/// pop-in card over a dimmed backdrop.
struct DifficultyModal: View {
    var onCancel: () -> Void
    var onStart: (Difficulty) -> Void

    @State private var selected: Difficulty = .easy

    var body: some View {
        ZStack {
            // Dimmed backdrop — tap outside to cancel.
            Color.black.opacity(0.64)
                .ignoresSafeArea()
                .transition(.opacity)
                .onTapGesture { onCancel() }

            card
                .padding(.horizontal, 32)
                .transition(.scale(scale: 0.8).combined(with: .opacity))
        }
    }

    private var card: some View {
        VStack(spacing: 28) {
            Text("Difficulty")
                .font(.LilitaOne(size: .xlg))
                .foregroundStyle(.textPrimary)

            VStack {
                ForEach(Difficulty.allCases) { difficulty in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            selected = difficulty
                        }
                    } label: {
                        HStack {
                            Text(difficulty.rawValue)
                                .font(.LilitaOne(size: .md))
                                .foregroundStyle(.textPrimary)

                            Spacer()

                            radio(isSelected: selected == difficulty)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .padding(12)
                    .frame(height: 56)
                }
            }
            .padding(.top, 8)

            HStack(spacing: 16) {
                MathButton(label: "Cancel", brandStyle: .secondary, fullWidth: true, minHeight: 44) {
                    onCancel()
                }
                MathButton(label: "Start", fullWidth: true, minHeight: 44) {
                    onStart(selected)
                }
            }
            .padding(.bottom, 24)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .cardSurface(cornerRadius: 16, borderWidths: .init(top: 4, leading: 4, bottom: 8, trailing: 4), fillColor: .borderSecondary)
    }

    private func radio(isSelected: Bool) -> some View {
        ZStack {
            Circle()
                .fill(isSelected ? Color.brandContent : Color.clear)
                .overlay(
                    Circle().strokeBorder(
                        isSelected ? Color.brandContent : Color.borderSecondary,
                        lineWidth: 2.67
                    )
                )

            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 27, height: 27)
    }
}

#Preview {
    ZStack {
        Color.gray
        DifficultyModal(onCancel: {}, onStart: { _ in })
    }
}
