//
//  ConfettiView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/06/2026.
//

import SwiftUI

/// Continuous, lively confetti rain. Driven by a `TimelineView` so every piece
/// is repositioned each frame from elapsed time — it animates forever and can't
/// be swallowed by a parent's implicit animation. Pieces fall, sway, spin, and
/// recycle as they pass the bottom.
struct ConfettiView: View {
    var pieceCount: Int = 80

    /// A single confetti flake with its randomised look and motion.
    private struct Piece: Identifiable {
        let id = UUID()
        let xFactor: CGFloat       // base horizontal position, 0...1 of the width
        let color: Color
        let size: CGSize
        let isCircle: Bool
        let fallDuration: Double   // seconds for one top→bottom trip
        let phase: Double          // time offset so pieces don't move in lockstep
        let swayAmplitude: CGFloat // horizontal drift, in points
        let swaySpeed: Double
        let spinSpeed: Double      // degrees per second (sign = direction)
    }

    private let pieces: [Piece]

    init(pieceCount: Int = 80) {
        self.pieceCount = pieceCount
        let palette: [Color] = [
            Color(.brandContent), Color(.limeContent), Color(.fuchsiaContent),
            Color(.warningContent), Color(.errorContent), Color(.successContent),
        ]
        self.pieces = (0..<pieceCount).map { _ in
            Piece(
                xFactor: .random(in: 0...1),
                color: palette.randomElement() ?? Color(.brandContent),
                size: CGSize(width: .random(in: 7...13), height: .random(in: 9...16)),
                isCircle: .random(),
                fallDuration: .random(in: 2.2...4.6),
                phase: .random(in: 0...6),
                swayAmplitude: .random(in: 8...28),
                swaySpeed: .random(in: 1.1...2.6),
                spinSpeed: .random(in: 70...280) * (Bool.random() ? 1 : -1)
            )
        }
    }

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { timeline in
                let t = timeline.date.timeIntervalSinceReferenceDate
                ZStack {
                    ForEach(pieces) { piece in
                        // Progress 0→1 down the screen, looping forever.
                        let cycle = piece.fallDuration
                        let progress = ((t + piece.phase).truncatingRemainder(dividingBy: cycle)) / cycle
                        let y = -30 + CGFloat(progress) * (geo.size.height + 60)
                        let sway = sin((t + piece.phase) * piece.swaySpeed) * piece.swayAmplitude
                        let angle = (t + piece.phase) * piece.spinSpeed

                        flake(piece)
                            .frame(width: piece.size.width, height: piece.size.height)
                            .rotationEffect(.degrees(angle))
                            .position(x: piece.xFactor * geo.size.width + sway, y: y)
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }

    @ViewBuilder
    private func flake(_ piece: Piece) -> some View {
        if piece.isCircle {
            Circle().fill(piece.color)
        } else {
            RoundedRectangle(cornerRadius: 2).fill(piece.color)
        }
    }
}

#Preview {
    ConfettiView()
        .background(.white)
        .ignoresSafeArea()
}
