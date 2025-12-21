//
//  OnboardingSeven.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 07/12/2025.
//

import SwiftUI

struct StartJourney: View {
    @State private var isVisible = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Spacer()
        
            Text("Alex, we're happy to see you in Math Kids! Start your journey!")
                .font(.Rubik(size: .lg))
                .fontWeight(.semibold)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(8)
                .frame(width: 330)
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(isVisible ? 1 : 0.9)
            
                Image("superhero")
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
    StartJourney()
}

