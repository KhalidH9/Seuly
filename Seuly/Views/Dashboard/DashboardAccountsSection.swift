import SwiftUI

struct DashboardAccountsSection: View {
    let viewModel: DashboardViewModel
    let onAdd: () -> Void

    var body: some View {
        if !balances.isEmpty {
            VStack(spacing: SeulyLayout.spacingM) {
                SeulySectionHeader(
                    title: L10n.text("accounts.title", table: .dashboard),
                    subtitle: L10n.format(
                        "accounts.count",
                        table: .dashboard,
                        AppFormatters.integer(balances.count)
                    ),
                    actionTitle: L10n.text("action.add", table: .dashboard),
                    action: onAdd
                )
                SeulyCard {
                    SeulyRowStack(data: balances) { balance in
                        AccountBalanceRow(
                            balance: balance,
                            currency: viewModel.currency(for: balance.account),
                            hidesAmount: viewModel.isPrivacyModeEnabled,
                            showsInstitution: false
                        )
                    }
                }
            }
        }
    }

    private var balances: [AccountBalance] {
        viewModel.analytics.accountBalances
    }
}
