//
//  OnboardingTwo.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 07/12/2025.
//

import SwiftUI

struct EnterName: View {
    @State var name: String = ""
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 40) {
           Text("Enter your name")
                .font(.LilitaOne(size: .xlg))
                .foregroundColor(.textSecondary)
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(isVisible ? 1 : 0.9)
            
            MathTextField(
                text: $name,
                label: "Your Name",
                placeholder: "Ex: Alex",
                variant: .white
            )
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
    EnterName()
}

