import Foundation

extension AuthViewModel {
    func submit() async {
        guard canSubmit else {
            errorMessage = L10n.text(
                "validation.auth.credentials",
                table: .errors
            )
            return
        }
        isSubmitting = true
        errorMessage = nil
        noticeMessage = nil
        defer { isSubmitting = false }
        do {
            switch mode {
            case .signIn:
                try await model.signIn(email: email, password: password)
            case .createAccount:
                try await model.signUp(
                    email: email,
                    password: password,
                    displayName: displayName
                )
            }
            password = ""
        } catch {
            errorMessage = model.errorMessage
                ?? ErrorPresenter.message(
                    for: error,
                    context: mode == .signIn ? .signIn : .signUp
                )
        }
    }

    func resetPassword() async {
        guard isEmailValid else {
            errorMessage = L10n.text(
                "validation.auth.email_first",
                table: .errors
            )
            return
        }
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            try await model.sendPasswordReset(email: email)
            noticeMessage = L10n.text(
                "notice.auth.password_reset_sent",
                table: .errors
            )
            errorMessage = nil
        } catch {
            errorMessage = model.errorMessage
                ?? ErrorPresenter.message(
                    for: error,
                    context: .passwordReset
                )
        }
    }

    func changeMode(_ newMode: Mode) {
        mode = newMode
        registrationStep = 0
        password = ""
        errorMessage = nil
        noticeMessage = nil
    }
}
