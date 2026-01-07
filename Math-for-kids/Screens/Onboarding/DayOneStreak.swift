//
//  DayOneStreak.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/12/2025.
//

import ConfettiSwiftUI
import SwiftUI

struct DayOneStreak: View {
    @Environment(ManageOnboarding.self) var onboardingManager
    @State private var confettiCounter: Int = 0
    @State private var fireOffset: CGFloat = 0
    @State private var showContent: Bool = false
    
    // Array of days with their active states
    let weekDays: [(day: String, isActive: Bool)] = [
        ("Mon", true),
        ("Tue", false),
        ("Wed", false),
        ("Thu", false),
        ("Fri", false),
        ("Sat", false),
        ("Sun", false)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Fire icon - starts in middle, moves to top
                Spacer()
                    .frame(height: fireOffset)
                
                Image("fire")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54, height: 76.26834106445312)
                    .onTapGesture {
                        confettiCounter += 1
                    }
                    .confettiCannon(
                        trigger: $confettiCounter,
                        num: 50,
                        confettis: [.shape(.circle), .shape(.triangle)],
                        confettiSize: 10,
                        repetitions: 3,
                        repetitionInterval: 0.3
                    )
                
                Spacer()
                
                // Content that appears after fire moves
                if showContent {
                    VStack(spacing: 10) {
                        Text("1 DAY")
                            .font(.LilitaOne(size: .xlg))
                            .foregroundStyle(.textPrimary)
                        
                        Text("This is your first streak! Next time you must complete tutorial or practice to reach")
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(8)
                            .font(.Rubik(size: .lg))
                            .foregroundColor(.textSecondary)

                        StreakDayCard(weekDays: weekDays)
                            .padding(.top, 32)
                    }
                    .padding()
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                // Fire starts in the middle (center of screen)
                let screenCenter = geometry.size.height / 2
                let fireHeight: CGFloat = 76.26834106445312
                fireOffset = screenCenter - fireHeight / 2
                
                // After a brief moment, move fire to original position (top)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        fireOffset = 250 // Original top position
                    }
                }
                
                // Show content after fire moves
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        showContent = true
                    }
                }
                
                // Trigger confetti after everything is done
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    confettiCounter += 1
                }
            }
        }
    }
}

struct StreakDayCard: View {
    let weekDays: [(day: String, isActive: Bool)]
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.surfacePrimary)
            .frame(width: 358, height: 91)
            .overlay(
                HStack(spacing: 12) {
                    ForEach(weekDays, id: \.day) { dayData in
                        VStack(spacing: 8) {
                            Text(dayData.day)
                                .font(.Rubik(size: .md))
                                .fontWeight(.semibold)
                                .foregroundColor(.textSecondary)
                            
                            Image(dayData.isActive ? "fire" : "fire-inactive")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 16)
            )
            .overlay(
                UnevenBorderShape(
                    cornerRadius: 12,
                    borderWidths: .init(top: 1, leading: 1, bottom: 4, trailing: 1)
                )
                .fill(Color(.borderPrimary), style: FillStyle(eoFill: true))
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    @Previewable var onboardingManager = ManageOnboarding()
    DayOneStreak()
           .environment(onboardingManager)
}

