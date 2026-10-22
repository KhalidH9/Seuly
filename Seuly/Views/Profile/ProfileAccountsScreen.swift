import SwiftUI

/// Full account management. Every account is a row that opens its editor,
/// and the add action lives in the navigation bar where it stays reachable.
struct ProfileAccountsScreen: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: SettingsViewModel
    let onPresentAccount: (FinancialAccount?) -> Void

    var body: some View {
        List {
            Section {
                ForEach(viewModel.balances) { balance in
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
            } header: {
                Text(L10n.text("accounts.title", table: .settings))
            } footer: {
                Text(L10n.text("accounts.subtitle", table: .settings))
            }
            Section {
                totalRow
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(L10n.text("accounts.manage", table: .settings))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    onPresentAccount(nil)
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(
                    L10n.text("accounts.add", table: .settings)
                )
            }
        }
    }

    private var totalRow: some View {
        HStack {
            Text(L10n.text("profile.stat.net_worth", table: .settings))
                .font(SeulyFont.bodyEmphasized)
                .foregroundStyle(theme.textPrimary)
            Spacer()
            PrivacySensitiveAmount(
                minorUnits: viewModel.netWorthMinor,
                currency: viewModel.currency,
                isHidden: viewModel.isPrivacyModeEnabled,
                style: SeulyFont.moneyRow,
                symbolScale: .body
            )
        }
        .frame(minHeight: SeulyLayout.minimumTapTarget)
        .accessibilityElement(children: .combine)
    }
}
