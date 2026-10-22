import SwiftUI

struct PlanningRecurringContentView: View {
    let viewModel: PlanningViewModel
    let onAdd: () -> Void

    var body: some View {
        Group {
            if viewModel.activeRecurring.isEmpty {
                SeulyCard {
                    EmptyStateView(
                        systemImage: "repeat.circle",
                        title: L10n.text(
                            "recurring.empty.title",
                            table: .planning
                        ),
                        message: L10n.text(
                            "recurring.empty.message",
                            table: .planning
                        ),
                        actionTitle: L10n.text(
                            "recurring.empty.action",
                            table: .planning
                        ),
                        action: onAdd
                    )
                }
            } else {
                SeulyCard {
                    SeulyRowStack(data: viewModel.activeRecurring) { rule in
                        RecurringPlanRow(
                            rule: rule,
                            amountMinor: viewModel.signedAmount(for: rule),
                            currency: viewModel.currency,
                            hidesAmount: viewModel.isPrivacyModeEnabled
                        )
                        .overlay {
                            SearchFocusBorder(
                                isVisible: viewModel.isFocused(rule.id)
                            )
                        }
                        .accessibilityHint(
                            viewModel.focusAccessibilityHint(for: rule.id)
                        )
                    }
                }
            }
        }
    }
}
