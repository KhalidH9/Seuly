import SwiftUI

/// One day of transactions. Edit and delete are offered as swipe actions and
/// repeated in the context menu, so both the quick and the deliberate path
/// reach the same two operations.
struct ActivityDaySection: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: ActivityViewModel
    let group: TransactionDayGroup
    let onEdit: (FinancialTransaction) -> Void

    var body: some View {
        Section {
            ForEach(group.transactions) { transaction in
                Button {
                    viewModel.selectedTransaction = transaction
                } label: {
                    TransactionRow(
                        transaction: transaction,
                        category: viewModel.category(for: transaction),
                        account: viewModel.account(for: transaction),
                        amountMinor: viewModel.signedAmount(for: transaction),
                        currency: viewModel.currency,
                        hidesAmount: viewModel.isPrivacyModeEnabled
                    )
                }
                .buttonStyle(.plain)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        viewModel.deletionCandidate = transaction
                    } label: {
                        Label(
                            L10n.text("action.remove", table: .activity),
                            systemImage: "trash"
                        )
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        onEdit(transaction)
                    } label: {
                        Label(
                            L10n.text("action.edit", table: .activity),
                            systemImage: "pencil"
                        )
                    }
                    .tint(theme.brandPrimary)
                }
                .contextMenu {
                    Button {
                        onEdit(transaction)
                    } label: {
                        Label(
                            L10n.text("action.edit", table: .activity),
                            systemImage: "pencil"
                        )
                    }
                    Button(role: .destructive) {
                        viewModel.deletionCandidate = transaction
                    } label: {
                        Label(
                            L10n.text("action.remove", table: .activity),
                            systemImage: "trash"
                        )
                    }
                }
            }
        } header: {
            Text(viewModel.dayTitle(group.date))
                .font(SeulyFont.footnoteEmphasized)
                .foregroundStyle(theme.textSecondary)
        }
    }
}
