import SwiftUI

struct TransactionDestinationPickerView: View {
    @Bindable var viewModel: TransactionFormViewModel

    var body: some View {
        AccountPickerField(
            title: L10n.text("field.to_account", table: .transactions),
            selection: $viewModel.entry.destinationAccountID,
            accounts: viewModel.entry.availableDestinations
        )
    }
}
