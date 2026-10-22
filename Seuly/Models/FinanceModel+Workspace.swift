import Foundation

extension FinanceModel {
    func fetchWorkspace(userID: UUID) async throws -> FinanceWorkspace {
        async let profile = fetchProfile(userID: userID)
        async let currencies = fetchCurrencies()
        async let accounts = fetchAccounts(userID: userID)
        async let categories = fetchCategories(userID: userID)
        async let transactions = fetchTransactions(userID: userID)
        async let budgets = fetchBudgets(userID: userID)
        async let goals = fetchGoals(userID: userID)
        async let rules = fetchRecurringRules(userID: userID)

        let result = try await (
            profile,
            currencies,
            accounts,
            categories,
            transactions,
            budgets,
            goals,
            rules
        )
        return FinanceWorkspace(
            profile: result.0,
            currencies: result.1,
            accounts: result.2,
            categories: result.3,
            transactions: result.4,
            budgets: result.5,
            goals: result.6,
            recurringRules: result.7
        )
    }
}
