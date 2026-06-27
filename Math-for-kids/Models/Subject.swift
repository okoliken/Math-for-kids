//
//  Subject.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 13/06/2026.
//

import SwiftUI

/// A practice subject (Addition, Subtraction, …) with its theming and progress.
/// Identity is the title, so it can be used as a navigation value.
struct Subject: Identifiable, Hashable {
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

    /// A copy with progress applied — used to merge stored `completedLevels`
    /// onto the static catalog entry.
    func withCompletedLevels(_ completed: Int) -> Subject {
        var copy = self
        copy.completedLevels = completed
        return copy
    }

    // Identity is the title, but equality must also reflect mutable progress:
    // SwiftUI uses `==` to decide whether a view (e.g. PracticeCard) needs
    // re-rendering and whether `.onChange` fires. Comparing only `id` would
    // hide level completions, leaving cards stale after progress changes.
    static func == (lhs: Subject, rhs: Subject) -> Bool {
        lhs.id == rhs.id && lhs.completedLevels == rhs.completedLevels
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(completedLevels)
    }
}

extension Subject {
    /// The fixed set of subjects the app offers. Level progress is layered on
    /// from `SubjectProgress`; the metadata (theming, totals) lives here.
    static let catalog: [Subject] = [
        Subject(
            title: "Addition",
            imageName: "brand",
            surfaceColor: Color(.surfaceBrand),
            borderLightColor: .borderBrandLight
        ),
        Subject(
            title: "Subtraction",
            imageName: "lime",
            surfaceColor: Color(.surfaceLime),
            borderLightColor: .borderLimeLight,
            buttonBrandStyle: .lime
        ),
        Subject(
            title: "Multiplication",
            imageName: "fushia",
            surfaceColor: Color(.surfaceFushia),
            borderLightColor: .borderFushiaLight,
            buttonBrandStyle: .fuchsia
        ),
        Subject(
            title: "Division",
            imageName: "orange",
            surfaceColor: Color(.surfaceOrange),
            borderLightColor: .borderOrangeLight,
            buttonBrandStyle: .warning
        ),
    ]
}

/// A single level within a subject.
struct Level: Identifiable, Hashable {
    var id: Int { number }
    let number: Int
    let questionCount: Int
    let isUnlocked: Bool
    let isCompleted: Bool
}
