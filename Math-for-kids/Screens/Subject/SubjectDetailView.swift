//
//  SubjectDetailView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 13/06/2026.
//

import SwiftUI

/// Subject detail: a themed header (title, progress) over a scrollable
/// ladder of levels, each playable or locked based on progress.
struct SubjectDetailView: View {
    /// Binding to control bottom tab bar visibility from AppRoot
    @Environment(\.tabBarVisible) private var tabBarVisible

    let subject: Subject

    /// The level whose play button was tapped — drives the difficulty modal.
    @State private var playLevel: Level?

    var body: some View {
        VStack(spacing: 0) {
            // Sticky header — stays put (and on top) while the level list scrolls.
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
        // Hide the bottom tab bar while this pushed screen is visible.
        .onDisappear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                tabBarVisible.wrappedValue = true
            }
        }
        // Difficulty picker — pops in when a level's play button is tapped.
        .overlay {
            if playLevel != nil {
                DifficultyModal(
                    onCancel: { dismissModal() },
                    onStart: { _ in
                        dismissModal()
                    }
                )
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.62), value: playLevel)
        // Tuck the bottom tab bar away while the modal is up so it's covered.
        .onChange(of: playLevel) { _, newValue in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                tabBarVisible.wrappedValue = (newValue == nil)
            }
        }
    }

    private func dismissModal() {
        playLevel = nil
    }

    // MARK: - Levels List
    private var levelsList: some View {
        VStack(spacing: 12) {
            ForEach(Array(subject.levels.enumerated()), id: \.element.id) { index, level in
                LevelRow(level: level, brandStyle: subject.buttonBrandStyle) {
                    playLevel = level
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
