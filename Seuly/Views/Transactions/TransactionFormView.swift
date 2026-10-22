import SwiftUI

struct TransactionFormView: View {
    @State private var viewModel: TransactionFormViewModel

    init(viewModel: TransactionFormViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ModalFormScaffold(
            title: title,
            canSave: viewModel.canSave,
            isSaving: viewModel.isSaving,
            save: viewModel.save
        ) {
            TransactionFormContentView(viewModel: viewModel)
        }
    }

    private var title: String {
        viewModel.existingTransaction == nil
            ? L10n.format(
                "form.add",
                table: .transactions,
                viewModel.entry.kind.displayName
            )
            : L10n.format(
                "form.edit",
                table: .transactions,
                viewModel.entry.kind.displayName
            )
    }
}
