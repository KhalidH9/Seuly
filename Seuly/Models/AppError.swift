import Foundation

enum AppError: LocalizedError, Equatable {
    case unauthenticated
    case operationFailed(String)

    var errorDescription: String? {
        switch self {
        case .operationFailed(let message):
            message
        case .unauthenticated:
            L10n.text("error.session.expired", table: .errors)
        }
    }
}
