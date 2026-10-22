import Foundation
import Observation

@MainActor
@Observable
final class AuthViewModel {
    typealias Mode = AuthMode

    var mode: Mode = .signIn
    /// Registration step index. Presentation state only; nothing is persisted
    /// until the final step submits.
    var registrationStep = 0
    var displayName = ""
    var email = ""
    var password = ""
    var isSubmitting = false
    var errorMessage: String?
    var noticeMessage: String?
    let model: AuthModel

    init(model: AuthModel) {
        self.model = model
    }

    var isEmailValid: Bool { AuthCredentialRules.isValidEmail(email) }
    var isPasswordValid: Bool {
        AuthCredentialRules.isValidPassword(password)
    }
    var isNameValid: Bool { AuthCredentialRules.isValidName(displayName) }

    var canSubmit: Bool {
        guard !isSubmitting, isEmailValid, isPasswordValid else { return false }
        return mode == .signIn || isNameValid
    }
}
