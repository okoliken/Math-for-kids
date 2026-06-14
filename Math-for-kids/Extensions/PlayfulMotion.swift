//
//  PlayfulMotion.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 14/06/2026.
//
//  Small, reusable motion helpers that give the app a fun, lively feel —
//  springy entrances and bouncy tactile feedback rather than static UI.

import SwiftUI

extension View {
    /// Springy staggered entrance: the view fades in, rises, and settles with a
    /// bounce, delayed by its position so a list cascades in one item at a time.
    func staggeredAppear(_ index: Int, baseDelay: Double = 0.06) -> some View {
        modifier(StaggeredAppear(index: index, baseDelay: baseDelay))
    }
}

private struct StaggeredAppear: ViewModifier {
    let index: Int
    let baseDelay: Double
    @State private var shown = false

    func body(content: Content) -> some View {
        content
            .opacity(shown ? 1 : 0)
            .scaleEffect(shown ? 1 : 0.94, anchor: .center)
            .offset(y: shown ? 0 : 18)
            .onAppear {
                // Cap the delay so long lists still finish promptly.
                let delay = Double(min(index, 8)) * baseDelay
                withAnimation(.spring(response: 0.45, dampingFraction: 0.7).delay(delay)) {
                    shown = true
                }
            }
            .onDisappear { shown = false }
    }
}

/// A button style with a springy press bounce — playful, tactile feedback.
struct BouncyButtonStyle: ButtonStyle {
    var pressedScale: CGFloat = 0.86

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}
