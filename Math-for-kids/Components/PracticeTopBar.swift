//
//  PracticeTopBar.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 14/06/2026.
//

import SwiftUI

/// The top bar shown during a practice session: a close button on the left and
/// the coin balance pill on the right, on a white sheet with the app's
/// bottom-rounded lip and border.
struct PracticeTopBar: View {
    let coinBalance: Int
    let onClose: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.textPrimary)
            }
            .buttonStyle(.plain)

            Spacer()

            // Coin balance pill
            HStack(spacing: 8) {
                Image("Coin")

                Text(coinBalance.formatted())
                    .font(.LilitaOne(size: .md))
                    .foregroundStyle(.textPrimary)

                NavigationLink(value: NavigationRoute.store) {
                    Image("Add")
                        .foregroundColor(.green)
                        .font(.title3)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(.surfacePrimary)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(Color.borderPrimary, lineWidth: 5)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
        .padding(.bottom, 12)
        .frame(height: 110)
        .background(Color.white)
        .clipShape(BottomRoundedRectangle(cornerRadius: 24))
        .overlay(alignment: .bottom) {
            BottomBorderShape(cornerRadius: 24, borderWidth: 3)
                .fill(Color.borderPrimary)
        }
        .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: -1)
    }
}
