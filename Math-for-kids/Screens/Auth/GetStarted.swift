//
//  GetStarted.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 08/12/2025.
//

import SwiftUI

struct GetStarted: View {
    var body: some View {

        VStack(spacing: 32) {

          Image("logo")

          AuthCard(height: 440) {
            VStack(alignment: .center, spacing: 20) {
              Text("JOIN US!")
                .font(.LilitaOne(size: .xlg))
                .foregroundStyle(.textPrimary)

             AvatarGroup()

              Text(
                "Join thousands of young learners discovering the joy of numbers through fun games, challenges, and rewards. Every tap brings you closer to mastering math — the playful way!"
              )
              .font(.Rubik(size: .lg))
              .foregroundColor(.textSecondary)
              .multilineTextAlignment(.center)
              .fixedSize(horizontal: false, vertical: true)
              .lineSpacing(8)
              .frame(width: 330)

              VStack(spacing: 10) {
                  NavigationLink {
                      SignUpView()
                  } label: {
                     Text("CREATE ACCOUNT!")
                }
                .buttonStyle(MathButtonBrandStyle(style: .success, fullWidth: true))

                  NavigationLink {
                      LoginView()
                  }  label: {
                       Text("Sign In")
                 }
                .buttonStyle(MathButtonBrandStyle(style: .secondary, fullWidth: true))
              }
            }
          }
          .frame(maxWidth: 380)  // Constrain the card width

        }
//        .padding()
      }

  }


#Preview {
    GetStarted()
}

