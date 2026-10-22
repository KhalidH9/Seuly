import SwiftUI

struct PlanningGoalsContentView: View {
    let viewModel: PlanningViewModel
    let onAdd: () -> Void
    let onContribute: (SavingsGoal) -> Void

    var body: some View {
        Group {
            if viewModel.activeGoals.isEmpty {
                SeulyCard {
                    EmptyStateView(
                        systemImage: "target",
                        title: L10n.text("goal.empty.title", table: .planning),
                        message: L10n.text(
                            "goal.empty.message",
                            table: .planning
                        ),
                        actionTitle: L10n.text(
                            "goal.empty.action",
                            table: .planning
                        ),
                        action: onAdd
                    )
                }
            } else {
                VStack(spacing: SeulyLayout.spacingM) {
                    ForEach(viewModel.activeGoals) { goal in
                        GoalProgressCard(
                            goal: goal,
                            currency: viewModel.currency(for: goal),
                            hidesAmount: viewModel.isPrivacyModeEnabled,
                            onContribute: { onContribute(goal) }
                        )
                        .overlay {
                            SearchFocusBorder(
                                isVisible: viewModel.isFocused(goal.id)
                            )
                        }
                        .accessibilityHint(
                            viewModel.focusAccessibilityHint(for: goal.id)
                        )
                    }
                }
            }
        }
    }
}
