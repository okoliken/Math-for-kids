//
//  BoardModal.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 15/06/2026.
//

import PencilKit
import SwiftUI

/// A chalkboard scratch pad. Lets a learner work a problem out by hand when they
/// can't do it in their head — purely a thinking space, it doesn't change the
/// answer or the timer.
struct BoardModal: View {
    @Binding var drawing: PKDrawing
    var onClose: () -> Void

    @State private var controller = DrawingCanvasController()

    /// The chalkboard's signature green, matching the question card.
    private let boardGreen = Color(red: 0.30, green: 0.64, blue: 0.37)

    var body: some View {
        ZStack {
            // Dimmed backdrop — tap outside to dismiss.
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .transition(.opacity)
                .onTapGesture { onClose() }

            card
                .padding(.horizontal, 24)
                .transition(.scale.combined(with: .opacity))
        }
    }

    private var card: some View {
        VStack(spacing: 20) {
            header

            chalkboard
                .frame(height: 380)

            MathButton(label: "Close", brandStyle: .secondary, fullWidth: true, minHeight: 44) {
                onClose()
            }
        }
        .padding(20)
        .cardSurface(cornerRadius: 16, borderWidths: .init(top: 4, leading: 4, bottom: 8, trailing: 4), fillColor: .borderSecondary)
    }

    private var header: some View {
        ZStack {
            Text("Board")
                .font(.LilitaOne(size: .lg))
                .foregroundStyle(.textPrimary)

            toolbar
        }
    }

    private var chalkboard: some View {
        DrawingCanvas(drawing: $drawing, controller: controller)
            .background(boardGreen)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                UnevenBorderShape(
                    cornerRadius: 16,
                    borderWidths: .init(top: 4, leading: 4, bottom: 8, trailing: 4)
                )
                .fill(Color.textPrimary, style: FillStyle(eoFill: true))
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var toolbar: some View {
        HStack(spacing: 12) {
            toolButton(icon: "arrow.uturn.backward", enabled: controller.canUndo) {
                controller.undo()
            }
            toolButton(icon: "arrow.uturn.forward", enabled: controller.canRedo) {
                controller.redo()
            }

            Spacer()

            toolButton(
                icon: "trash",
                enabled: !drawing.strokes.isEmpty,
                tint: Color(.errorContent)
            ) {
                controller.clear()
            }
        }
    }

    private func toolButton(
        icon: String,
        enabled: Bool,
        tint: Color = .textPrimary,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(enabled ? tint : tint.opacity(0.3))
                .frame(width: 44, height: 44)
                .background(Circle().fill(Color(.surfaceSecondary)))
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(!enabled)
    }
}

#Preview {
    ZStack {
        Color.gray
        BoardModal(drawing: .constant(PKDrawing()), onClose: {})
    }
}
