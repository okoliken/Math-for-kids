//
//  OnboardingSix.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 07/12/2025.
//

import SwiftUI

struct WhatIsYourGender: View {
    @Environment(ManageOnboarding.self) var onboardingManager
    @State private var isVisible = false
    @State private var selectedGender: Gender? = nil
    
    var body: some View {
        VStack {
            Text("What's your gender?")
                 .font(.LilitaOne(size: .xlg))
                 .foregroundColor(.textSecondary)
                 .opacity(isVisible ? 1 : 0)
                 .scaleEffect(isVisible ? 1 : 0.9)
            
            HStack(alignment: .center, spacing: 80) {
                VStack(spacing: 11) {
                    Image("5")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 88, height: 88)
                        .overlay {
                            Circle()
                                .stroke(selectedGender == .boy ? Color.successContent : Color.borderPrimary, lineWidth: 4)
                                .padding(-3)
                        }
                    
                    Text("I'm a Boy")
                        .font(.LilitaOne(size: .md))
                        .foregroundColor(selectedGender == .boy ? Color.successContent : .textSecondary)
                }
                .onTapGesture {
                    withAnimation {
                        selectedGender = .boy
                        onboardingManager.childGender = .boy
                    }
                }
                                
                VStack(spacing: 11) {
                    Image("10")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 88, height: 88)
                        .overlay {
                            Circle()
                                .stroke(selectedGender == .girl ? Color.fuchsiaContent : Color.borderPrimary, lineWidth: 4)
                                .padding(-3)
                        }
                    Text("I'm a Girl")
                        .font(.LilitaOne(size: .md))
                        .foregroundColor(selectedGender == .girl ? Color.fuchsiaContent : .textSecondary)
                }
                .onTapGesture {
                    withAnimation {
                        selectedGender = .girl
                        onboardingManager.childGender = .girl
                    }
                }
            }
            .padding(.top, 24)
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.9)
        }
        .padding(.top, 32)
        .padding(.horizontal, 16)
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.70)) {
                isVisible = true
            }
            // Restore selection if already set
            if let gender = onboardingManager.childGender {
                selectedGender = gender
            }
        }
    }
}

#Preview {
    WhatIsYourGender()
}

