import SwiftUI

/// The attribute list for a transaction. Rendered as a list section so it
/// inherits the platform row metrics and separator insets.
struct TransactionDetailCard: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: ActivityViewModel
    let transaction: FinancialTransaction

    var body: some View {
        Section {
            TransactionDetailRow(
                title: L10n.text("detail.type", table: .activity),
                value: transaction.kind.displayName
            )
            TransactionDetailRow(
                title: L10n.text("detail.date", table: .activity),
                value: AppFormatters.fullDate(transaction.effectiveDate)
            )
            TransactionDetailRow(
                title: L10n.text("detail.category", table: .activity),
                value: categoryName
            )
            TransactionDetailRow(
                title: L10n.text("detail.from", table: .activity),
                value: viewModel.account(for: transaction)?.name
                    ?? L10n.text("not_available", table: .shared)
            )
            if transaction.kind == .transfer {
                TransactionDetailRow(
                    title: L10n.text("detail.to", table: .activity),
                    value: viewModel.destinationAccount(for: transaction)?.name
                        ?? L10n.text("not_available", table: .shared)
                )
            }
            if !transaction.note.isEmpty {
                TransactionDetailRow(
                    title: L10n.text("detail.note", table: .activity),
                    value: transaction.note
                )
            }
        } header: {
            Text(L10n.text("detail.section", table: .activity))
        }
    }

    private var categoryName: String {
        guard transaction.kind != .transfer else {
            return L10n.text("detail.transfer", table: .activity)
        }
        return viewModel.category(for: transaction)?.localizedName
            ?? L10n.text("not_available", table: .shared)
    }
}
