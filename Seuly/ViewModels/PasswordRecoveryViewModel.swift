import Foundation
import Observation

@MainActor
@Observable
final class PasswordRecoveryViewModel {
    var password = ""
    var confirmation = ""
    var isSubmitting = false
    var errorMessage: String?
    private let model: AuthModel

    init(model: AuthModel) {
        self.model = model
    }

    var canSubmit: Bool {
        password.count >= 8
            && password == confirmation
            && !isSubmitting
    }

    func updatePassword() async {
        guard canSubmit else {
            errorMessage = password.count < 8
                ? L10n.text("validation.password.length", table: .errors)
                : L10n.text("validation.password.mismatch", table: .errors)
            return
        }
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            try await model.updatePassword(password)
            password = ""
            confirmation = ""
            errorMessage = nil
        } catch {
            errorMessage = model.errorMessage
                ?? ErrorPresenter.message(for: error, context: .passwordUpdate)
        }
    }

    func cancel() async {
        password = ""
        confirmation = ""
        let didSignOut = await model.signOut()
        if !didSignOut {
            errorMessage = model.errorMessage
        }
    }
}
