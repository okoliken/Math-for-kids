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

    /// A quick side-to-side wiggle that fires whenever `trigger` flips to `true`
    /// — a friendly "look here!" jitter to draw a child's eye to a button.
    func wiggle(trigger: Bool) -> some View {
        modifier(Wiggle(trigger: trigger))
    }
}

/// Drives a horizontal shake by oscillating a sine wave as `animatableData`
/// sweeps 0 → 1, returning to centre at the end.
private struct ShakeEffect: GeometryEffect {
    /// Maximum horizontal travel, in points.
    var travel: CGFloat = 7
    /// Number of full back-and-forth shakes.
    var shakes: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let dx = travel * sin(animatableData * .pi * shakes)
        return ProjectionTransform(CGAffineTransform(translationX: dx, y: 0))
    }
}

private struct Wiggle: ViewModifier {
    let trigger: Bool
    @State private var shake: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(animatableData: shake))
            .onChange(of: trigger) { _, isOn in
                if isOn { fire() }
            }
            .onAppear { if trigger { fire() } }
    }

    private func fire() {
        shake = 0
        withAnimation(.easeInOut(duration: 0.5)) { shake = 3 }
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
