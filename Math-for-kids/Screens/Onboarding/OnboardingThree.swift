//
//  OnboardingThree.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 07/12/2025.
//

import SwiftUI

struct OnboardingThree: View {
     @Environment(ManageOnboarding.self) var onboardingManager
    var body: some View {
        VStack {
           Text("Onboarding Three")

               HStack {
                MathButton(label: "Previous") {
                    onboardingManager.previousStep()
                }
                MathButton(label: "Next") {
                    onboardingManager.nextStep()
                }
            }
        }
    }
}

#Preview {
    OnboardingThree()
}

