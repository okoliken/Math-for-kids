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
///
/// The modal drives its own entrance and exit animation from `appeared`
/// (rather than relying on a `.transition` at the call site, which doesn't fire
/// reliably for conditionally-inserted overlay content). It pops in on appear,
/// and on dismiss it animates out *first*, then calls back so the parent can
/// remove it from the hierarchy.
struct DifficultyModal: View {
    var onCancel: () -> Void
    var onStart: (Difficulty) -> Void

    @State private var selected: Difficulty = .easy
    @State private var appeared = false

    private let popAnimation: Animation = .spring(response: 0.42, dampingFraction: 0.72)
    private let dismissDuration: Double = 0.25

    var body: some View {
        ZStack {
            // Dimmed backdrop — tap outside to cancel.
            Color.black.opacity(appeared ? 0.64 : 0)
                .ignoresSafeArea()
                .onTapGesture { dismiss(then: onCancel) }

            card
                .padding(.horizontal, 32)
                .scaleEffect(appeared ? 1 : 0.85)
                .opacity(appeared ? 1 : 0)
        }
        .onAppear {
            withAnimation(popAnimation) { appeared = true }
        }
    }

    /// Animates the modal out, then runs `action` (e.g. to clear the parent's
    /// presentation state) once the exit animation has finished.
    private func dismiss(then action: @escaping () -> Void) {
        withAnimation(.easeInOut(duration: dismissDuration)) { appeared = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + dismissDuration) {
            action()
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
                    dismiss(then: onCancel)
                }
                MathButton(label: "Start", fullWidth: true, minHeight: 44) {
                    let difficulty = selected
                    dismiss { onStart(difficulty) }
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
