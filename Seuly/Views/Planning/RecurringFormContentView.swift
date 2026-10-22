import SwiftUI

struct RecurringFormContentView: View {
    @Bindable var viewModel: RecurringFormViewModel

    var body: some View {
        VStack(spacing: SeulyLayout.spacingL) {
            TransactionKindSelector(
                selection: viewModel.entry.kind,
                onSelect: viewModel.entry.selectKind
            )
            AmountEntryField(
                text: $viewModel.entry.amountText,
                currency: viewModel.entry.currency
            )
            SeulyCard {
                RecurringDetailsFieldsView(viewModel: viewModel)
            }
            if let error = viewModel.errorMessage {
                ErrorBanner(message: error)
            }
        }
    }
}
