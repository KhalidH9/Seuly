import Foundation

extension FinanceWorkspace {
    var activeAccounts: [FinancialAccount] {
        accounts.filter { $0.archivedAt == nil }
    }

    func account(id: UUID?) -> FinancialAccount? {
        accounts.first { $0.id == id }
    }

    func category(id: UUID?) -> FinanceCategory? {
        categories.first { $0.id == id }
    }

    func activeCategories(for kind: TransactionKind) -> [FinanceCategory] {
        let expected: CategoryKind = kind == .income ? .income : .expense
        return categories.filter {
            $0.kind == expected && $0.archivedAt == nil
        }
    }

    func activeAccounts(excluding id: UUID?) -> [FinancialAccount] {
        activeAccounts.filter { $0.id != id }
    }
}
