import SwiftUI

/// Money form order: what kind, how much, then the details. Direction first
/// because it changes which fields the rest of the form even shows.
struct TransactionFormContentView: View {
    @Bindable var viewModel: TransactionFormViewModel

    var body: some View {
        VStack(spacing: SeulyLayout.spacingL) {
            TransactionKindSelector(
                selection: viewModel.entry.kind,
                isDisabled: viewModel.existingTransaction != nil,
                onSelect: viewModel.selectKind
            )
            AmountEntryField(
                text: $viewModel.entry.amountText,
                currency: viewModel.entry.currency
            )
            SeulyCard {
                TransactionDetailsFieldsView(viewModel: viewModel)
            }
            if let error = viewModel.errorMessage {
                ErrorBanner(message: error)
            }
        }
    }
}
