//
//  SubjectDetailView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 13/06/2026.
//

import SwiftData
import SwiftUI

struct SubjectDetailView: View {
    @Environment(\.tabBarVisible) private var tabBarVisible

    let subject: Subject

    @Query private var progresses: [SubjectProgress]

    @State private var playLevel: Level?
    @State var showPracticeView: Bool = false

    /// A started practice run — pushes `PracticeView` once a difficulty is chosen.
    @State private var session: PracticeSession?

    /// Stored progress for this subject, falling back to whatever the catalog carried.
    private var completedLevels: Int {
        progresses.first { $0.subjectID == subject.id }?.completedLevels ?? subject.completedLevels
    }

    /// The subject with live progress applied, so the level ladder unlocks as you go.
    var liveSubject: Subject {
        subject.withCompletedLevels(completedLevels)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Use the live subject so the header's level count and progress bar
            // track completions, matching the level list below.
            SubjectDetailHeader(subject: liveSubject)
                .zIndex(1)

            ScrollView(showsIndicators: false) {
                levelsList
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .ignoresSafeArea(edges: .top) // let the header extend under the status bar
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .overlay {
            if playLevel != nil {
                DifficultyModal(
                    onCancel: {
                        playLevel = nil
                        setTabBar(visible: true)
                    },
                    onStart: { difficulty in
                        session = PracticeSession(
                            subject: subject,
                            difficulty: difficulty,
                            level: playLevel?.number ?? liveSubject.currentLevel
                        )
                        playLevel = nil
                        showPracticeView = true
                    }
                )
            }
        }
        .fullScreenCover(isPresented: $showPracticeView){
            if let session = session {
                PracticeView(subject: session.subject, difficulty: session.difficulty, level: session.level)
            }
        }
    }

    /// Animated tab-bar visibility toggle, matching the rest of the app.
    private func setTabBar(visible: Bool) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            tabBarVisible.wrappedValue = visible
        }
    }

    // MARK: - Levels List
    private var levelsList: some View {
        VStack(spacing: 12) {
            ForEach(Array(liveSubject.levels.enumerated()), id: \.element.id) { index, level in
                LevelRow(level: level, brandStyle: subject.buttonBrandStyle) {
                    playLevel = level
                    setTabBar(visible: false)
                }
                .staggeredAppear(index)
            }
        }
        .padding(20)
    }
}

#Preview {
    NavigationStack {
        SubjectDetailView(
            subject: Subject(
                title: "Addition",
                imageName: "brand",
                surfaceColor: Color(.surfaceBrand),
                borderLightColor: Color.borderBrandLight
            )
        )
    }
    .modelContainer(for: [SubjectProgress.self, LevelCompletion.self, PracticeDay.self], inMemory: true)
}
