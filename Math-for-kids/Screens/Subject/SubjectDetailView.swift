//
//  SubjectDetailView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 13/06/2026.
//

import SwiftUI

struct SubjectDetailView: View {
    @Environment(\.tabBarVisible) private var tabBarVisible

    let subject: Subject

    @State private var playLevel: Level?

    /// A started practice run — pushes `PracticeView` once a difficulty is chosen.
    @State private var session: PracticeSession?

    var body: some View {
        VStack(spacing: 0) {
            SubjectDetailHeader(subject: subject)
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
                    // Cancel returns to the level list — restore the tab bar.
                    onCancel: {
                        playLevel = nil
                        setTabBar(visible: true)
                    },
                    // Start pushes the practice screen — keep the tab bar hidden
                    // so it doesn't flash back in behind the push.
                    onStart: { difficulty in
                        playLevel = nil
                        session = PracticeSession(subject: subject, difficulty: difficulty)
                    }
                )
            }
        }
        .navigationDestination(item: $session) { session in
            PracticeView(subject: session.subject, difficulty: session.difficulty)
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.62), value: playLevel)
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
            ForEach(Array(subject.levels.enumerated()), id: \.element.id) { index, level in
                LevelRow(level: level, brandStyle: subject.buttonBrandStyle) {
                    playLevel = level
                    // Tuck the tab bar away so the difficulty modal covers cleanly.
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
}
