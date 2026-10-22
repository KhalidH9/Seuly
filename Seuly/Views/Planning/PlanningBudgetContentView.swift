import SwiftUI

struct PlanningBudgetContentView: View {
    let viewModel: PlanningViewModel
    let onAdd: () -> Void

    var body: some View {
        Group {
            if let overview = viewModel.budgetOverview {
                VStack(spacing: SeulyLayout.spacingM) {
                    PlanningBudgetSummaryCard(
                        overview: overview,
                        currency: viewModel.currency,
                        hidesAmount: viewModel.isPrivacyModeEnabled
                    )
                    .overlay {
                        SearchFocusBorder(
                            isVisible: viewModel.isCurrentBudgetFocused
                        )
                    }
                    .accessibilityHint(
                        viewModel.currentBudgetFocusAccessibilityHint
                    )
                    SeulyCard {
                        SeulyRowStack(
                            data: overview.progress,
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
            } else {
                SeulyCard {
                    EmptyStateView(
                        systemImage: "gauge.with.dots.needle.50percent",
                        title: L10n.text("budget.empty.title", table: .planning),
                        message: L10n.text(
                            "budget.empty.message",
                            table: .planning
                        ),
                        actionTitle: L10n.text(
                            "budget.empty.action",
                            table: .planning
                        ),
                        action: onAdd
                    )
                }
            }
        }
    }
}
