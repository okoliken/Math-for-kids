//
//  PracticeCard.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import SwiftUI

struct PracticeCard: View {
    /// The subject this card represents, with its current progress already applied.
    let subject: Subject

    /// Button text reflects the level the learner is up to.
    private var buttonLabel: String { "Level \(subject.currentLevel)" }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 16)
                .fill(subject.surfaceColor)
                .frame(maxWidth: .infinity, minHeight: 180)
                .background(
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(subject.borderLightColor)
                            .offset(y: 6)
                    }
                )
            Image(subject.imageName)

            VStack(alignment: .leading, spacing: 8) {
                Text(subject.title)
                    .font(.LilitaOne(size: .lg))
                    .foregroundStyle(.textPrimary)

                Text(subject.description)
                    .font(.Rubik(size: .md)).fontWeight(.semibold)
                    .foregroundStyle(.textSecondary)
                    .frame(width: 200)
                    .lineSpacing(3)

                NavigationLink(value: NavigationRoute.subjectDetail(subject)) {
                    Text(buttonLabel)
                }
                .buttonStyle(MathButtonBrandStyle(style: subject.buttonBrandStyle))
                .padding(.top, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}

