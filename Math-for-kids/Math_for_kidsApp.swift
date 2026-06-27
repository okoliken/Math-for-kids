//
//  Math_for_kidsApp.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 07/12/2025.
//

import SwiftUI
import SwiftData

@main
struct Math_for_kidsApp: App {
    // We hold the SwiftData container ourselves (instead of letting the
    // `.modelContainer(for:)` modifier create it) so we can write the demo
    // streak into it during init, before any screen reads from it.
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: SubjectProgress.self, LevelCompletion.self, PracticeDay.self, Wallet.self
            )
            // Insert the dummy practice days so the streak shows up on launch.
            DummyData.seedStreak(in: container.mainContext)
            // Give the demo learner a starting coin balance.
            DummyData.seedWallet(in: container.mainContext)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Hand the same pre-seeded container to the view hierarchy.
        .modelContainer(container)
    }
}
