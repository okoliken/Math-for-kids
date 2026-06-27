//
//  PracticeResultView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/06/2026.
//

import SwiftUI

/// Shown after a practice session ends: a celebratory pass or a sympathetic
/// fail, with the time taken, score, and XP earned, plus a way back to the
/// level list. Everything springs in and the mascot keeps moving so the screen
/// feels alive for young learners.
struct PracticeResultView: View {
    let result: PracticeResult
    /// The level that was just attempted, named in the pass subtitle.
    let level: Int
    let onGoToLevels: () -> Void

    /// Flips once on appear to fire the choreographed, element-by-element entrance.
    /// Each piece reads this through `revealStep` with its own delay.
    @State private var entered = false
    /// Confetti is held back a beat so the mascot lands first, then it rains in.
    @State private var showConfetti = false
    /// The XP figure ticks up from 0 to `result.xpEarned` for a rewarding count.
    @State private var displayedXP = 0
    @State private var session = PracticeViewModel()

    // Hand-tuned entrance timeline (seconds). Elements cascade in one by one.
    private let mascotDelay = 0.15
    private let titleDelay = 0.55
    private let subtitleDelay = 0.85
    private let statsBaseDelay = 1.15
    private let statsStagger = 0.22
    private let buttonDelay = 2.1
    private let confettiDelay = 0.6

    var body: some View {
        ZStack(alignment: .top) {
            Color(.backgroundLightest).ignoresSafeArea()

            // Continuous confetti rain over the whole screen on a win — eased in
            // a moment after the mascot so the celebration builds.
            if result.passed && showConfetti {
                ConfettiView()
                    .ignoresSafeArea()
                    .transition(.opacity)
            }

            VStack(spacing: 0) {
                Spacer()
                Spacer()

                mascot
                    .revealStep(entered, delay: mascotDelay)

                Text(result.passed ? "Level Completed!" : "FAIL!")
                    .font(.LilitaOne(size: .xlg))
                    .foregroundStyle(Color(result.passed ? .successBorder : .errorBorder))
                    .padding(.top, 32)
                    .revealStep(entered, delay: titleDelay)

                Text(result.passed ? "You completed level \(level)" : "Level not completed")
                    .font(.Rubik(size: .lg)).fontWeight(.semibold)
                    .foregroundStyle(.textSecondary)
                    .padding(.top, 10)
                    .padding(.bottom)
                    .revealStep(entered, delay: subtitleDelay)

                statsRow
                    .padding()

                Spacer()

                MathButton(label: "Go To Levels", fullWidth: true) {
                    onGoToLevels()
                }
                .frame(height: 56)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .revealStep(entered, delay: buttonDelay)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { runEntrance() }
    }

    /// Kicks off the sound, the cascading element reveal, the delayed confetti,
    /// and the XP count-up — sequenced so they land in a satisfying order.
    private func runEntrance() {
        session.practiceResultSound(result)

        // Trigger every `revealStep`; each honours its own delay.
        entered = true

        Task {
            // Hold confetti back a beat, then ease it in over the screen.
            try? await Task.sleep(for: .seconds(confettiDelay))
            withAnimation(.easeIn(duration: 0.4)) { showConfetti = true }
        }

        Task {
            // Start counting once the XP card has sprung in.
            try? await Task.sleep(for: .seconds(statsBaseDelay + statsStagger * 2 + 0.35))
            await animateXP()
        }
    }

    /// Ticks `displayedXP` from 0 up to the earned amount so the value reads as
    /// if it's being tallied live.
    private func animateXP() async {
        let target = result.xpEarned
        guard target > 0 else { displayedXP = 0; return }

        let duration = 1.4
        let steps = min(target, 45)
        let interval = duration / Double(steps)

        for step in 1...steps {
            try? await Task.sleep(for: .seconds(interval))
            displayedXP = Int((Double(target) * Double(step) / Double(steps)).rounded())
        }
        displayedXP = target
    }

    // MARK: - Mascot
    /// The brain keeps moving: a happy bob-and-tilt on a win, an angry tremble
    /// on a loss — driven each frame by a TimelineView.
    private var mascot: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            let bob = CGFloat(sin(t * 2.6)) * 7        // gentle vertical bob
            let tilt = sin(t * 1.9) * 5                // degrees of sway
            let tremble = CGFloat(sin(t * 24)) * 2.5   // fast jitter for the fail

            Image(decorative: result.passed ? "pass" : "fail")
                .resizable()
                .scaledToFit()
                .frame(height: 180)
                .rotationEffect(.degrees(result.passed ? tilt : 0))
                .offset(
                    x: result.passed ? 0 : tremble,
                    y: result.passed ? bob : 0
                )
        }
        .frame(height: 180)
    }

    // MARK: - Stats
    private var statsRow: some View {
        HStack(spacing: 12) {
            statCard(
                icon: "clock.fill",
                tint: Color(.warningContent),
                value: timeString,
                label: "Time \(timeString)"
            )
            .revealStep(entered, delay: statsBaseDelay)

            statCard(
                icon: "list.bullet.clipboard.fill",
                tint: Color(.fuchsiaContent),
                value: "\(result.correctCount) of \(result.totalCount)",
                label: "Score \(result.correctCount) of \(result.totalCount)"
            )
            .revealStep(entered, delay: statsBaseDelay + statsStagger)

            statCard(
                icon: "star.fill",
                tint: Color(.limeContent),
                value: "+\(displayedXP)XP",
                label: "Earned \(result.xpEarned) XP"
            )
            .revealStep(entered, delay: statsBaseDelay + statsStagger * 2)
        }
    }

    private func statCard(icon: String, tint: Color, value: String, label: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(tint)
                .accessibilityHidden(true)

            Text(value)
                .font(.LilitaOne(size: .sm))
                .foregroundStyle(tint)
        }
        .frame(maxWidth: .infinity, minHeight: 76)
        .padding(.top, 2)
        .padding(.bottom, 6)
        .padding(.horizontal, 2)
        .cardSurface(
            cornerRadius: 12,
            borderWidths: .init(top: 2, leading: 2, bottom: 6, trailing: 2),
            fillColor: .borderSecondary
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
    }

    private var timeString: String {
        String(format: "%02d:%02d", result.elapsedSeconds / 60, result.elapsedSeconds % 60)
    }
}

#Preview("Pass") {
    PracticeResultView(
        result: PracticeResult(passed: true, correctCount: 5, totalCount: 5, elapsedSeconds: 90, xpEarned: 100),
        level: 1,
        onGoToLevels: {}
    )
}

#Preview("Fail") {
    PracticeResultView(
        result: PracticeResult(passed: false, correctCount: 2, totalCount: 5, elapsedSeconds: 90, xpEarned: 0),
        level: 1,
        onGoToLevels: {}
    )
}
