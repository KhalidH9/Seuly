import Foundation

struct FinanceWorkspace: Equatable, Sendable {
    var profile: FinanceProfile?
    var currencies: [CurrencyDefinition]
    var accounts: [FinancialAccount]
    var categories: [FinanceCategory]
    var transactions: [FinancialTransaction]
    var budgets: [BudgetPeriod]
    var goals: [SavingsGoal]
    var recurringRules: [RecurringRule]

    static let empty = FinanceWorkspace(
        profile: nil,
        currencies: [],
        accounts: [],
        categories: [],
        transactions: [],
        budgets: [],
        goals: [],
        recurringRules: []
    )

    var currency: CurrencyDefinition? {
        guard let code = profile?.currencyCode else { return nil }
        return currency(for: code)
    }

    func currency(for code: String) -> CurrencyDefinition? {
        currencies.first { $0.code == code }
    }
}
