import Foundation

extension PasswordRecoveryViewModel {
    func resetSession() {
        password = ""
        confirmation = ""
        isSubmitting = false
        errorMessage = nil
    }
}
