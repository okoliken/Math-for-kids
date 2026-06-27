//
//  DummyData.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 22/06/2026.
//

import Foundation
import SwiftData

/// Seeds placeholder progress so the app demos with a believable streak.
///
/// The app never stores a "streak number" — the streak is recomputed from the
/// list of `PracticeDay` records (one per day the kid practiced). So to fake a
/// streak we don't touch the UI at all; we just insert the right days, and
/// `ProgressStore` derives the count, the Mon–Sun strip, and the calendar
/// flames from them. Home and Streak screens both update automatically.
enum DummyData {
    /// How many days in a row (ending today) we want the streak to read.
    /// Bump this to show a longer or shorter streak.
    static let streakLength = 11

    /// Inserts a contiguous streak of `streakLength` days ending today, plus a
    /// couple of earlier days this month so the calendar looks lived-in.
    /// Idempotent: skips any day that's already recorded, so it's safe to run
    /// on every launch and won't clash with the kid's real practice days.
    static func seedStreak(in context: ModelContext) {
        let calendar = Calendar.current
        // Normalise to midnight. PracticeDay stores the start of the day, so we
        // must match that exactly or the "already exists?" check below won't.
        let today = calendar.startOfDay(for: .now)

        // The current streak. Counting backwards 0, 1, 2, … from today gives an
        // unbroken chain ending today (today, yesterday, …). Because they're
        // consecutive, ProgressStore.streak() counts them as one run.
        var days: [Date] = (0..<streakLength).compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }

        // A few scattered older days. These have gaps before today, so they do
        // NOT extend the streak count — they only add extra flames to the
        // calendar grid so the month doesn't look empty.
        for offset in [8, 9, 12] {
            if let date = calendar.date(byAdding: .day, value: -offset, to: today) {
                days.append(date)
            }
        }

        // Insert each day only if it isn't already saved. This is what makes
        // the seeder safe to call repeatedly (each PracticeDay.day is unique).
        for day in days {
            let descriptor = FetchDescriptor<PracticeDay>(
                predicate: #Predicate { $0.day == day }
            )
            if (try? context.fetch(descriptor).first) == nil {
                context.insert(PracticeDay(day: day))
            }
        }

        // Persist the inserts to the SwiftData store.
        try? context.save()
    }

    /// The coin balance a fresh install starts with, so the Store has something
    /// to show being spent and earned.
    static let startingCoins = 100

    /// Inserts the wallet with `startingCoins` if one doesn't exist yet.
    /// Idempotent: once the kid has a wallet (with whatever balance they've
    /// since earned or bought), this leaves it untouched.
    static func seedWallet(in context: ModelContext) {
        if (try? context.fetch(FetchDescriptor<Wallet>()).first) == nil {
            context.insert(Wallet(coins: startingCoins))
            try? context.save()
        }
    }
}
