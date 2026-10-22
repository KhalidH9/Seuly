import Foundation

enum FinanceMutationRefresh: Sendable {
    case workspace
    case accounts
    case budgets
    case goals
    case recurringRules
    case transaction(UUID)
    case removedTransaction(UUID)
}
