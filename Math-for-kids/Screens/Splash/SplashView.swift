//
//  SplashView.swift
//  MathForkids
//
//  Created by Jeffery Okoli on 07/12/2025.
//

import SwiftUI

struct SplashView: View {
  @State private var loadingProgress: CGFloat = 0.0
  @State private var displayPercentage: Int = 0
  @Binding var isActive: Bool
  
  @State private var shineOpacity: Double = 0.0
  @State private var shineRotation: Double = -15.0
  @State private var logoScale: CGFloat = 0.0
  @State private var progressOpacity: Double = 0.0
  @State private var progressOffset: CGFloat = 30

  var body: some View {
    ZStack {
      Color("brandContent")
        .ignoresSafeArea()
      
      Image("Shine")
        .resizable()
        .interpolation(.high)
        .scaledToFill()
        .ignoresSafeArea()
        .opacity(shineOpacity)
        .rotationEffect(.degrees(shineRotation))
        .drawingGroup()

      VStack {
        Spacer()

        Image("splash-logo")
          .resizable()
          .scaledToFit()
          .frame(width: 280, height: 280)
          .shadow(color: Color.white.opacity(0.3), radius: 20, x: 0, y: 0)
          .scaleEffect(logoScale)

        Spacer()

        VStack(spacing: 12) {
          HStack(alignment: .center) {
            Text("Loading...")
              .foregroundColor(.white)
              .font(.LilitaOne(size: .sm))

            Spacer()

            // Percentage text (counts up visibly)
            Text("\(displayPercentage)%")
              .foregroundColor(.white)
              .font(.LilitaOne(size: .sm))
          }
          .frame(width: 280)

          // Progress bar
          ZStack(alignment: .leading) {
            // Background capsule (blue/unfilled area)
            Capsule()
              .fill(Color.borderContent)
              .frame(height: 16)

            // Progress capsule (coral/red filled area)
            Capsule()
              .fill(Color.errorContent)
              .frame(width: max(16, 280 * loadingProgress), height: 16)
          }
          .frame(width: 280)
          .overlay(
            Capsule()
              .stroke(Color.white, lineWidth: 4)
          )
        }
        .padding(.bottom, 60)
        .opacity(progressOpacity)
        .offset(y: progressOffset)
      }
    }
    .onAppear {
      // 1. Shine fades in with rotation FIRST - completes before anything else
      withAnimation(.easeOut(duration: 0.8)) {
        shineOpacity = 1.0
        shineRotation = 0.0
      }
      
      // 2. Logo pops in AFTER shine completes (0.8s delay)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
          logoScale = 1.0
        }
      }
      
      // 3. Progress enters AFTER logo completes (~1.3s delay)
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
        withAnimation(.easeOut(duration: 0.4)) {
          progressOpacity = 1.0
          progressOffset = 0
        }
      }
      
      // 4. Start progress bar fill after progress appears (1.7s delay)
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
        // Animate the progress bar smoothly
        withAnimation(.linear(duration: 2.0)) {
          loadingProgress = 1.0
        }
        
        // Count up the percentage visibly (every 100ms = 10% increment)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
          if displayPercentage < 100 {
            displayPercentage += 5  // Increment by 5% every 100ms
          } else {
            timer.invalidate()
          }
        }
      }

      // Transition to main app after loading (4.0s total)
      DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
        withAnimation(.easeInOut(duration: 0.5)) {
          isActive = false  // Set to false to hide splash and show main content
        }
      }
    }
  }
}

#Preview {
  SplashView(isActive: .constant(false))
}
