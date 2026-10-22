import Foundation

extension DashboardViewModel {
    var budgetPaceSubtitle: String {
        let pace = analytics.budgetPace
        if pace > 1.15 {
            return L10n.text("budget.pace.ahead", table: .data)
        }
        if pace > 0.9 {
            return L10n.text("budget.pace.aligned", table: .data)
        }
        return L10n.text("budget.pace.behind", table: .data)
    }

    func togglePrivacyMode() {
        setPrivacyMode(!isPrivacyModeEnabled)
    }

    func signedAmount(
        for transaction: FinancialTransaction
    ) -> Int64 {
        transaction.signedAmountMinor
    }

    func signedAmount(for occurrence: RecurringOccurrence) -> Int64 {
        occurrence.rule.signedAmountMinor
    }

    func currency(for account: FinancialAccount) -> CurrencyDefinition? {
        workspace.currency(for: account.currencyCode)
    }

    func currency(for goal: SavingsGoal) -> CurrencyDefinition? {
        workspace.currency(for: goal.currencyCode)
    }
}
