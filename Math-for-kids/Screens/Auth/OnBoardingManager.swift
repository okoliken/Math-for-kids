import SwiftUI

enum OnBoardingSteps: Int, CaseIterable {
    case welcome = 0
    case enterName = 1
    case niceToMeetYou = 2
    case howOldAreYou = 3
    case clarifyLastQuestion = 4
    case whatIsYourGender = 5
    case startJourney = 6
    case dayOneStreak = 7
}

enum Gender: String, CaseIterable {
    case boy = "boy"
    case girl = "girl"
}

@Observable
class ManageOnboarding {
    var currentStep: OnBoardingSteps = .welcome
    
    var childName: String = ""
    var childAge: Int?
    var childGender: Gender? = nil

    func nextStep() {
        guard currentStep.rawValue < OnBoardingSteps.dayOneStreak.rawValue else { return }
        currentStep = OnBoardingSteps(rawValue: currentStep.rawValue + 1) ?? .welcome
    }

    func previousStep() {
        guard currentStep.rawValue > OnBoardingSteps.welcome.rawValue else { return }
        currentStep = OnBoardingSteps(rawValue: currentStep.rawValue - 1) ?? .welcome
    }
    
    func skip() {
        nextStep()
    }
    
    func isLastStep() -> Bool {
        currentStep == .startJourney
    }
    
    func isFirstStep() -> Bool {
        currentStep == .welcome
    }
}
