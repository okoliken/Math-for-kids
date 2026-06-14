//
//  PracticeView.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 14/06/2026.
//
import Combine
import SwiftUI

/// A started practice run — carries the subject and chosen difficulty so it can
/// be handed to `navigationDestination(item:)`.
struct PracticeSession: Identifiable, Hashable {
    let id = UUID()
    let subject: Subject
    let difficulty: Difficulty
}

/// The timed, multiple-choice practice lesson: a chalkboard question over a 2×2
/// answer grid, with a countdown, progress bar, and hint/skip helpers.
struct PracticeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.tabBarVisible) private var tabBarVisible

    let subject: Subject
    var difficulty: Difficulty = .easy

    @State private var questions: [Question] = []
    @State private var currentIndex = 0
    @State private var selectedAnswer: Int?
    @State private var isLocked = false
    @State private var showHint = false
    @State private var hintsRemaining = 3
    /// When set, the current question's correct answer is highlighted as a hint
    /// — without committing the answer or advancing.
    @State private var hintRevealed = false

    /// Total session time in seconds (02:10).
    @State private var timeRemaining = 130

    private let totalTime = 130
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    /// The chalkboard's signature green.
    private let boardGreen = Color(red: 0.30, green: 0.64, blue: 0.37)

    private var currentQuestion: Question? {
        questions.indices.contains(currentIndex) ? questions[currentIndex] : nil
    }

    private var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentIndex + 1) / Double(questions.count)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(.backgroundLightest).ignoresSafeArea()

            VStack(spacing: 0) {
                PracticeTopBar(coinBalance: 99_000) { dismiss() }
                    .zIndex(1)

                content
            }
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .overlay {
            if showHint {
                Spacer()
                HintModal(
                    hintsRemaining: hintsRemaining,
                    onClose: { dismissHint() },
                    onGetHint: { useHint() }
                )
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showHint)
        .onAppear {
            if questions.isEmpty {
                questions = Question.batch(for: subject, difficulty: difficulty)
            }
            setTabBar(visible: false)
        }
        .onDisappear {
            // Restore the tab bar when leaving the practice session.
            setTabBar(visible: true)
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 { timeRemaining -= 1 }
        }
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
                    .font(.LilitaOne(size: .md))
                    .foregroundStyle(.textPrimary)

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(Color(.warningContent))
                    Text(formattedTime)
                        .font(.LilitaOne(size: .md))
                        .foregroundStyle(Color(.warningContent))
                }
            }

            ProgressBar(
                value: progress,
                fillColor: Color(.warningContent),
                surfaceColor: Color(.surfaceSecondary)
            )
            .frame(height: 14)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: progress)
        }
    }

    private var questionCard: some View {
        Text(currentQuestion?.prompt ?? "")
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
            .id(currentIndex)
            .transition(.scale.combined(with: .opacity))
    }

    private var answerGrid: some View {
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
        ]
        return LazyVGrid(columns: columns, spacing: 16) {
            ForEach(currentQuestion?.options ?? [], id: \.self) { option in
                AnswerButton(
                    value: option,
                    state: state(for: option)
                ) {
                    select(option)
                }
                .wiggle(trigger: shouldWiggle(option))
            }
        }
    }
    
    
    

    private var helperButtons: some View {
        HStack(spacing: 16) {
            helperButton(icon: "lightbulb.fill") {
                showHint = true
            }
            helperButton(icon: "pencil") {
                advance()
            }
        }
    }

    private func helperButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
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
        .buttonStyle(.plain)
    }

    // MARK: - State helpers
    /// Animated tab-bar visibility toggle, matching the rest of the app.
    private func setTabBar(visible: Bool) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            tabBarVisible.wrappedValue = visible
        }
    }

    private var formattedTime: String {
        String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60)
    }

    /// Buttons wiggle on a revealed hint or on a wrong selection.
    private func shouldWiggle(_ option: Int) -> Bool {
        switch state(for: option) {
        case .correct: return hintRevealed && selectedAnswer == nil
        case .wrong: return true
        case .idle: return false
        }
    }

    private func state(for option: Int) -> AnswerState {
        // Once an answer is committed, reflect right/wrong on the chosen option.
        if let selected = selectedAnswer {
            guard option == selected else { return .idle }
            return option == currentQuestion?.correctAnswer ? .correct : .wrong
        }
        // A used hint highlights the correct answer while staying on the question.
        if hintRevealed && option == currentQuestion?.correctAnswer {
            return handleHintRevealed(onDismiss: dismissHintState)
        }
        
        return .idle
    }
    
    private func handleHintRevealed(onDismiss: @escaping () -> Void) -> AnswerState {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            onDismiss()
        }
        return .correct
    }
    
    private func dismissHintState() {
       hintRevealed = false
    }
    

    private func select(_ option: Int) {
        guard !isLocked else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedAnswer = option
            isLocked = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            advance()
        }
    }

    private func advance() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            selectedAnswer = nil
            isLocked = false
            hintRevealed = false
            if currentIndex + 1 < questions.count {
                currentIndex += 1
            } else {
                dismiss()
            }
        }
    }

    private func dismissHint() {
        showHint = false
    }

    private func useHint() {
        guard hintsRemaining > 0 else { showHint = false; return }
        hintsRemaining -= 1
        showHint = false
        // Reveal the correct answer on the current question — the learner still
        // taps it to continue.
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            hintRevealed = true
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
            difficulty: .easy
        )
    }
}
