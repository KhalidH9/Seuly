import Foundation

/// Step-by-step registration: name, then address, then password. Each step
/// gates on its own field so the user learns about a problem while they are
/// still looking at the field that caused it.
extension AuthViewModel {
    enum RegistrationStep: Int, CaseIterable {
        case name
        case email
        case password
    }

    static var registrationStepCount: Int {
        RegistrationStep.allCases.count
    }

    var currentRegistrationStep: RegistrationStep {
        RegistrationStep(rawValue: registrationStep) ?? .name
    }

    var isFirstRegistrationStep: Bool { registrationStep == 0 }

    var isLastRegistrationStep: Bool {
        registrationStep == Self.registrationStepCount - 1
    }

    var canAdvanceRegistration: Bool {
        guard !isSubmitting else { return false }
        return switch currentRegistrationStep {
        case .name: isNameValid
        case .email: isEmailValid
        case .password: isPasswordValid
        }
    }

    /// Advances a step, or submits on the last one. Returns without touching
    /// the step when the current field is not yet valid.
    func advanceRegistration() async {
        guard canAdvanceRegistration else { return }
        guard isLastRegistrationStep else {
            registrationStep += 1
            errorMessage = nil
            return
        }
        await submit()
    }

    func retreatRegistration() {
        guard !isFirstRegistrationStep else { return }
        registrationStep -= 1
        errorMessage = nil
    }
}
