import Foundation

/// One place that decides whether a credential is well formed, so the sign-in
/// button, the registration steps, and the field error states cannot disagree.
enum AuthCredentialRules {
    static let minimumPasswordLength = 6

    static func isValidEmail(_ value: String) -> Bool {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard
            let at = trimmed.firstIndex(of: "@"),
            at != trimmed.startIndex,
            trimmed.lastIndex(of: "@") == at
        else { return false }
        let domain = trimmed[trimmed.index(after: at)...]
        guard let dot = domain.firstIndex(of: ".") else { return false }
        return dot != domain.startIndex
            && domain.index(after: dot) != domain.endIndex
            && !domain.contains(" ")
    }

    static func isValidPassword(_ value: String) -> Bool {
        value.count >= minimumPasswordLength
    }

    static func isValidName(_ value: String) -> Bool {
        !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
