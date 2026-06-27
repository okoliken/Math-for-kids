//
//  PracticeView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 14/06/2026.
//
import Combine
import SwiftData
import SwiftUI

/// A started practice run — carries the subject, chosen difficulty, and the
/// level being attempted so it can be handed to `navigationDestination(item:)`.
struct PracticeSession: Identifiable, Hashable {
    let id = UUID()
    let subject: Subject
    let difficulty: Difficulty
    let level: Int
}

/// The timed, multiple-choice practice lesson: a chalkboard question over a 2×2
/// answer grid, with a countdown, progress bar, and hint/skip helpers.
struct PracticeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.tabBarVisible) private var tabBarVisible
    @Environment(\.modelContext) private var modelContext

    let subject: Subject
    var difficulty: Difficulty = .easy
    var level: Int = 1

    @State private var session = PracticeViewModel()

    /// Set once the session is graded — swaps the question UI for the result screen.
    @State private var result: PracticeResult?

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    /// The chalkboard's signature green.
    private let boardGreen = Color(red: 0.30, green: 0.64, blue: 0.37)

    var body: some View {
        ZStack {
            if let result {
                PracticeResultView(result: result, level: level, onGoToLevels: { dismiss() })
                    .transition(.opacity)
            } else {
                practiceContent
                    .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .animation(.easeInOut(duration: 0.35), value: result == nil)
        .onAppear {
            session.start(subject: subject, difficulty: difficulty)
            session.onFinish = { graded in handleFinish(graded) }
            setTabBar(visible: false)
        }
        .onDisappear {
            // Restore the tab bar when leaving the practice session.
            setTabBar(visible: true)
            session.stopSound()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring(duration: 0.4)) {
                session.tick()
            }
        }
    }

    /// The live question UI shown while the session is in progress.
    private var practiceContent: some View {
        ZStack(alignment: .top) {
            Color(.backgroundLightest).ignoresSafeArea()

            VStack(spacing: 0) {
                PracticeTopBar(coinBalance: 99_000) { dismiss() }
                    .zIndex(1)

                content
            }
            .ignoresSafeArea(edges: .top)
        }
        .overlay {
            if session.showHint {
                Spacer()
                HintModal(
                    hintsRemaining: session.hintsRemaining,
                    onClose: { session.dismissHint() },
                    onGetHint: { session.useHint() }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .overlay {
            if session.showBoard {
                BoardModal(
                    drawing: $session.boardDrawing,
                    onClose: { session.closeBoard() }
                )
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: session.showHint)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: session.showBoard)
    }

    /// Grades the finished session: a pass completes the level (advancing
    /// progress and counting the streak); either way we show the result screen.
    private func handleFinish(_ graded: PracticeResult) {
        if graded.passed {
            ProgressStore(context: modelContext).recordCompletion(
                subjectID: subject.id,
                level: level,
                totalLevels: subject.totalLevels,
                difficulty: difficulty
            )
        }
        result = graded
    }

    // MARK: - Content
    private var content: some View {
        VStack(spacing: 24) {
            timerHeader

            questionCard

            answerGrid

            Spacer()

            helperButtons
                .padding(.bottom, 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var timerHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Time Left")
                    .font(.LilitaOne(size: .xsm))
                    .foregroundStyle(.textPrimary)

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(Color(.warningContent))
                    Text(session.formattedTime)
                        .font(.Rubik(size: .lg)).fontWeight(.semibold)
                        .foregroundStyle(Color(.warningContent))
                        .contentTransition(.numericText())
                }
            }

            ProgressBar(
                value: session.progress,
                fillColor: Color(.warningContent),
                surfaceColor: Color(.surfacePrimary),
                borderColor: Color.borderPrimary
            )
            .frame(height: 14)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: session.progress)
        }
    }

    private var questionCard: some View {
        Text(session.currentQuestion?.prompt ?? "")
            .font(.LilitaOne(size: .huge))
            .foregroundStyle(.white)
            .minimumScaleFactor(0.6)
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background(boardGreen)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                UnevenBorderShape(
                    cornerRadius: 16,
                    borderWidths: .init(top: 4, leading: 4, bottom: 8, trailing: 4)
                )
                .fill(Color.textPrimary, style: FillStyle(eoFill: true))
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .id(session.currentIndex)
            .transition(.scale.combined(with: .opacity))
    }

    private var answerGrid: some View {
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
        ]
        return LazyVGrid(columns: columns, spacing: 16) {
            ForEach(session.currentQuestion?.options ?? [], id: \.self) { option in
                AnswerButton(
                    value: option,
                    state: session.state(for: option)
                ) {
                    session.select(option)
                }
                .wiggle(trigger: session.shouldWiggle(option))
            }
        }
    }

    private var helperButtons: some View {
        HStack(spacing: 16) {
            helperButton(icon: "bulb") {
                session.openHint()
            }
            helperButton(icon: "edit") {
                session.openBoard()
            }
        }
    }

    private func helperButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(.borderContent))
                            .offset(y: 3)
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(.brandContent))
                    }
                )
        }
        .buttonStyle(PressableButtonStyle())
    }

    // MARK: - View helpers
    /// Animated tab-bar visibility toggle, matching the rest of the app.
    private func setTabBar(visible: Bool) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            tabBarVisible.wrappedValue = visible
        }
    }
}

#Preview {
    NavigationStack {
        PracticeView(
            subject: Subject(
                title: "Addition",
                imageName: "brand",
                surfaceColor: Color(.surfaceBrand),
                borderLightColor: Color.borderBrandLight
            ),
            difficulty: .easy,
            level: 1
        )
    }
    .modelContainer(for: [SubjectProgress.self, LevelCompletion.self, PracticeDay.self], inMemory: true)
}
