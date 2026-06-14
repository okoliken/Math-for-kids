//
//  StreakView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 13/06/2026.
//

import SwiftUI

struct StreakView: View {
    @Environment(\.dismiss) private var dismiss

    /// Binding to control bottom tab bar visibility from AppRoot
    @Environment(\.tabBarVisible) private var tabBarVisible

    /// Current streak length in days
    var streakCount: Int = 1

    /// Per-day activity for the current week
    var weekDays: [(day: String, isActive: Bool)] = [
        ("Mon", true),
        ("Tue", false),
        ("Wed", false),
        ("Thu", false),
        ("Fri", false),
        ("Sat", false),
        ("Sun", false)
    ]

    /// The most recent `streakCount` days, used to light up the calendar.
    private var activeDates: Set<Date> {
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())
        let dates = (0..<max(streakCount, 0)).compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }
        return Set(dates)
    }

    var body: some View {
        MathScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
               streakCard

               StreakStatusCard(
                    streakCount: streakCount,
                    activeDates: activeDates
               )
            }
            .padding()
            .padding(.bottom, 40)
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Streak")
                    .font(.LilitaOne(size: .md))
                    .foregroundStyle(.textPrimary)
            }

            ToolbarItem(placement: .navigationBarLeading) {
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
            }
        }
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
}
