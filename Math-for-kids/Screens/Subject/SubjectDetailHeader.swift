//
//  SubjectDetailHeader.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 13/06/2026.
//

import SwiftUI

/// Themed header for the subject detail screen: back button, title,
/// description and progress, tinted to the subject's colour.
struct SubjectDetailHeader: View {
    @Environment(\.dismiss) private var dismiss

    let subject: Subject

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(subject.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 96)
                .padding(.top, 72)

            VStack(alignment: .leading, spacing: 12) {
                Button {
                    dismiss()
                } label: {
                    Image("back-path-dark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 18)
                        .foregroundStyle(.textPrimary)
                }
                .buttonStyle(.plain)

                Text(subject.title)
                    .font(.LilitaOne(size: .lg))
                    .foregroundStyle(.textPrimary)

                Text(subject.description)
                    .font(.Rubik(size: .md)).fontWeight(.semibold)
                    .foregroundStyle(.textSecondary)
                    .frame(maxWidth: 240, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                Text("\(subject.completedLevels) / \(subject.totalLevels) level")
                    .font(.Rubik(size: .md))
                    .fontWeight(.semibold)
                    .foregroundStyle(.textSecondary)
                    .padding(.top, 8)

                ProgressBar(
                    value: Double(subject.completedLevels) / Double(max(subject.totalLevels, 1)),
                    fillColor: subject.buttonBrandStyle.contentColor,
                    surfaceColor: subject.surfaceColor,
                    borderColor: .white
                )
                .frame(height: 16)
                .padding(.top, 4)
            }
            .padding()
            .padding(.top, 60) // status bar / notch space
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(subject.surfaceColor)
        .clipped() // keep the decorative artwork within the header
        // 3D bottom lip — square corners, tinted to the subject's colour.
        .background(
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(subject.borderLightColor)
                    .offset(y: 6)
            }
        )
    }
}
