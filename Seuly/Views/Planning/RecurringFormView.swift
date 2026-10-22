import SwiftUI

struct RecurringFormView: View {
    @State private var viewModel: RecurringFormViewModel

    init(viewModel: RecurringFormViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ModalFormScaffold(
            title: L10n.text("recurring.form.add", table: .planning),
            canSave: viewModel.canSave,
            isSaving: viewModel.isSaving,
            save: viewModel.save
        ) {
            RecurringFormContentView(viewModel: viewModel)
        }
    }
}
