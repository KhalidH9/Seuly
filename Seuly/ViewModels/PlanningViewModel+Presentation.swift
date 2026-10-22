import Foundation

extension PlanningViewModel {
    func signedAmount(for rule: RecurringRule) -> Int64 {
        rule.signedAmountMinor
    }

    func currency(for goal: SavingsGoal) -> CurrencyDefinition? {
        workspace.currency(for: goal.currencyCode)
    }
}
