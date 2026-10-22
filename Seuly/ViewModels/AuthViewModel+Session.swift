import Foundation

extension AuthViewModel {
    func resetSession() {
        mode = .signIn
        displayName = ""
        email = ""
        password = ""
        isSubmitting = false
        errorMessage = nil
        noticeMessage = nil
    }
}
