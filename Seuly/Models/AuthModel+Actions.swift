import Foundation
import Supabase

extension AuthModel {
    func signIn(email: String, password: String) async throws {
        do {
            let session = try await client.auth.signIn(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            phase = .signedIn(
                AppUser(
                    id: session.user.id,
                    email: session.user.email ?? email
                )
            )
            clearPasswordRecovery()
            errorMessage = nil
        } catch {
            errorMessage = ErrorPresenter.message(for: error, context: .signIn)
            throw error
        }
    }

    func signUp(
        email: String,
        password: String,
        displayName: String
    ) async throws {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            let response = try await client.auth.signUp(
                email: cleanEmail,
                password: password,
                data: [
                    "display_name": .string(
                        displayName.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                    )
                ]
            )
            guard let session = response.session else {
                let message = L10n.text("error.auth.no_session", table: .errors)
                throw AppError.operationFailed(message)
            }
            let user = AppUser(
                id: session.user.id,
                email: session.user.email ?? cleanEmail
            )
            phase = .signedIn(user)
            clearPasswordRecovery()
            errorMessage = nil
        } catch {
            errorMessage = ErrorPresenter.message(for: error, context: .signUp)
            throw error
        }
    }

    func signOut() async -> Bool {
        do {
            try await client.auth.signOut(scope: .local)
            phase = .signedOut
            clearPasswordRecovery()
            errorMessage = nil
            return true
        } catch {
            errorMessage = ErrorPresenter.message(for: error, context: .signOut)
            return false
        }
    }

    func sendPasswordReset(email: String) async throws {
        do {
            try await client.auth.resetPasswordForEmail(
                email.trimmingCharacters(in: .whitespacesAndNewlines),
                redirectTo: AppConfiguration.passwordRecoveryCallbackURL
            )
            errorMessage = nil
        } catch {
            errorMessage = ErrorPresenter.message(for: error, context: .passwordReset)
            throw error
        }
    }

    func updatePassword(_ password: String) async throws {
        do {
            try await client.auth.update(
                user: UserAttributes(password: password)
            )
            clearPasswordRecovery()
            errorMessage = nil
        } catch {
            errorMessage = ErrorPresenter.message(for: error, context: .passwordUpdate)
            throw error
        }
    }
}
