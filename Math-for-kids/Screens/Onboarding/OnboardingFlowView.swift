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
        ZStack {
            Color.backgroundLightest
                .ignoresSafeArea()
            VStack(spacing: 0) {
                // Progress bar header
                if !onboardingManager.isLastStep() {
                    OnboardingProgressBar(manager: onboardingManager)
                }
                // Content
                Group {
                    switch onboardingManager.currentStep {
                        case .welcome:
                            Welcome()
                                .environment(onboardingManager)
                        case .enterName:
                            EnterName()
                                .environment(onboardingManager)
                        case .niceToMeetYou:
                            NiceToMeetYou()
                                .environment(onboardingManager)
                        case .howOldAreYou:
                            HowOldAreYou()
                                .environment(onboardingManager)
                        case .clarifyLastQuestion:
                            ClarifyLastQuestion()
                                .environment(onboardingManager)
                        case .whatIsYourGender:
                            WhatIsYourGender()
                                .environment(onboardingManager)
                        case .startJourney:
                            StartJourney()
                                .environment(onboardingManager)
                    }
                }
                
                Spacer()
                
                // Control buttons based on step
              
        
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    if shouldShowTwoButtons {
                        // Steps 2, 4, 6: Previous and Next buttons horizontally
                        HStack(spacing: 12) {
                            MathButton(label: "Previous", brandStyle: .secondary, fullWidth: true) {
                                onboardingManager.previousStep()
                            }
                            
                            MathButton(label: "Next", fullWidth: true) {
                                onboardingManager.nextStep()
                            }
                        }
                        .padding(.horizontal, 20)
                    } else {
                        // Steps 1, 3, 5, 7: Continue button full width
                        if !onboardingManager.isLastStep() {
                            MathButton(label: "Continue", fullWidth: true) {
                                onboardingManager.nextStep()
                            }
                            .padding(.horizontal, 20)
                        }
                        else {
                            MathButton(label: "START JOURNEY!", fullWidth: true) {
                                onboardingManager.nextStep()
                            }
                            .padding(.horizontal, 20)
                        }

                    }
                }
            }
            .padding(.bottom, 8)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    private var shouldShowTwoButtons: Bool {
        switch onboardingManager.currentStep {
            case .enterName, .howOldAreYou, .whatIsYourGender:
                return true
            default:
                return false
        }
    }
}

#Preview {
    OnboardingFlowView()
}
