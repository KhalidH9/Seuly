import SwiftUI

struct InsightsView: View {
    @Environment(\.seulyTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: InsightsViewModel

    init(viewModel: InsightsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            SeulyScreen {
                LazyVStack(spacing: SeulyLayout.sectionSpacing) {
                    InsightsMonthPicker(viewModel: viewModel)
                    InsightsMonthStoryCard(viewModel: viewModel)
                    InsightsCashFlowCard(viewModel: viewModel)
                    DailySpendingChart(viewModel: viewModel)
                    CategoryBreakdownCard(viewModel: viewModel)
                }
                .padding(.top, SeulyLayout.spacingS)
                .animation(
                    SeulyMotion.respectful(
                        SeulyMotion.content,
                        reduceMotion: reduceMotion
                    ),
                    value: viewModel.selectedMonth
                )
            }
            .navigationTitle(L10n.text("title", table: .insights))
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(
                theme.navigationBackground,
                for: .navigationBar
            )
        }
    }
}
