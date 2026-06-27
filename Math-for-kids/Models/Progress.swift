//
//  Progress.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 16/06/2026.
//

import Foundation
import SwiftData

/// The learner's current level in a subject. One row per subject; advances as
/// levels are completed.
@Model
final class SubjectProgress {
    @Attribute(.unique) var subjectID: String
    var completedLevels: Int
    var updatedAt: Date

    init(subjectID: String, completedLevels: Int = 0, updatedAt: Date = .now) {
        self.subjectID = subjectID
        self.completedLevels = completedLevels
        self.updatedAt = updatedAt
    }
}

/// A dated record of a single level being completed — the history log, so
/// progression can be charted "at each point" over time.
@Model
final class LevelCompletion {
    var subjectID: String
    var level: Int
    var difficulty: String
    var completedAt: Date

    init(subjectID: String, level: Int, difficulty: String, completedAt: Date = .now) {
        self.subjectID = subjectID
        self.level = level
        self.difficulty = difficulty
        self.completedAt = completedAt
    }
}

/// A calendar day on which at least one practice session was completed. Stored
/// as the start of the day so each date is unique; powers the streak.
@Model
final class PracticeDay {
    @Attribute(.unique) var day: Date

    init(day: Date) {
        self.day = day
    }
}
