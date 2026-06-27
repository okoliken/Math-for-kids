//
//  HintModal.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 14/06/2026.
//

import SwiftUI

/// Bottom sheet offering a hint. Taking the hint auto-completes the current
/// question, so it's gated behind a confirmation and a limited number of uses.
struct HintModal: View {
    let hintsRemaining: Int
    var onClose: () -> Void
    var onGetHint: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            // Dimmed backdrop — tap outside to dismiss.
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .transition(.opacity)
                .onTapGesture { onClose() }

            sheet
        }
    }

    private var sheet: some View {
        VStack(spacing: 24) {
            // Grabber
            Capsule()
                .fill(Color(.borderSecondary))
                .frame(width: 44, height: 5)
                .padding(.top, 10)

            ZStack {
                Circle()
                    .fill(Color(.warningContent).opacity(0.2))
                    .frame(width: 72, height: 72)
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(Color(.warningContent))
            }

            Text("You have \(hintsRemaining) chances for getting a hint! If you click “Get Hint” the correct answer will be highlighted for you")
                .font(.LilitaOne(size: .sm))
                .foregroundStyle(.textPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)

            HStack(spacing: 16) {
                MathButton(label: "Close", brandStyle: .secondary, fullWidth: true, minHeight: 52) {
                    onClose()
                }
                MathButton(label: "Get Hint", fullWidth: true, minHeight: 52) {
                    onGetHint()
                }
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        // Let the white surface bleed past the bottom safe area; keeping the
        // safe-area extension on the background (not the clipped content) means
        // the sheet actually reaches the screen edge.
        .background(
            TopRoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

#Preview {
    ZStack {
        Color.gray
        HintModal(hintsRemaining: 3, onClose: {}, onGetHint: {})
    }
}
