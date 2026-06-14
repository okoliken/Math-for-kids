//
//  Question.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 14/06/2026.
//

import Foundation

/// The arithmetic operation a practice question exercises.
enum MathOperation {
    case addition
    case subtraction
    case multiplication
    case division

    /// The glyph shown in the question prompt (e.g. the `+` in `50 + 32 = ?`).
    var symbol: String {
        switch self {
        case .addition: return "+"
        case .subtraction: return "−"
        case .multiplication: return "×"
        case .division: return "÷"
        }
    }

    func apply(_ a: Int, _ b: Int) -> Int {
        switch self {
        case .addition: return a + b
        case .subtraction: return a - b
        case .multiplication: return a * b
        case .division: return b == 0 ? 0 : a / b
        }
    }

    /// Maps a subject's title onto its operation, defaulting to addition.
    init(subjectTitle: String) {
        switch subjectTitle.lowercased() {
        case "subtraction": self = .subtraction
        case "multiplication": self = .multiplication
        case "division": self = .division
        default: self = .addition
        }
    }
}

/// A single multiple-choice practice question: two operands, an operation,
/// and four answer options (one correct, three distractors).
struct Question: Identifiable {
    let id = UUID()
    let leftOperand: Int
    let rightOperand: Int
    let op: MathOperation
    let options: [Int]

    /// The prompt rendered on the chalkboard, e.g. `50 + 32 = ?`.
    var prompt: String { "\(leftOperand) \(op.symbol) \(rightOperand) = ?" }

    var correctAnswer: Int { op.apply(leftOperand, rightOperand) }
}

extension Question {
    /// Builds a batch of randomised questions for a subject. Difficulty widens
    /// the operand range so harder levels use larger numbers.
    static func batch(for subject: Subject, difficulty: Difficulty, count: Int = 8) -> [Question] {
        let op = MathOperation(subjectTitle: subject.title)
        let upperBound: Int
        switch difficulty {
        case .easy: upperBound = 20
        case .normal: upperBound = 50
        case .hard: upperBound = 99
        }

        return (0..<count).map { _ in make(op: op, upperBound: upperBound) }
    }

    private static func make(op: MathOperation, upperBound: Int) -> Question {
        var a = Int.random(in: 1...upperBound)
        var b = Int.random(in: 1...upperBound)

        // Keep answers friendly for young learners: no negatives, clean division.
        switch op {
        case .subtraction:
            if b > a { swap(&a, &b) }
        case .multiplication:
            a = Int.random(in: 1...12)
            b = Int.random(in: 1...12)
        case .division:
            b = Int.random(in: 1...12)
            a = b * Int.random(in: 1...12)
        case .addition:
            break
        }

        let answer = op.apply(a, b)
        var options: Set<Int> = [answer]
        while options.count < 4 {
            let delta = Int.random(in: 1...12) * (Bool.random() ? 1 : -1)
            let candidate = answer + delta
            if candidate >= 0 { options.insert(candidate) }
        }

        return Question(
            leftOperand: a,
            rightOperand: b,
            op: op,
            options: options.shuffled()
        )
    }
}
