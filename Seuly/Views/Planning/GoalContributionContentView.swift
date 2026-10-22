import SwiftUI

/// Contribution form. The goal card stays at the top so the amount being
/// entered is read against the progress it will move.
struct GoalContributionContentView: View {
    @Bindable var viewModel: GoalContributionViewModel
    @FocusState private var focusesNote: Bool

    var body: some View {
        VStack(spacing: SeulyLayout.spacingL) {
            GoalProgressCard(
                goal: viewModel.goal,
                currency: viewModel.currency,
                hidesAmount: false
            )
            AmountEntryField(
                text: $viewModel.amountText,
                currency: viewModel.currency,
                title: L10n.text(
                    "goal.contribution.amount",
                    table: .planning
                )
            )
            SeulyCard {
                VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
                    LabeledFormField(
                        L10n.text("goal.contribution.note", table: .planning)
                    ) {
                        TextField(
                            L10n.text(
                                "goal.contribution.note_placeholder",
                                table: .planning
                            ),
                            text: $viewModel.note
                        )
                        .submitLabel(.done)
                        .focused($focusesNote)
                        .seulyField(isFocused: focusesNote)
                    }
                    InfoCalloutView(
                        message: L10n.text(
                            "goal.contribution.help",
                            table: .planning
                        )
                    )
                }
            }
            if let error = viewModel.errorMessage {
                ErrorBanner(message: error)
            }
        }
    }
}
