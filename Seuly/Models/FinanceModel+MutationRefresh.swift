import Foundation

extension FinanceModel {
    func refreshAfterMutation(
        _ scope: FinanceMutationRefresh,
        userID: UUID,
        generation: UInt
    ) async throws {
        switch scope {
        case .workspace:
            let value = try await fetchWorkspace(userID: userID)
            try validateRefresh(userID: userID, generation: generation)
            workspace = value
        case .accounts:
            let value = try await fetchAccounts(userID: userID)
            try validateRefresh(userID: userID, generation: generation)
            workspace.accounts = value
        case .budgets:
            let value = try await fetchBudgets(userID: userID)
            try validateRefresh(userID: userID, generation: generation)
            workspace.budgets = value
        case .goals:
            let value = try await fetchGoals(userID: userID)
            try validateRefresh(userID: userID, generation: generation)
            workspace.goals = value
        case .recurringRules:
            let value = try await fetchRecurringRules(
                userID: userID
            )
            try validateRefresh(userID: userID, generation: generation)
            workspace.recurringRules = value
        case .transaction(let id):
            async let transaction = fetchTransaction(id: id, userID: userID)
            async let accounts = fetchAccounts(userID: userID)
            let refreshed = try await (transaction, accounts)
            try validateRefresh(userID: userID, generation: generation)
            workspace.transactions.removeAll { $0.id == id }
            workspace.transactions.append(refreshed.0)
            workspace.accounts = refreshed.1
        case .removedTransaction(let id):
            let accounts = try await fetchAccounts(userID: userID)
            try validateRefresh(userID: userID, generation: generation)
            workspace.accounts = accounts
            workspace.transactions.removeAll { $0.id == id }
        }
    }

    private func validateRefresh(
        userID: UUID,
        generation: UInt
    ) throws {
        guard isCurrent(userID: userID, generation: generation) else {
            throw CancellationError()
        }
    }
}
