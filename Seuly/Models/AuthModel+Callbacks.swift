import Foundation

extension AuthModel {
    func handle(url: URL) async throws {
        guard let callback = AppConfiguration.authCallback(for: url) else {
            let error = AppError.operationFailed(
                L10n.text("error.auth.link_unrecognized", table: .errors)
            )
            errorMessage = ErrorPresenter.message(
                for: error,
                context: .authenticationLink
            )
            throw error
        }
        do {
            let session = try await client.auth.session(from: url)
            phase = .signedIn(
                AppUser(
                    id: session.user.id,
                    email: session.user.email ?? ""
                )
            )
            if callback == .passwordRecovery {
                beginPasswordRecovery()
            } else {
                clearPasswordRecovery()
            }
            errorMessage = nil
        } catch {
            if callback == .passwordRecovery {
                clearPasswordRecovery()
            }
            let callbackError = AppError.operationFailed(
                L10n.text("error.auth.link_expired", table: .errors)
            )
            errorMessage = ErrorPresenter.message(
                for: callbackError,
                context: .authenticationLink
            )
            throw callbackError
        }
    }
}
