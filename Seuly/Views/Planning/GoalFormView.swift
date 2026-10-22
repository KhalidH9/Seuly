import SwiftUI

struct GoalFormView: View {
    @State private var viewModel: GoalFormViewModel

    init(viewModel: GoalFormViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ModalFormScaffold(
            title: L10n.text("goal.form.create", table: .planning),
            canSave: viewModel.canSave,
            isSaving: viewModel.isSaving,
            save: viewModel.save
        ) {
            GoalFormContentView(viewModel: viewModel)
        }
    }
}
