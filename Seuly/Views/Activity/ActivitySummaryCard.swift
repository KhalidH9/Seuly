import SwiftUI

/// Month header for the timeline: what was spent, how that compares, and the
/// income and net figures behind it.
struct ActivitySummaryCard: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: ActivityViewModel

    var body: some View {
        SeulyCard {
            VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.text("summary.month", table: .activity))
                            .font(SeulyFont.footnoteEmphasized)
                            .foregroundStyle(theme.textSecondary)
                        PrivacySensitiveAmount(
                            minorUnits: viewModel.analytics.monthExpenseMinor,
                            currency: viewModel.currency,
                            isHidden: viewModel.isPrivacyModeEnabled,
                            style: SeulyFont.moneyHero,
                            symbolScale: .largeTitle
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    }
                    Spacer(minLength: SeulyLayout.spacingS)
                    if let change = viewModel.analytics.expenseChange {
                        TrendBadge(change: change, lowerIsBetter: true)
                    }
                }
                HStack(spacing: SeulyLayout.spacingS) {
                    MetricTile(
                        title: L10n.text("summary.income", table: .activity),
                        systemImage: "arrow.down.left",
                        minorUnits: viewModel.analytics.monthIncomeMinor,
                        currency: viewModel.currency,
                        hidesAmount: viewModel.isPrivacyModeEnabled,
                        tint: theme.income
                    )
                    MetricTile(
                        title: L10n.text("summary.net", table: .activity),
                        systemImage: "equal.circle.fill",
                        minorUnits: viewModel.analytics.monthNetMinor,
                        currency: viewModel.currency,
                        hidesAmount: viewModel.isPrivacyModeEnabled,
                        tint: netTint
                    )
                }
            }
        }
    }

    private var netTint: Color {
        viewModel.analytics.monthNetMinor >= 0 ? theme.savings : theme.expense
    }
}
