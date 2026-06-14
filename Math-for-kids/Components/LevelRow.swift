//
//  LevelRow.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 13/06/2026.
//

import SwiftUI

/// A single level row: title and question count, with a play button when
/// unlocked or a lock icon when not.
struct LevelRow: View {
    let level: Level
    let brandStyle: ButtonBrandStyle
    let action: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Level \(level.number)")
                    .font(.LilitaOne(size: .md))
                    .foregroundStyle(level.isUnlocked ? .textPrimary : .textSecondary)

                Text("\(level.questionCount) questions")
                    .font(.Rubik(size: .md))
                    .fontWeight(.medium)
                    .foregroundStyle(.textSecondary)
            }

            Spacer(minLength: 0)

            if level.isCompleted {
                Image("stars")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 88, height: 32)
            } else if level.isUnlocked {
                Button(action: action) {
                    ZStack {
                        // Subtle bottom depth.
                        Circle()
                            .fill(Color.brandDark)
                            .offset(y: 3)

                        // Light fill with a thick dark ring.
                        Circle()
                            .fill(Color.brandContent)
                            .overlay(
                                Circle().strokeBorder(Color.brandDark, lineWidth: 3)
                            )

                        Image("play")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .frame(width: 48, height: 48)
                }
                .buttonStyle(BouncyButtonStyle())
            } else {
                Image("lock")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color(.textInactive))
                    .frame(width: 48, height: 48)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 22)
        .frame(maxWidth: .infinity)
        .cardSurface(cornerRadius: 16, borderWidths: .init(top: 2, leading: 2, bottom: 6, trailing: 2), fillColor: .borderSecondary)
    }
}
