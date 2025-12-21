//
//  OnboardingFive.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 07/12/2025.
//

import SwiftUI

struct ClarifyLastQuestion: View {
    @State private var isVisible = false
    
    var body: some View {
       
        VStack(alignment: .center, spacing: 32) {
            Spacer()
            Text(AppTexts.Onboarding.clarifyLastQuestion)
                .font(.Rubik(size: .lg))
                .foregroundColor(.textSecondary)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(8)
                .frame(width: 330)
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(isVisible ? 1 : 0.9)
            
            Image("reading")
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(isVisible ? 1 : 0.9)
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    ClarifyLastQuestion()
}

