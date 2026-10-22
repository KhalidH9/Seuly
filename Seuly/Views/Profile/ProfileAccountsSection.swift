import SwiftUI

/// Accounts summary with a route into full management. Shows the first three
/// so the section stays a summary rather than a second accounts screen.
struct ProfileAccountsSection: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: SettingsViewModel
    let onPresentAccount: (FinancialAccount?) -> Void

    var body: some View {
        Section {
            if viewModel.balances.isEmpty {
                Button {
                    onPresentAccount(nil)
                } label: {
                    ProfileNavigationRow(
                        systemImage: "plus",
                        tint: theme.brandPrimary,
                        title: L10n.text("accounts.empty.action", table: .settings),
                        subtitle: L10n.text(
                            "accounts.empty.message",
                            table: .settings
                        )
                    )
                }
            } else {
                ForEach(previewBalances) { balance in
                    Button {
                        onPresentAccount(balance.account)
                    } label: {
                        AccountBalanceRow(
                            balance: balance,
                            currency: viewModel.currency(for: balance.account),
                            hidesAmount: viewModel.isPrivacyModeEnabled
                        )
                    }
                    .buttonStyle(.plain)
                }
                NavigationLink {
                    ProfileAccountsScreen(
                        viewModel: viewModel,
                        onPresentAccount: onPresentAccount
                    )
                } label: {
                    ProfileNavigationRow(
                        systemImage: "building.columns.fill",
                        tint: theme.savings,
                        title: L10n.text("accounts.manage", table: .settings),
                        value: AppFormatters.integer(viewModel.accountCount)
                    )
                }
            }
        } header: {
            Text(L10n.text("accounts.title", table: .settings))
        } footer: {
            Text(L10n.text("accounts.subtitle", table: .settings))
        }
    }

    private var previewBalances: [AccountBalance] {
        Array(viewModel.balances.prefix(3))
    }
}
