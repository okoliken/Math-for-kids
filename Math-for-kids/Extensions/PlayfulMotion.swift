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

    /// Springy entrance keyed to an external `isActive` flag with an explicit
    /// `delay`, so a parent can choreograph several elements into a precise,
    /// hand-tuned sequence (rather than the auto-staggering of `staggeredAppear`).
    func revealStep(_ isActive: Bool, delay: Double, offsetY: CGFloat = 22) -> some View {
        modifier(RevealStep(isActive: isActive, delay: delay, offsetY: offsetY))
    }
}

private struct RevealStep: ViewModifier {
    let isActive: Bool
    let delay: Double
    let offsetY: CGFloat

    func body(content: Content) -> some View {
        content
            .opacity(isActive ? 1 : 0)
            .scaleEffect(isActive ? 1 : 0.9, anchor: .center)
            .offset(y: isActive ? 0 : offsetY)
            .animation(.spring(response: 0.5, dampingFraction: 0.68).delay(delay), value: isActive)
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

/// A button that gives a springy "pop" bounce on every tap — playful, tactile
/// feedback for icon buttons.
///
/// The bounce is driven by the tap *action*, not `ButtonStyle.isPressed`, on
/// purpose: inside a `ScrollView`, SwiftUI delays flipping `isPressed` to true
/// so it can tell a tap from a scroll drag, which means an `isPressed`-based
/// bounce only shows if you press and hold. Firing the pop from the action makes
/// the feedback play in full on a quick tap, anywhere.
struct BouncyButton<Label: View>: View {
    var pressedScale: CGFloat = 0.86
    let action: () -> Void
    @ViewBuilder var label: () -> Label

    @State private var popped = false

    var body: some View {
        Button {
            // Quick squash, then spring back out — then run the action.
            withAnimation(.easeIn(duration: 0.08)) { popped = true }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.08)) { popped = false }
            action()
        } label: {
            label().scaleEffect(popped ? pressedScale : 1)
        }
        .buttonStyle(.plain)
    }
}
