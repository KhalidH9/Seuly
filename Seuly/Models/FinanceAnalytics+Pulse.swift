import Foundation

extension FinanceAnalytics {
    var moneyPulse: MoneyPulse {
        let overspent = budgetProgress.filter { $0.fraction >= 1 }.count
        if liquidBalanceMinor <= 0
            || (monthNetMinor < 0 && safeToSpendMinor == 0) {
            return .tight(
                reason: L10n.text(
                    "money_pulse.reason.cash_attention",
                    table: .data
                )
            )
        }
        if safeToSpendMinor == 0 {
            return .tight(
                reason: L10n.text(
                    "money_pulse.reason.cash_allocated",
                    table: .data
                )
            )
        }
        if overspent > 0 {
            return .tight(
                reason: overspent == 1
                    ? L10n.text(
                        "money_pulse.reason.one_budget_over",
                        table: .data
                    )
                    : L10n.format(
                        "money_pulse.reason.budgets_over",
                        table: .data,
                        AppFormatters.integer(overspent)
                    )
            )
        }
        if budgetPace > 1.15 {
            return .watch(
                reason: L10n.text(
                    "money_pulse.reason.fast_spending",
                    table: .data
                )
            )
        }
        return .calm(
            reason: L10n.text(
                "money_pulse.reason.covered",
                table: .data
            )
        )
    }
}
