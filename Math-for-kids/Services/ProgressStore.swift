//
//  ProgressStore.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 16/06/2026.
//

import Foundation
import SwiftData

/// Reads and writes practice progress: per-subject level, the completion log,
/// and the days a session was finished (for the streak).
struct ProgressStore {
    let context: ModelContext

    // MARK: - Reads
    func completedLevels(for subjectID: String) -> Int {
        progress(for: subjectID)?.completedLevels ?? 0
    }

    private func progress(for subjectID: String) -> SubjectProgress? {
        let descriptor = FetchDescriptor<SubjectProgress>(
            predicate: #Predicate { $0.subjectID == subjectID }
        )
        return try? context.fetch(descriptor).first
    }

    // MARK: - Writes
    /// Records that `level` of `subjectID` was just completed: logs it, marks
    /// today as practiced, and advances the subject if this was its next level.
    func recordCompletion(subjectID: String, level: Int, totalLevels: Int, difficulty: Difficulty) {
        print(subjectID)
        let now = Date()
        context.insert(
            LevelCompletion(subjectID: subjectID, level: level, difficulty: difficulty.rawValue, completedAt: now)
        )

        let existing = progress(for: subjectID)
        let p = existing ?? SubjectProgress(subjectID: subjectID)
        if existing == nil { context.insert(p) }
        // Only advance when finishing the current frontier level — replaying an
        // earlier level still logs a completion but doesn't bump progress.
        if level == p.completedLevels + 1 {
            p.completedLevels = min(level, totalLevels)
            p.updatedAt = now
        }

        markPracticed(on: now)
        try? context.save()
    }

    private func markPracticed(on date: Date) {
        let day = Calendar.current.startOfDay(for: date)
        let descriptor = FetchDescriptor<PracticeDay>(predicate: #Predicate { $0.day == day })
        if (try? context.fetch(descriptor).first) == nil {
            context.insert(PracticeDay(day: day))
        }
    }

    // MARK: - Wallet
    /// The single wallet row, creating it (at zero) the first time it's needed.
    private func wallet() -> Wallet {
        if let existing = try? context.fetch(FetchDescriptor<Wallet>()).first {
            return existing
        }
        let wallet = Wallet()
        context.insert(wallet)
        return wallet
    }

    /// Adds `amount` coins to the balance and persists. Used by Store purchases.
    func creditCoins(_ amount: Int) {
        let wallet = wallet()
        wallet.coins += amount
        try? context.save()
    }
}

// MARK: - Streak helpers (pure)
extension ProgressStore {
    /// The set of practiced calendar days, normalised to the start of the day.
    static func activeDateSet(from days: [PracticeDay]) -> Set<Date> {
        let calendar = Calendar.current
        return Set(days.map { calendar.startOfDay(for: $0.day) })
    }

    /// Length of the current run of consecutive practiced days ending today (or
    /// yesterday, so today's streak survives until the day is over).
    static func streak(from days: [PracticeDay], asOf today: Date = .now) -> Int {
        let calendar = Calendar.current
        let active = activeDateSet(from: days)

        var anchor = calendar.startOfDay(for: today)
        if !active.contains(anchor) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: anchor) else { return 0 }
            anchor = yesterday
        }

        var count = 0
        var cursor = anchor
        while active.contains(cursor) {
            count += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = previous
        }
        return count
    }

    /// The current week (Mon–Sun) with each day's label and whether it was practiced.
    static func currentWeek(from days: [PracticeDay], asOf today: Date = .now) -> [(day: String, isActive: Bool)] {
        let calendar = Calendar.current
        let active = activeDateSet(from: days)
        let start = calendar.startOfDay(for: today)
        // weekday: 1 = Sunday … 7 = Saturday. Shift so Monday is the first column.
        let daysFromMonday = (calendar.component(.weekday, from: start) + 5) % 7
        guard let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: start) else { return [] }

        let labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: monday) else { return nil }
            return (labels[offset], active.contains(date))
        }
    }
}
