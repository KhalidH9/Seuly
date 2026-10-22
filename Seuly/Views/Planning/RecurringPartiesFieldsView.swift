import SwiftUI

struct RecurringPartiesFieldsView: View {
    @Bindable var viewModel: RecurringFormViewModel

    var body: some View {
        Group {
            AccountPickerField(
                title: sourceTitle,
                selection: $viewModel.entry.sourceAccountID,
                accounts: viewModel.entry.activeAccounts,
                onChange: viewModel.entry.sourceChanged
            )
            if viewModel.entry.kind == .transfer {
                AccountPickerField(
                    title: L10n.text(
                        "field.to_account",
                        table: .transactions
                    ),
                    selection: $viewModel.entry.destinationAccountID,
                    accounts: viewModel.entry.availableDestinations
                )
            } else {
                CategoryPickerField(
                    title: L10n.text("field.category", table: .transactions),
                    selection: $viewModel.entry.categoryID,
                    categories: viewModel.entry.availableCategories
                )
            }
        }
    }

    private var sourceTitle: String {
        L10n.text(
            viewModel.entry.kind == .income
                ? "field.to_account"
                : "field.from_account",
            table: .transactions
        )
    }
}
