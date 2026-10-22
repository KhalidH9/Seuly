import SwiftUI

/// Transaction detail. Grouped list under a hero so the amount reads first
/// and every attribute below it is a scannable label-and-value pair.
struct TransactionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.seulyTheme) private var theme
    let viewModel: ActivityViewModel
    let transaction: FinancialTransaction
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TransactionDetailHeader(
                        viewModel: viewModel,
                        transaction: transaction
                    )
                    .seulyPlainListRow()
                }
                TransactionDetailCard(
                    viewModel: viewModel,
                    transaction: transaction
                )
                Section {
                    TransactionDetailActions(
                        onEdit: onEdit,
                        onDelete: onDelete
                    )
                    .seulyPlainListRow()
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(L10n.text("detail.title", table: .activity))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.text("detail.done", table: .activity)) {
                        dismiss()
                    }
                }
            }
            .toolbarBackground(
                theme.navigationBackground,
                for: .navigationBar
            )
        }
        .presentationDragIndicator(.visible)
    }
}
