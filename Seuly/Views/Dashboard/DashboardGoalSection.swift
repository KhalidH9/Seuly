import SwiftUI

struct DashboardGoalSection: View {
    let viewModel: DashboardViewModel
    let onContribute: (SavingsGoal) -> Void

    var body: some View {
        if let goal = viewModel.featuredGoal {
            VStack(spacing: SeulyLayout.spacingM) {
                SeulySectionHeader(
                    title: L10n.text("goal.title", table: .dashboard),
                    subtitle: L10n.text("goal.subtitle", table: .dashboard)
                )
                GoalProgressCard(
                    goal: goal,
                    currency: viewModel.currency(for: goal),
                    hidesAmount: viewModel.isPrivacyModeEnabled,
                    onContribute: { onContribute(goal) }
                )
            }
        }
    }
}
