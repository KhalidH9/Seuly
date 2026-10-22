import Foundation

/// Which credential flow the auth screen is showing. Sign-in is the entry
/// point; registration is reached deliberately from it.
enum AuthMode: String, CaseIterable, Identifiable, Sendable {
    case signIn
    case createAccount

    var id: String { rawValue }

    var displayName: String {
        L10n.text("auth.mode.\(rawValue)", table: .data)
    }
}
