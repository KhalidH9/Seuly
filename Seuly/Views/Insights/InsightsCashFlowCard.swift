import SwiftUI

struct InsightsCashFlowCard: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: InsightsViewModel

    var body: some View {
        SeulyCard {
            VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
                SeulySectionHeader(
                    title: L10n.text("cash_flow.title", table: .insights),
                    subtitle: L10n.text("cash_flow.subtitle", table: .insights)
                )
                HStack(spacing: SeulyLayout.spacingS) {
                    MetricTile(
                        title: L10n.text("cash_flow.income", table: .insights),
                        systemImage: "arrow.down.left",
                        minorUnits: viewModel.analytics.monthIncomeMinor,
                        currency: viewModel.currency,
                        hidesAmount: viewModel.isPrivacyModeEnabled,
                        tint: theme.income
                    )
                    MetricTile(
                        title: L10n.text("cash_flow.expense", table: .insights),
                        systemImage: "arrow.up.right",
                        minorUnits: viewModel.analytics.monthExpenseMinor,
                        currency: viewModel.currency,
                        hidesAmount: viewModel.isPrivacyModeEnabled,
                        tint: theme.expense
                    )
                }
                Divider().overlay(theme.divider)
                HStack {
                    Text(L10n.text("cash_flow.net", table: .insights))
                        .font(SeulyFont.bodyEmphasized)
                        .foregroundStyle(theme.textPrimary)
                    Spacer(minLength: SeulyLayout.spacingS)
                    PrivacySensitiveAmount(
                        minorUnits: viewModel.analytics.monthNetMinor,
                        currency: viewModel.currency,
                        isHidden: viewModel.isPrivacyModeEnabled,
                        style: SeulyFont.moneySection,
                        color: netColor,
                        showSign: true,
                        symbolScale: .title3
                    )
                    .lineLimit(1)
                }
                .accessibilityElement(children: .combine)
            }
        }
    }

    private var netColor: Color {
        viewModel.analytics.monthNetMinor >= 0
            ? theme.incomeText
            : theme.expenseText
    }
}
