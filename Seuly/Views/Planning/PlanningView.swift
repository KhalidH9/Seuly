import SwiftUI

/// Planning holds three related but separate things. The segmented control
/// keeps them peers, and the add button in the bar always creates whichever
/// one is on screen.
struct PlanningView: View {
    @Environment(\.seulyTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: PlanningViewModel
    let onPresent: (AppSheetRoute) -> Void

    init(
        viewModel: PlanningViewModel,
        onPresent: @escaping (AppSheetRoute) -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onPresent = onPresent
    }

    var body: some View {
        NavigationStack {
            SeulyScreen {
                LazyVStack(spacing: SeulyLayout.sectionSpacing) {
                    PlanningSectionPicker(viewModel: viewModel)
                    if let error = viewModel.errorMessage {
                        ErrorBanner(message: error) {
                            Task { await viewModel.refresh() }
                        }
                    }
                    selectedContent
                        .seulyTransition(reduceMotion)
                    WeeklyResetCard(viewModel: viewModel)
                }
                .padding(.top, SeulyLayout.spacingS)
                .animation(
                    SeulyMotion.respectful(
                        SeulyMotion.content,
                        reduceMotion: reduceMotion
                    ),
                    value: viewModel.selectedSection
                )
            }
            .refreshable { await viewModel.refresh() }
            .navigationTitle(L10n.text("title", table: .planning))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        onPresent(routeForCurrentSection)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel(
                        L10n.format(
                            "add.accessibility",
                            table: .planning,
                            viewModel.selectedSection.displayName
                        )
                    )
                }
            }
            .toolbarBackground(
                theme.navigationBackground,
                for: .navigationBar
            )
        }
    }

    @ViewBuilder
    private var selectedContent: some View {
        switch viewModel.selectedSection {
        case .budgets:
            PlanningBudgetContentView(
                viewModel: viewModel,
                onAdd: { onPresent(.budget) }
            )
        case .goals:
            PlanningGoalsContentView(
                viewModel: viewModel,
                onAdd: { onPresent(.goal) },
                onContribute: { onPresent(.goalContribution($0)) }
            )
        case .recurring:
            PlanningRecurringContentView(
                viewModel: viewModel,
                onAdd: { onPresent(.recurring) }
            )
        }
    }

    private var routeForCurrentSection: AppSheetRoute {
        switch viewModel.selectedSection {
        case .budgets: .budget
        case .goals: .goal
        case .recurring: .recurring
        }
    }
}
