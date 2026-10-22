import SwiftUI

struct DashboardUpcomingSection: View {
    let viewModel: DashboardViewModel
    let onAdd: () -> Void

    var body: some View {
        if !upcoming.isEmpty {
            VStack(spacing: SeulyLayout.spacingM) {
                SeulySectionHeader(
                    title: L10n.text("upcoming.title", table: .dashboard),
                    subtitle: L10n.text("upcoming.subtitle", table: .dashboard),
                    actionTitle: L10n.text("action.add", table: .dashboard),
                    action: onAdd
                )
                SeulyCard {
                    SeulyRowStack(data: upcoming) { occurrence in
                        UpcomingRuleRow(
                            occurrence: occurrence,
                            amountMinor: viewModel.signedAmount(for: occurrence),
                            currency: viewModel.currency,
                            hidesAmount: viewModel.isPrivacyModeEnabled
                        )
                    }
                }
            }
        }
    }

    private var upcoming: [RecurringOccurrence] {
        Array(viewModel.analytics.upcomingRecurringOccurrences.prefix(3))
    }
}
