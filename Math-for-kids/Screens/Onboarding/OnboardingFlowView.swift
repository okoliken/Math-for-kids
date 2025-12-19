//
//  OnboardingFlowView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 11/12/2025.
//

import SwiftUI

/// Main container view that manages the onboarding flow
/// This view coordinates all 7 onboarding steps and manages the flow state
struct OnboardingFlowView: View {
  @State private var onboardingManager = ManageOnboarding()

  var body: some View {
    Group {
      switch onboardingManager.currentStep {
      case .welcome:
        OnboardingOne()
          .environment(onboardingManager)
      case .enterName:
        OnboardingTwo()
          .environment(onboardingManager)
      case .niceToMeetYou:
        OnboardingThree()
          .environment(onboardingManager)
      case .howOldAreYou:
        OnboardingFour()
          .environment(onboardingManager)
      case .clarifyLastQuestion:
        OnboardingFive()
          .environment(onboardingManager)
      case .whatIsYourGender:
        OnboardingSix()
          .environment(onboardingManager)
      case .startJourney:
        OnboardingSeven()
          .environment(onboardingManager)
      }
    }
    
  }
}

#Preview {
  OnboardingFlowView()
}
