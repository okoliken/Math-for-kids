//
//  OnboardingProgressBar.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 11/12/2025.
//

import SwiftUI

struct OnboardingProgressBar: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var manager: ManageOnboarding
    @State private var isVisible = false
    
    var progress: Double {
        let totalSteps = Double(OnBoardingSteps.allCases.count)
        return Double(manager.currentStep.rawValue + 1) / totalSteps
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Close button (X)
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.textPrimary)
                    .font(.system(size: 18, weight: .bold))
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background: surface-primary (#F1F5F9)
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color.surfacePrimary)
                    
                    // Progress fill: warning-content (#FF8904)
                    let progressWidth = max(geometry.size.width * progress, 0)
                    if progressWidth > 0.5 {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color.warningContent)
                            .frame(width: progressWidth, height: 10)
                    }
                }
                // Border: border-primary (#E2E8F0)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.borderPrimary, lineWidth: 5)
                )
                .clipShape(RoundedRectangle(cornerRadius: 100))
            }
            .frame(height: 14)
            .animation(.spring, value: progress)
            
            // Skip button (hidden on last step)
            if !manager.isLastStep() {
                Button {
                    manager.skip()
                } label: {
                    Text("Skip")
                        .foregroundStyle(.brandContent)
                        .font(.LilitaOne(size: .sm))
                        .fontWeight(.bold)
                }
            } else {
                // Placeholder to maintain layout
                Text("Skip")
                    .foregroundStyle(.clear)
                    .font(.LilitaOne(size: .sm))
                    .fontWeight(.semibold)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : -40)
        .scaleEffect(isVisible ? 1 : 0.95)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    OnboardingProgressBar(manager: ManageOnboarding())
}