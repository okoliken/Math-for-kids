//
//  ProgressBar.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 13/06/2026.
//

import SwiftUI

/// A rounded progress bar matching the onboarding style: a `surfacePrimary`
/// track with a `borderPrimary` outline and an inset coloured pill that grows
/// from the leading edge.
struct ProgressBar: View {
    /// Completion ratio in 0...1.
    let value: Double
    let fillColor: Color
    let surfaceColor: Color

    /// Gap between the coloured pill and the track edge.
    /// At the 16pt track height this yields a 12pt fill (16 − 2×2).
    var inset: CGFloat = 2

    /// Width of the track's outline.
    var borderWidth: CGFloat = 2

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let clamped = min(max(value, 0), 1)

            let innerHeight = max(0, height - inset * 2)
            let maxInnerWidth = max(0, width - inset * 2)
            // Keep at least a pill (a full circle) visible at low values.
            let innerWidth = max(innerHeight, maxInnerWidth * clamped)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(surfaceColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: height / 2)
                            .stroke(Color.white, lineWidth: borderWidth)
                    )

                RoundedRectangle(cornerRadius: innerHeight / 2)
                    .fill(fillColor)
                    .frame(width: innerWidth, height: innerHeight)
                    .padding(.leading, inset)
            }
        }
    }
}
