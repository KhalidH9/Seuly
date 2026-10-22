import SwiftUI

struct TransactionAccountPickerView: View {
    @Bindable var viewModel: TransactionFormViewModel

    var body: some View {
        AccountPickerField(
            title: title,
            selection: $viewModel.entry.sourceAccountID,
            accounts: viewModel.entry.activeAccounts,
            onChange: viewModel.entry.sourceChanged
        )
    }

    private var title: String {
        L10n.text(
            viewModel.entry.kind == .income
                ? "field.to_account"
                : "field.from_account",
            table: .transactions
        )
    }
}
