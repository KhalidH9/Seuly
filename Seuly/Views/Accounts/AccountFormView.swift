import SwiftUI

struct AccountFormView: View {
    @State private var viewModel: AccountFormViewModel

    init(viewModel: AccountFormViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ModalFormScaffold(
            title: viewModel.existingAccount == nil
                ? L10n.text("account.form.add", table: .settings)
                : L10n.text("account.form.edit", table: .settings),
            canSave: viewModel.canSave,
            isSaving: viewModel.isSaving,
            save: viewModel.save
        ) {
            AccountFormContentView(viewModel: viewModel)
        }
    }
}
