import SwiftUI

/// The four figures that answer "where do I stand" without leaving profile.
struct ProfileSnapshotSection: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: SettingsViewModel

    var body: some View {
        SeulyCard {
            LazyVGrid(columns: columns, spacing: SeulyLayout.spacingS) {
                ProfileStatTile(
                    title: L10n.text("profile.stat.net_worth", table: .settings),
                    systemImage: "chart.pie.fill",
                    tint: theme.brandPrimary
                ) {
                    PrivacySensitiveAmount(
                        minorUnits: viewModel.netWorthMinor,
                        currency: viewModel.currency,
                        isHidden: viewModel.isPrivacyModeEnabled,
                        style: SeulyFont.moneyMetric,
                        compact: true,
                        symbolScale: .headline
                    )
                }
                ProfileStatTile(
                    title: L10n.text("profile.stat.accounts", table: .settings),
                    systemImage: "building.columns.fill",
                    tint: theme.savings
                ) {
                    countText(viewModel.accountCount)
                }
                ProfileStatTile(
                    title: L10n.text("profile.stat.activity", table: .settings),
                    systemImage: "arrow.left.arrow.right",
                    tint: theme.transfer
                ) {
                    countText(viewModel.monthTransactionCount)
                }
                ProfileStatTile(
                    title: L10n.text("profile.stat.goals", table: .settings),
                    systemImage: "target",
                    tint: theme.investment
                ) {
                    countText(viewModel.activeGoalCount)
                }
            }
        }
    }

    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: SeulyLayout.spacingS),
            GridItem(.flexible(), spacing: SeulyLayout.spacingS)
        ]
    }

    private func countText(_ value: Int) -> some View {
        Text(AppFormatters.integer(value))
            .font(SeulyFont.moneyMetric)
            .foregroundStyle(theme.textPrimary)
    }
}
