import SwiftUI

/// The one loud surface in the app: what everything adds up to, what came in,
/// what went out, and how that compares. Privacy toggles from here because
/// this is the number people most often want to cover.
struct DashboardBalanceHeroCard: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: DashboardViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingXL) {
            header
            Divider().overlay(theme.onBrandFill.opacity(0.22))
            metrics
            footnote
        }
        .padding(SeulyLayout.spacingXL)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background { DashboardHeroBackgroundView() }
        .clipShape(
            RoundedRectangle(
                cornerRadius: SeulyLayout.heroRadius,
                style: .continuous
            )
        )
        .shadow(color: theme.heroShadow, radius: 18, y: 10)
        .accessibilityElement(children: .contain)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: SeulyLayout.spacingXS) {
                Text(L10n.text("balance.net_worth", table: .dashboard))
                    .seulyEyebrow()
                    .foregroundStyle(theme.onBrandFill.opacity(0.85))
                PrivacySensitiveAmount(
                    minorUnits: viewModel.analytics.netWorthMinor,
                    currency: viewModel.currency,
                    isHidden: viewModel.isPrivacyModeEnabled,
                    style: SeulyFont.moneyHero,
                    color: theme.onBrandFill,
                    symbolScale: .largeTitle
                )
                .minimumScaleFactor(0.65)
                .lineLimit(1)
            }
            Spacer(minLength: SeulyLayout.spacingS)
            DashboardPrivacyToggle(
                isEnabled: viewModel.isPrivacyModeEnabled,
                toggle: viewModel.togglePrivacyMode
            )
        }
    }

    private var metrics: some View {
        HStack(alignment: .top, spacing: SeulyLayout.spacingL) {
            DashboardHeroMetricView(
                title: L10n.text("balance.income", table: .dashboard),
                amountMinor: viewModel.analytics.monthIncomeMinor,
                systemImage: "arrow.down.left",
                currency: viewModel.currency,
                hidesAmount: viewModel.isPrivacyModeEnabled
            )
            DashboardHeroMetricView(
                title: L10n.text("balance.spent", table: .dashboard),
                amountMinor: viewModel.analytics.monthExpenseMinor,
                systemImage: "arrow.up.right",
                currency: viewModel.currency,
                hidesAmount: viewModel.isPrivacyModeEnabled
            )
            if let change = viewModel.analytics.expenseChange {
                DashboardHeroChangeView(change: change)
            }
        }
    }

    private var footnote: some View {
        Text(
            L10n.format(
                "balance.footnote",
                table: .dashboard,
                viewModel.monthTitle,
                viewModel.analytics.moneyPulse.title
            )
        )
        .font(SeulyFont.caption)
        .foregroundStyle(theme.onBrandFill.opacity(0.8))
    }
}
