//
//  PracticeViewModel.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 14/06/2026.
//

import Observation
import PencilKit
import SwiftUI

/// The graded outcome of a practice session, shown on the result screen.
struct PracticeResult {
    let passed: Bool
    let correctCount: Int
    let totalCount: Int
    let elapsedSeconds: Int
    let xpEarned: Int
}

/// Drives a single practice session: question batch, selection/locking, the
/// countdown, and the hint flow. The view stays presentational.
@Observable
final class PracticeViewModel {
    /// Fraction of questions that must be correct to pass a level.
    static let passFraction = 0.6
    /// XP awarded for passing a level.
    static let passXP = 100
    var questions: [Question] = []
    var currentIndex = 0
    var selectedAnswer: Int?
    var isLocked = false
    var hintsRemaining = 3
    /// When set, the current question's correct answer is highlighted as a hint
    /// — without committing the answer or advancing.
    var hintRevealed = false

    var showHint = false

    /// The scratch-pad board, shown over the question. `boardDrawing` persists
    /// the learner's working while they stay on the same question.
    var showBoard = false
    var boardDrawing = PKDrawing()

    /// Total session time in seconds (02:10).
    var timeRemaining = 130
    let totalTime = 130

    /// Correct answers so far — drives the pass/fail grade.
    var correctCount = 0

    /// Guards `finish()` so the session is graded exactly once.
    private var didFinish = false

    /// Invoked once when the session ends, carrying the graded result.
    var onFinish: (PracticeResult) -> Void = { _ in }

    var currentQuestion: Question? {
        questions.indices.contains(currentIndex) ? questions[currentIndex] : nil
    }

    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentIndex + 1) / Double(questions.count)
    }

    var formattedTime: String {
        String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60)
    }

    /// Loads the question batch once; safe to call repeatedly (e.g. `onAppear`).
    /// Sizes the batch to the level's question count so the score reads "X of N".
    func start(subject: Subject, difficulty: Difficulty) {
        guard questions.isEmpty else { return }
        questions = Question.batch(for: subject, difficulty: difficulty, count: subject.questionsPerLevel)
    }

    func tick() {
        guard !didFinish, timeRemaining > 0 else { return }
        timeRemaining -= 1
        // A countdown tick each second. Uses a bundled "tick" sound if present,
        // otherwise the system "Tock" (1104) so it's audible out of the box.
        // Let a longer tick finish rather than restart every second.
        SoundPlayer.shared.play("tick", fallbackSystemSound: 1104, restartIfPlaying: false)
        // Time's up — grade whatever was answered so far.
        if timeRemaining == 0 { finish() }
    }
    
    func practiceResultSound(_ result: PracticeResult) {
        let failSound = "371205__absolutely_craycray__level-failed"
        let passSound = "456969__funwithsound__success-resolution-video-game-fanfare-sound-effect-with-drum-roll"
        
        if result.passed {
            SoundPlayer.shared.play(passSound, fallbackSystemSound: 1104, restartIfPlaying: false)
        }
        
        else {
            SoundPlayer.shared.play(failSound, fallbackSystemSound: 1104, restartIfPlaying: false)
        }
    }

    /// Silences the countdown tick — call when leaving the session so the last
    /// tick doesn't ring out after the screen is gone.
    func stopSound() {
        SoundPlayer.shared.stop("tick")
    }

    // MARK: - Answer state
    /// Buttons wiggle on a revealed hint or on a wrong selection.
    func shouldWiggle(_ option: Int) -> Bool {
        switch state(for: option) {
        case .correct: return hintRevealed && selectedAnswer == nil
        case .wrong: return true
        case .idle: return false
        }
    }

    func state(for option: Int) -> AnswerState {
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

    func handleHintRevealed(onDismiss: @escaping () -> Void) -> AnswerState {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            onDismiss()
        }
        return .correct
    }

    func dismissHintState() {
        hintRevealed = false
    }

    // MARK: - Actions
    func select(_ option: Int) {
        guard !isLocked else { return }
        if option == currentQuestion?.correctAnswer { correctCount += 1 }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedAnswer = option
            isLocked = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            self.advance()
        }
    }

    func advance() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            selectedAnswer = nil
            isLocked = false
            hintRevealed = false
            // Each question gets a fresh scratch pad.
            boardDrawing = PKDrawing()
            if currentIndex + 1 < questions.count {
                currentIndex += 1
            } else {
                finish()
            }
        }
    }

    // MARK: - Grading
    /// Minimum correct answers needed to pass — `passFraction` of the batch,
    /// rounded up (e.g. 3 of 5 at 60%).
    private var passMark: Int { Int((Double(questions.count) * Self.passFraction).rounded(.up)) }

    /// Ends and grades the session exactly once, handing the result to `onFinish`.
    private func finish() {
        guard !didFinish else { return }
        didFinish = true
        stopSound()

        let passed = correctCount >= passMark
        onFinish(
            PracticeResult(
                passed: passed,
                correctCount: correctCount,
                totalCount: questions.count,
                elapsedSeconds: totalTime - timeRemaining,
                xpEarned: passed ? Self.passXP : 0
            )
        )
    }

    // MARK: - Board
    func openBoard() {
        showBoard = true
    }

    func closeBoard() {
        showBoard = false
    }

    // MARK: - Hints
    func openHint() {
        showHint = true
    }

    func dismissHint() {
        showHint = false
    }

    func useHint() {
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
