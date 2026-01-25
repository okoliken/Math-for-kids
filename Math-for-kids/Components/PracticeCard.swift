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
    
    init(
        title: String,
        description: String = "Complete levels and earn XP, up your rank",
        buttonLabel: String,
        buttonBrandStyle: ButtonBrandStyle = .brand,
        surfaceColor: Color,
        borderLightColor: Color,
        imageName: String
    ) {
        self.title = title
        self.description = description
        self.buttonLabel = buttonLabel
        self.buttonBrandStyle = buttonBrandStyle
        self.surfaceColor = surfaceColor
        self.borderLightColor = borderLightColor
        self.imageName = imageName
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
                    .font(.Rubik(size: .md))
                    .foregroundStyle(.textSecondary)
                    .frame(width: 200)
                    .lineSpacing(3)
                
                MathButton(label: buttonLabel, brandStyle: buttonBrandStyle)
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}

