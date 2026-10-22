import SwiftUI

/// What protects the data. Read-only facts, presented as a list so each one
/// is a scannable label-and-value pair.
struct ProfileSecurityScreen: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: SettingsViewModel

    var body: some View {
        List {
            Section {
                ProfileNavigationRow(
                    systemImage: "banknote.fill",
                    tint: theme.brandPrimary,
                    title: L10n.text("data.currency", table: .settings),
                    value: viewModel.currencyName
                )
                ProfileNavigationRow(
                    systemImage: "lock.shield.fill",
                    tint: theme.income,
                    title: L10n.text("data.access", table: .settings),
                    value: L10n.text("data.access_value", table: .settings)
                )
                ProfileNavigationRow(
                    systemImage: "externaldrive.fill.badge.checkmark",
                    tint: theme.savings,
                    title: L10n.text("data.database", table: .settings),
                    value: L10n.text("data.database_value", table: .settings),
                    forcesValueDirection: true
                )
            } header: {
                Text(L10n.text("data.title", table: .settings))
            } footer: {
                Text(L10n.text("data.footer", table: .settings))
            }
            Section {
                ProfileNavigationRow(
                    systemImage: "eye.slash.fill",
                    tint: theme.investment,
                    title: L10n.text("privacy.mode", table: .settings),
                    value: privacyStateText
                )
            } header: {
                Text(L10n.text("privacy.title", table: .settings))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(L10n.text("data.title", table: .settings))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var privacyStateText: String {
        L10n.text(
            viewModel.isPrivacyModeEnabled
                ? "privacy.state.on"
                : "privacy.state.off",
            table: .settings
        )
    }
}
