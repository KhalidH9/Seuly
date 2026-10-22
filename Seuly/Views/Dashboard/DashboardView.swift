import SwiftUI

/// Home. The greeting is the navigation title so it collapses on scroll, and
/// the two persistent actions -- add and account -- stay in the bar instead of
/// scrolling away with the content.
struct DashboardView: View {
    @Environment(\.seulyTheme) private var theme
    @State private var viewModel: DashboardViewModel
    let onShowActivity: () -> Void
    let onPresent: (AppSheetRoute) -> Void

    init(
        viewModel: DashboardViewModel,
        onShowActivity: @escaping () -> Void,
        onPresent: @escaping (AppSheetRoute) -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onShowActivity = onShowActivity
        self.onPresent = onPresent
    }

    var body: some View {
        NavigationStack {
            SeulyScreen {
                LazyVStack(spacing: SeulyLayout.sectionSpacing) {
                    if let error = viewModel.errorMessage {
                        ErrorBanner(message: error) {
                            Task { await viewModel.refresh() }
                        }
                    }
                    DashboardBalanceHeroCard(viewModel: viewModel)
                    DashboardStatusGrid(viewModel: viewModel)
                    DashboardBudgetSection(
                        viewModel: viewModel,
                        onPlan: { onPresent(.budget) }
                    )
                    DashboardUpcomingSection(
                        viewModel: viewModel,
                        onAdd: { onPresent(.recurring) }
                    )
                    DashboardRecentSection(
                        viewModel: viewModel,
                        onShowAll: onShowActivity,
                        onAdd: { onPresent(.transaction(.expense, nil)) }
                    )
                    DashboardGoalSection(
                        viewModel: viewModel,
                        onContribute: { onPresent(.goalContribution($0)) }
                    )
                    DashboardAccountsSection(
                        viewModel: viewModel,
                        onAdd: { onPresent(.account(nil)) }
                    )
                }
                .padding(.top, SeulyLayout.spacingXS)
            }
            .refreshable { await viewModel.refresh() }
            .navigationTitle(greeting)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    DashboardQuickAddMenu(onPresent: onPresent)
                    DashboardProfileButton(
                        initials: initials,
                        action: { onPresent(.settings) }
                    )
                }
            }
            .toolbarBackground(
                theme.navigationBackground,
                for: .navigationBar
            )
        }
    }

    private var greeting: String {
        L10n.format(
            "greeting.named",
            table: .dashboard,
            viewModel.greeting,
            viewModel.firstName
        )
    }

    private var initials: String {
        String(viewModel.firstName.prefix(1)).uppercased()
    }
}
