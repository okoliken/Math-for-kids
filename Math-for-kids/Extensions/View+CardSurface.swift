//
//  View+CardSurface.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 13/06/2026.
//

import SwiftUI

extension View {
    /// Applies the app's standard bordered card surface: a filled rounded
    /// rectangle with the uneven (heavier-bottom) border used throughout the app.
    func cardSurface(
        cornerRadius: CGFloat = 12,
        borderWidths: EdgeInsets = .init(top: 2, leading: 2, bottom: 4, trailing: 2),
        fillColor: Color = .borderPrimary
    ) -> some View {
        self
            .background(Color(.surfacePrimary))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                UnevenBorderShape(
                    cornerRadius: cornerRadius,
                    borderWidths: borderWidths
                )
                .fill(Color(fillColor), style: FillStyle(eoFill: true))
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
