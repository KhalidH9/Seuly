import SwiftUI

/// Where the month went. A share bar for the shape of it, then ranked rows
/// for the numbers, so nothing depends on matching a colour to a legend.
struct CategoryBreakdownCard: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: InsightsViewModel

    var body: some View {
        SeulyCard {
            if shares.isEmpty {
                EmptyStateView(
                    systemImage: "chart.bar.xaxis",
                    title: L10n.text("category.empty.title", table: .insights),
                    message: L10n.text(
                        "category.empty.message",
                        table: .insights
                    )
                )
            } else {
                VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
                    header
                    CategoryShareBar(shares: shares)
                    VStack(spacing: SeulyLayout.spacingXS) {
                        ForEach(shares) { share in
                            CategoryRankRow(
                                share: share,
                                currency: viewModel.currency,
                                hidesAmount: viewModel.isPrivacyModeEnabled
                            )
                        }
                    }
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(L10n.text("category.title", table: .insights))
                    .font(SeulyFont.sectionTitle)
                    .foregroundStyle(theme.textPrimary)
                Text(
                    L10n.format(
                        "category.count",
                        table: .insights,
                        AppFormatters.integer(viewModel.categoryCount)
                    )
                )
                .font(SeulyFont.footnote)
                .foregroundStyle(theme.textSecondary)
            }
            Spacer(minLength: SeulyLayout.spacingS)
            PrivacySensitiveAmount(
                minorUnits: viewModel.analytics.monthExpenseMinor,
                currency: viewModel.currency,
                isHidden: viewModel.isPrivacyModeEnabled,
                style: SeulyFont.moneySection,
                compact: true,
                symbolScale: .title3
            )
            .lineLimit(1)
        }
    }

    private var shares: [InsightsViewModel.CategoryShare] {
        viewModel.categoryShares
    }
}
