import Foundation
import Supabase

extension ErrorPresenter {
    static func authMessage(
        for error: Error,
        context: ErrorPresentationContext
    ) -> String? {
        guard let authError = error as? AuthError else { return nil }
        let code = authError.errorCode
        if code == .invalidCredentials {
            return text("error.auth.invalid_credentials")
        }
        if code == .emailExists || code == .userAlreadyExists {
            return text("error.auth.email_in_use")
        }
        if code == .weakPassword {
            return text("error.auth.weak_password")
        }
        if code == .emailNotConfirmed {
            return text("error.auth.email_not_confirmed")
        }
        if code == .sessionNotFound || code == .sessionExpired {
            return text("error.session.expired")
        }
        if isRateLimited(code) {
            return text("error.request.rate_limited")
        }
        return text(key(for: context))
    }

    private static func isRateLimited(_ code: ErrorCode) -> Bool {
        code == .overRequestRateLimit
            || code == .overEmailSendRateLimit
            || code == .overSMSSendRateLimit
    }
}
