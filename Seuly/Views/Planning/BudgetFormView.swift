import SwiftUI

struct BudgetFormView: View {
    @State private var viewModel: BudgetFormViewModel

    init(viewModel: BudgetFormViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ModalFormScaffold(
            title: viewModel.existingLine == nil
                ? L10n.text("budget.form.create", table: .planning)
                : L10n.text("budget.form.edit", table: .planning),
            canSave: viewModel.canSave,
            isSaving: viewModel.isSaving,
            save: viewModel.save
        ) {
            BudgetFormContentView(viewModel: viewModel)
        }
    }
}
