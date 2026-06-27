//
//  StreakStatusCard.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 13/06/2026.
//

import SwiftUI

/// "Streak Status" calendar card: a month grid where each day shows a flame —
/// orange for days the learner kept their streak, grey otherwise.
struct StreakStatusCard: View {
    /// Total streak length shown in the header chip (e.g. "2 Days").
    var streakCount: Int = 2

    /// Days the streak was active, normalised to the start of the day.
    /// Membership is what drives an orange (vs grey) flame in the grid.
    var activeDates: Set<Date> = []

    /// Month currently displayed. Navigated with the arrow buttons.
    @State private var displayedMonth: Date = Date()

    /// Monday-first calendar used for all date math in this card.
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2 // Monday
        return calendar
    }

    private let weekdaySymbols = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 7
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            calendarCard
        }
    }

    // MARK: - Header ("Streak Status" + streak chip)
    private var header: some View {
        HStack(alignment: .center) {
            Text("Streak Status")
                .font(.LilitaOne(size: .sm))
                .foregroundStyle(.textPrimary)

            Spacer()

            HStack(alignment: .center, spacing: 6,) {
                Image("dayStreak")
                    .font(.system(size: 18, weight: .bold))
                Text("\(streakCount) \(streakCount == 1 ? "Day" : "Days")")
                    .font(.LilitaOne(size: .xsm))
            }
            .foregroundStyle(Color(.warningContent))
        }
    }

    // MARK: - Calendar Card
    private var calendarCard: some View {
        VStack(spacing: 24) {
            // Month label + month navigation
            HStack {
                Text(monthTitle)
                    .font(.LilitaOne(size: .md))
                    .foregroundStyle(.textPrimary)

                Spacer()

                HStack(spacing: 10) {
                    circleButton(systemName: "arrow.left") { changeMonth(by: -1) }
                    circleButton(systemName: "arrow.right") { changeMonth(by: 1) }
                }
            }

            // Weekday header
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.Rubik(size: .sm))
                        .fontWeight(.semibold)
                        .foregroundStyle(.textSecondary)
                }
            }

            // Day grid
            LazyVGrid(columns: columns, spacing: 18) {
                ForEach(Array(monthDays.enumerated()), id: \.offset) { _, day in
                    if let day {
                        dayCell(day)
                    } else {
                        Color.clear
                            .frame(height: 1)
                    }
                }
            }
        }
        .padding(20)
        .cardSurface()
    }

    // MARK: - Day Cell
    private func dayCell(_ day: Int) -> some View {
        VStack(spacing: 6) {
            Image(isActive(day) ? "fire" : "fire-inactive")
                .resizable()
                .scaledToFit()
                .frame(width: 13, height: 19)

            Text("\(day)")
                .font(.Rubik(size: .xsm))
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Circular Navigation Button
    private func circleButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.textPrimary)
                .frame(width: 32, height: 32)
                .background(
                    Circle().fill(Color.surfaceSecondary)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Date Helpers
    /// Cells for the displayed month: leading `nil`s pad the first row so the
    /// 1st lands under the correct weekday, followed by each day number.
    private var monthDays: [Int?] {
        guard
            let monthStart = calendar.date(
                from: calendar.dateComponents([.year, .month], from: displayedMonth)
            ),
            let range = calendar.range(of: .day, in: .month, for: monthStart)
        else { return [] }

        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let leadingBlanks = (firstWeekday - calendar.firstWeekday + 7) % 7

        return Array(repeating: nil, count: leadingBlanks) + range.map { Optional($0) }
    }

    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "MMMM, yyyy"
        return formatter.string(from: displayedMonth)
    }

    private func isActive(_ day: Int) -> Bool {
        var components = calendar.dateComponents([.year, .month], from: displayedMonth)
        components.day = day
        guard let date = calendar.date(from: components) else { return false }
        return activeDates.contains(calendar.startOfDay(for: date))
    }

    private func changeMonth(by value: Int) {
        guard let newMonth = calendar.date(
            byAdding: .month, value: value, to: displayedMonth
        ) else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
            displayedMonth = newMonth
        }
    }
}

#Preview {
    let calendar = Calendar(identifier: .gregorian)
    let today = calendar.startOfDay(for: Date())
    let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

    return StreakStatusCard(
        streakCount: 2,
        activeDates: [today, yesterday]
    )
    .padding(20)
}
