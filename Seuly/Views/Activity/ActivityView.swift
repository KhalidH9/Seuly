import SwiftUI

struct ActivityView: View {
    @Environment(\.seulyTheme) private var theme
    @State private var viewModel: ActivityViewModel
    let onPresent: (AppSheetRoute) -> Void

    init(
        viewModel: ActivityViewModel,
        onPresent: @escaping (AppSheetRoute) -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onPresent = onPresent
    }

    var body: some View {
        ActivityRemovalDialog(viewModel: viewModel) {
            NavigationStack {
                ActivityTimelineView(
                    viewModel: viewModel,
                    onAdd: { onPresent(.transaction(.expense, nil)) },
                    onEdit: edit
                )
                .navigationTitle(L10n.text("title", table: .activity))
                .navigationBarTitleDisplayMode(.large)
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text(L10n.text("search.prompt", table: .activity))
                )
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) { addMenu }
                }
                .toolbarBackground(
                    theme.navigationBackground,
                    for: .navigationBar
                )
                .sheet(
                    item: $viewModel.selectedTransaction,
                    onDismiss: completeDetailDismissal
                ) { transaction in
                    detailSheet(for: transaction)
                }
            }
        }
    }

    private var addMenu: some View {
        Menu {
            ForEach(TransactionKind.allCases) { kind in
                Button {
                    onPresent(.transaction(kind, nil))
                } label: {
                    Label(kind.displayName, systemImage: kind.systemImage)
                }
            }
        } label: {
            Image(systemName: "plus")
        }
        .accessibilityLabel(L10n.text("add.accessibility", table: .activity))
    }

    private func detailSheet(
        for transaction: FinancialTransaction
    ) -> some View {
        TransactionDetailView(
            viewModel: viewModel,
            transaction: transaction,
            onEdit: {
                viewModel.requestEditAfterDetailDismissal(transaction)
            },
            onDelete: {
                viewModel.requestDeletionAfterDetailDismissal(transaction)
            }
        )
        .environment(\.seulyTheme, theme)
    }

    private func completeDetailDismissal() {
        switch viewModel.takeDetailDismissalAction() {
        case .edit(let transaction):
            onPresent(.transaction(transaction.kind, transaction))
        case .delete(let transaction):
            viewModel.deletionCandidate = transaction
        case nil:
            break
        }
    }

    private func edit(_ transaction: FinancialTransaction) {
        onPresent(.transaction(transaction.kind, transaction))
    }
}
