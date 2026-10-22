import SwiftUI

/// Five peer destinations. Every tab owns its own navigation stack so each
/// keeps an independent title, search field, and back history.
struct MainTabView: View {
    @Environment(\.seulyTheme) private var theme
    @State private var viewModel: MainTabViewModel

    init(viewModel: MainTabViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            DashboardView(
                viewModel: viewModel.dashboardViewModel,
                onShowActivity: { viewModel.selectedTab = .activity },
                onPresent: viewModel.present
            )
            .tag(MainTab.overview)
            .tabItem { MainTabLabel(tab: .overview) }

            ActivityView(
                viewModel: viewModel.activityViewModel,
                onPresent: viewModel.present
            )
            .tag(MainTab.activity)
            .tabItem { MainTabLabel(tab: .activity) }

            PlanningView(
                viewModel: viewModel.planningViewModel,
                onPresent: viewModel.present
            )
            .tag(MainTab.plan)
            .tabItem { MainTabLabel(tab: .plan) }

            InsightsView(viewModel: viewModel.insightsViewModel)
                .tag(MainTab.insights)
                .tabItem { MainTabLabel(tab: .insights) }

            UniversalSearchView(
                viewModel: viewModel.searchViewModel,
                onSelect: viewModel.openSearchResult
            )
            .tag(MainTab.search)
            .tabItem { MainTabLabel(tab: .search) }
        }
        .tint(theme.brandPrimary)
        .toolbarBackground(theme.tabBarBackground, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .sheet(
            item: $viewModel.activeSheet,
            onDismiss: viewModel.presentPendingSheet
        ) { route in
            MainTabSheetView(viewModel: viewModel, route: route)
                .environment(\.seulyTheme, theme)
        }
    }
}
