import SwiftUI

struct GoalFormContentView: View {
    @Bindable var viewModel: GoalFormViewModel

    var body: some View {
        VStack(spacing: SeulyLayout.spacingL) {
            EntityPreviewCard(
                systemImage: viewModel.iconKey,
                colorRole: viewModel.colorRole,
                title: viewModel.name.isEmpty
                    ? L10n.text("goal.preview.placeholder", table: .planning)
                    : viewModel.name,
                subtitle: viewModel.kind.displayName
            )
            AmountEntryField(
                text: $viewModel.targetText,
                currency: viewModel.currency,
                title: L10n.text("goal.field.amount", table: .planning)
            )
            SeulyCard {
                GoalFieldsView(viewModel: viewModel)
            }
            if let error = viewModel.errorMessage {
                ErrorBanner(message: error)
            }
        }
    }
}
