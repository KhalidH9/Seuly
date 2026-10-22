import SwiftUI

struct DashboardRecentSection: View {
    let viewModel: DashboardViewModel
    let onShowAll: () -> Void
    let onAdd: () -> Void

    var body: some View {
        VStack(spacing: SeulyLayout.spacingM) {
            SeulySectionHeader(
                title: L10n.text("recent.title", table: .dashboard),
                subtitle: L10n.text("recent.subtitle", table: .dashboard),
                actionTitle: hasTransactions
                    ? L10n.text("recent.action", table: .dashboard)
                    : nil,
                action: hasTransactions ? onShowAll : nil
            )
            SeulyCard {
                if hasTransactions {
                    SeulyRowStack(data: viewModel.recentTransactions) { item in
                        TransactionRow(
                            transaction: item,
                            category: viewModel.category(for: item),
                            account: viewModel.account(for: item),
                            amountMinor: viewModel.signedAmount(for: item),
                            currency: viewModel.currency,
                            hidesAmount: viewModel.isPrivacyModeEnabled
                        )
                    }
                } else {
                    EmptyStateView(
                        systemImage: "arrow.left.arrow.right.circle",
                        title: L10n.text("recent.empty.title", table: .dashboard),
                        message: L10n.text(
                            "recent.empty.message",
                            table: .dashboard
                        ),
                        actionTitle: L10n.text(
                            "recent.empty.action",
                            table: .dashboard
                        ),
                        action: onAdd
                    )
                }
            }
        }
    }

    private var hasTransactions: Bool {
        !viewModel.recentTransactions.isEmpty
    }
}
