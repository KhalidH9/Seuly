import SwiftUI

struct GoalContributionView: View {
    @State private var viewModel: GoalContributionViewModel

    init(viewModel: GoalContributionViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ModalFormScaffold(
            title: L10n.text("goal.contribution.title", table: .planning),
            saveTitle: L10n.text("goal.contribution.save", table: .planning),
            canSave: viewModel.canSave,
            isSaving: viewModel.isSaving,
            save: viewModel.save
        ) {
            GoalContributionContentView(viewModel: viewModel)
        }
    }
}
