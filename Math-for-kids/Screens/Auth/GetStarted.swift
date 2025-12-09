//
//  GetStarted.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 08/12/2025.
//

import SwiftUI

struct GetStarted: View {
  var body: some View {
    ZStack {
      Image("Brand")
        .resizable()
        .ignoresSafeArea(.all)
        .aspectRatio(contentMode: .fill)

      VStack(spacing: 32) {

        Image("logo")

        ZStack(alignment: .center) {
          RoundedRectangle(cornerRadius: 16)
            .fill(.white)
            .frame(height: 440)
            .shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 0)

          VStack(alignment: .center, spacing: 20) {
            Text("JOIN US!")
              .font(.LilitaOne(size: .xlg))

            // Avatar group - stacked horizontally with overlap
            HStack(spacing: -16) {
              Image("av1")
              Image("av2")
              Image("av3")
            }

            Text(
              "Join thousands of young learners discovering the joy of numbers through fun games, challenges, and rewards. Every tap brings you closer to mastering math — the playful way!"
            )
            .font(.Rubik(size: .lg))
            .foregroundColor(Color.textSecondary)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .lineSpacing(8)
            .frame(width: 330)

            VStack(spacing: 10) {
              MathButton(label: "CREATE ACCOUNT!", brandStyle: .success, fullWidth: true) {

              }
              MathButton(label: "Sign In", brandStyle: .secondary, fullWidth: true) {

              }
            }
          }
          .padding(24)
        }
        .frame(maxWidth: 380)  // Constrain the card width

      }
      .padding()
    }

  }
}

#Preview {
  GetStarted()
}
