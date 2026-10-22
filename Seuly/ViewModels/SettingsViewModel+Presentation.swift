import Foundation

/// Presentation values the profile screen displays. Everything is derived
/// from the workspace already in memory; no new reads are issued.
extension SettingsViewModel {
    var analytics: FinanceAnalytics {
        FinanceAnalytics(workspace: workspace)
    }

    var netWorthMinor: Int64 { analytics.netWorthMinor }

    var accountCount: Int {
        workspace.accounts.filter { $0.archivedAt == nil }.count
    }

    var monthTransactionCount: Int {
        workspace.transactions.filter {
            $0.status != .void && $0.effectiveDate.isInSameMonth(as: .now)
        }
        .count
    }

    var activeGoalCount: Int {
        workspace.goals.filter { $0.status == .active }.count
    }

    var displayName: String {
        profile?.localizedDisplayName
            ?? L10n.text("profile.fallback_name", table: .settings)
    }

    /// Up to two initials, so a two-word name reads as a monogram.
    var initials: String {
        let words = displayName
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first.map(String.init) }
        guard !words.isEmpty else {
            return L10n.text("profile.fallback_initial", table: .settings)
        }
        return words.joined().uppercased()
    }

    var memberSinceText: String? {
        guard let createdAt = profile?.createdAt else { return nil }
        return L10n.format(
            "profile.member_since",
            table: .settings,
            AppFormatters.monthYear(createdAt)
        )
    }

    var currencyName: String {
        currency?.localizedName
            ?? L10n.text("not_available", table: .shared)
    }

    var appVersionText: String {
        let version = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String ?? L10n.text("not_available", table: .shared)
        return L10n.format("data.version", table: .settings, version)
    }

    var appBuildText: String {
        Bundle.main.object(
            forInfoDictionaryKey: "CFBundleVersion"
        ) as? String ?? L10n.text("not_available", table: .shared)
    }
}
