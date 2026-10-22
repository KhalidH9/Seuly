import SwiftUI

/// Total budget for the month with a single status verdict, so the detail
/// rows below it are read as explanation rather than as the summary.
struct PlanningBudgetSummaryCard: View {
    @Environment(\.seulyTheme) private var theme
    let overview: BudgetOverview
    let currency: CurrencyDefinition?
    let hidesAmount: Bool

    var body: some View {
        SeulyCard {
            VStack(alignment: .leading, spacing: SeulyLayout.spacingM) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.text("budget.total", table: .planning))
                            .font(SeulyFont.footnoteEmphasized)
                            .foregroundStyle(theme.textSecondary)
                        PrivacySensitiveAmount(
                            minorUnits: overview.limitMinor,
                            currency: currency,
                            isHidden: hidesAmount,
                            style: SeulyFont.moneyTitle,
                            symbolScale: .title2
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    }
                    Spacer(minLength: SeulyLayout.spacingS)
                    StatusPill(title: statusTitle, kind: statusKind)
                }
                SeulyProgressBar(
                    progress: overview.utilization,
                    tint: tint,
                    height: 10
                )
                Text(utilizationText)
                    .font(SeulyFont.caption)
                    .foregroundStyle(theme.textSecondary)
            }
        }
    }

    private var statusTitle: String {
        if overview.utilization < 0.8 {
            return L10n.text("budget.status.on_track", table: .planning)
        }
        if overview.utilization < 1 {
            return L10n.text("budget.status.watch", table: .planning)
        }
        return L10n.text("budget.status.over", table: .planning)
    }

    private var statusKind: StatusPill.Kind {
        if overview.utilization < 0.8 { return .success }
        if overview.utilization < 1 { return .warning }
        return .error
    }

    private var tint: Color {
        if overview.utilization < 0.8 { return theme.brandPrimary }
        if overview.utilization < 1 { return theme.warning }
        return theme.expense
    }

    private var utilizationText: String {
        let count = overview.categoryCount
        return L10n.format(
            "budget.utilization.\(ArabicPlural.suffix(for: count))",
            table: .planning,
            AppFormatters.integer(
                Int((overview.utilization * 100).rounded())
            ),
            AppFormatters.integer(count)
        )
    }
}
