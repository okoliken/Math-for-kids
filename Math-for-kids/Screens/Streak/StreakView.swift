//
//  StreakView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 13/06/2026.
//

import SwiftData
import SwiftUI

struct StreakView: View {
    @Environment(\.dismiss) private var dismiss

    /// Binding to control bottom tab bar visibility from AppRoot
    @Environment(\.tabBarVisible) private var tabBarVisible

    @Query private var practiceDays: [PracticeDay]

    /// Current streak length in days, derived from practiced days.
    private var streakCount: Int { ProgressStore.streak(from: practiceDays) }

    /// Practiced days, used to light up the calendar.
    private var activeDates: Set<Date> { ProgressStore.activeDateSet(from: practiceDays) }

    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("back-path-dark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 15)
                        .foregroundStyle(.textPrimary)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Text("Streaks")
                    .font(.LilitaOne(size: .lg))
                    .foregroundStyle(.textPrimary)
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.top)
            MathScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                   streakCard

                   StreakStatusCard(
                        streakCount: streakCount,
                        activeDates: activeDates
                   )
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        // Hide the bottom tab bar while this pushed screen is visible.
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                tabBarVisible.wrappedValue = false
            }
        }
        .onDisappear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                tabBarVisible.wrappedValue = true
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }


    // MARK: - Motivational Message Card
    private var streakCard: some View {
        VStack(spacing: 24) {
            HStack(spacing: 16) {
                Image("lessons")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 81, height: 64)

                Text("Complete one lesson or level to get today’s streak!")
                    .font(.Rubik(size: .md)).fontWeight(.semibold)
                    .foregroundStyle(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)
            }

            MathButton(
                label: "Go To Lessons!",
                fullWidth: true
            )
            .frame(height: 52)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .cardSurface(cornerRadius: 16, borderWidths: .init(top: 2, leading: 2, bottom: 6, trailing: 2))
    }
}

#Preview {
    NavigationStack {
        StreakView()
    }
    .modelContainer(for: [SubjectProgress.self, LevelCompletion.self, PracticeDay.self], inMemory: true)
}
