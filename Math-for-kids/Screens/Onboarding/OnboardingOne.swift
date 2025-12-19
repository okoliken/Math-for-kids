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
        VStack {
           Text("Onboarding One")
            MathButton(label: "Next") {
                onboardingManager.nextStep()
            }
        }
    }
}

#Preview {
    OnboardingOne()
}

