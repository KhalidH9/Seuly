import Foundation

enum ErrorPresentationContext: Equatable {
    case signIn
    case signUp
    case signOut
    case passwordReset
    case passwordUpdate
    case authenticationLink
    case workspaceLoad
    case mutation
}

enum ErrorPresenter {
    static func message(
        for error: Error,
        context: ErrorPresentationContext
    ) -> String {
        if let appError = error as? AppError {
            return appError.localizedDescription
        }
        if let message = authMessage(for: error, context: context) {
            return message
        }
        if isNetworkError(error) {
            return text("error.network.unavailable")
        }
        return text(key(for: context))
    }

    static func key(
        for context: ErrorPresentationContext
    ) -> String {
        switch context {
        case .signIn: "error.auth.sign_in_failed"
        case .signUp: "error.auth.sign_up_failed"
        case .signOut: "error.auth.sign_out_failed"
        case .passwordReset: "error.auth.password_reset_failed"
        case .passwordUpdate: "error.auth.password_update_failed"
        case .authenticationLink: "error.auth.link_failed"
        case .workspaceLoad: "error.data.load_failed"
        case .mutation: "error.data.save_failed"
        }
    }

    private static func isNetworkError(_ error: Error) -> Bool {
        let value = error as NSError
        guard value.domain == NSURLErrorDomain else { return false }
        return [
            NSURLErrorNotConnectedToInternet,
            NSURLErrorTimedOut,
            NSURLErrorCannotFindHost,
            NSURLErrorCannotConnectToHost,
            NSURLErrorNetworkConnectionLost,
            NSURLErrorDNSLookupFailed,
            NSURLErrorSecureConnectionFailed,
            NSURLErrorDataNotAllowed
        ].contains(value.code)
    }

    static func text(_ key: String) -> String {
        L10n.text(key, table: .errors)
    }
}
