//
//  OnboardingFour.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 07/12/2025.
//

import SwiftUI

struct HowOldAreYou: View {
    @State private var isVisible = false
    
    var body: some View {
        VStack {
            Text("How old are you?")
                 .font(.LilitaOne(size: .xlg))
                 .foregroundColor(.textSecondary)
                 .opacity(isVisible ? 1 : 0)
                 .scaleEffect(isVisible ? 1 : 0.9)
            
            BirthdatePicker()
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(isVisible ? 1 : 0.9)
        }
        .padding(.top, 32)
        .padding(.horizontal, 16)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    HowOldAreYou()
}

