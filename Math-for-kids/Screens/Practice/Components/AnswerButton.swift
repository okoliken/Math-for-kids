//
//  AnswerButton.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 14/06/2026.
//

import SwiftUI

/// Visual state of an answer option once the learner has (or hasn't) committed.
enum AnswerState {
    case idle
    case correct
    case wrong
}

/// One option in the 2×2 answer grid. Rendered as a 3D pill that re-tints to
/// green or red to confirm the learner's choice.
struct AnswerButton: View {
    let value: Int
    var state: AnswerState = .idle
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(value)")
                .font(.LilitaOne(size: .lg))
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(borderColor)
                            .offset(y: 6)
                        RoundedRectangle(cornerRadius: 12)
                            .fill(fillColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(borderColor, lineWidth: 3)
                            )
                    }
                )
        }
        .buttonStyle(.plain)
    }

    private var fillColor: Color {
        switch state {
        case .idle: return Color(.surfaceSecondary)
        case .correct: return Color(.successSurface)
        case .wrong: return Color(.errorSurface)
        }
    }

    private var borderColor: Color {
        switch state {
        case .idle: return Color(.borderSecondary)
        case .correct: return Color(.successBorder)
        case .wrong: return Color(.errorBorder)
        }
    }

    private var textColor: Color {
        switch state {
        case .idle: return .textPrimary
        case .correct: return Color(.successBorder)
        case .wrong: return Color(.errorBorder)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 16) {
            AnswerButton(value: 64, state: .wrong) {}
            AnswerButton(value: 82, state: .correct) {}
        }
        HStack(spacing: 16) {
            AnswerButton(value: 100) {}
            AnswerButton(value: 99) {}
        }
    }
    .padding()
}
