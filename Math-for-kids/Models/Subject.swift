//
//  Subject.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 13/06/2026.
//

import SwiftUI

/// A practice subject (Addition, Subtraction, …) with its theming and progress.
/// Identity is the title, so it can be used as a navigation value.
struct Subject: Hashable, Identifiable {
    let id: String
    var title: String
    var description: String
    var imageName: String
    var surfaceColor: Color
    var borderLightColor: Color
    var buttonBrandStyle: ButtonBrandStyle
    var totalLevels: Int
    var completedLevels: Int
    var questionsPerLevel: Int

    init(
        title: String,
        description: String = "Complete levels and earn XP, up your rank",
        imageName: String,
        surfaceColor: Color,
        borderLightColor: Color,
        buttonBrandStyle: ButtonBrandStyle = .brand,
        totalLevels: Int = 30,
        completedLevels: Int = 0,
        questionsPerLevel: Int = 5
    ) {
        self.id = title
        self.title = title
        self.description = description
        self.imageName = imageName
        self.surfaceColor = surfaceColor
        self.borderLightColor = borderLightColor
        self.buttonBrandStyle = buttonBrandStyle
        self.totalLevels = totalLevels
        self.completedLevels = completedLevels
        self.questionsPerLevel = questionsPerLevel
    }

    /// The level the learner is currently on (1-based).
    var currentLevel: Int { min(completedLevels + 1, totalLevels) }

    /// The full ladder of levels with lock/completion state derived from progress.
    var levels: [Level] {
        guard totalLevels > 0 else { return [] }
        return (1...totalLevels).map { number in
            Level(
                number: number,
                questionCount: questionsPerLevel,
                isUnlocked: number <= completedLevels + 1,
                isCompleted: number <= completedLevels
            )
        }
    }

    // Identity is the title — Color/ButtonBrandStyle need not be Hashable.
    static func == (lhs: Subject, rhs: Subject) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

/// A single level within a subject.
struct Level: Identifiable, Hashable {
    var id: Int { number }
    let number: Int
    let questionCount: Int
    let isUnlocked: Bool
    let isCompleted: Bool
}
