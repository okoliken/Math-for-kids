//
//  OnboardingOne.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 07/12/2025.
//

import SwiftUI

struct OnboardingOne: View {
    @Environment(ManageOnboarding.self) var onboardingManager
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Spacer()
        
            Text(AppTexts.Onboarding.welcomeMessage)
                .font(.Rubik(size: .lg))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(8)
                .frame(width: 330)
            
                Image("lifting-weight")
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingOne()
}

