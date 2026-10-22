import Foundation

struct AppUser: Identifiable, Equatable, Sendable {
    let id: UUID
    let email: String
}

struct FinanceProfile: Identifiable, Equatable, Sendable {
    let id: UUID
    var displayName: String
    var currencyCode: String
    var onboardingCompleted: Bool
    var createdAt: Date

    var localizedDisplayName: String {
        let fallbackNames = ["Seuly member", "Siyuli member"]
        guard fallbackNames.contains(displayName) else { return displayName }
        return L10n.text("profile.default_name", table: .data)
    }
}
