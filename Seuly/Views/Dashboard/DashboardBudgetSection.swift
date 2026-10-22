import SwiftUI

/// The three budgets closest to their limit, with the month's pace as the
/// subtitle so the section says whether the numbers are a problem.
struct DashboardBudgetSection: View {
    let viewModel: DashboardViewModel
    let onPlan: () -> Void

    var body: some View {
        if !progress.isEmpty {
            VStack(spacing: SeulyLayout.spacingM) {
                SeulySectionHeader(
                    title: L10n.text("budget.title", table: .dashboard),
                    subtitle: viewModel.budgetPaceSubtitle,
                    actionTitle: L10n.text("action.manage", table: .dashboard),
                    action: onPlan
                )
                SeulyCard {
                    SeulyRowStack(
                        data: progress,
                        spacing: SeulyLayout.spacingM
                    ) { item in
                        BudgetProgressRow(
                            progress: item,
                            currency: viewModel.currency,
                            hidesAmount: viewModel.isPrivacyModeEnabled
                        )
                    }
                }
            }
        }
    }

    private var progress: [BudgetProgress] {
        Array(viewModel.analytics.budgetProgress.prefix(3))
    }
}
