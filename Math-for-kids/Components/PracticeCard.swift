//
//  PracticeCard.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import SwiftUI

struct PracticeCard: View {
    let title: String
    let description: String
    let buttonLabel: String
    let buttonBrandStyle: ButtonBrandStyle
    let surfaceColor: Color
    let borderLightColor: Color
    let imageName: String
    let totalLevels: Int
    let completedLevels: Int
    let questionsPerLevel: Int

    init(
        title: String,
        description: String = "Complete levels and earn XP, up your rank",
        buttonLabel: String,
        buttonBrandStyle: ButtonBrandStyle = .brand,
        surfaceColor: Color,
        borderLightColor: Color,
        imageName: String,
        totalLevels: Int = 30,
        completedLevels: Int = 0,
        questionsPerLevel: Int = 5
    ) {
        self.title = title
        self.description = description
        self.buttonLabel = buttonLabel
        self.buttonBrandStyle = buttonBrandStyle
        self.surfaceColor = surfaceColor
        self.borderLightColor = borderLightColor
        self.imageName = imageName
        self.totalLevels = totalLevels
        self.completedLevels = completedLevels
        self.questionsPerLevel = questionsPerLevel
    }

    /// The subject this card opens when its level button is tapped.
    private var subject: Subject {
        Subject(
            title: title,
            description: description,
            imageName: imageName,
            surfaceColor: surfaceColor,
            borderLightColor: borderLightColor,
            buttonBrandStyle: buttonBrandStyle,
            totalLevels: totalLevels,
            completedLevels: completedLevels,
            questionsPerLevel: questionsPerLevel
        )
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 16)
                .fill(surfaceColor)
                .frame(maxWidth: .infinity, minHeight: 180)
                .background(
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(borderLightColor)
                            .offset(y: 6)
                    }
                )
            Image(imageName)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.LilitaOne(size: .lg))
                    .foregroundStyle(.textPrimary)
                
                Text(description)
                    .font(.Rubik(size: .md)).fontWeight(.semibold)
                    .foregroundStyle(.textSecondary)
                    .frame(width: 200)
                    .lineSpacing(3)
                
                NavigationLink(value: NavigationRoute.subjectDetail(subject)) {
                    Text(buttonLabel)
                }
                .buttonStyle(MathButtonBrandStyle(style: buttonBrandStyle))
                .padding(.top, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}

