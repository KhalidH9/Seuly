import Foundation

enum LedgerSelectionRules {
    static func categoryID(
        for kind: TransactionKind,
        workspace: FinanceWorkspace
    ) -> UUID? {
        kind == .transfer
            ? nil
            : workspace.activeCategories(for: kind).first?.id
    }

    static func destinationID(
        for kind: TransactionKind,
        sourceID: UUID?,
        workspace: FinanceWorkspace
    ) -> UUID? {
        guard kind == .transfer else { return nil }
        return workspace.activeAccounts(excluding: sourceID).first?.id
    }

    static func isValid(
        kind: TransactionKind,
        sourceID: UUID?,
        destinationID: UUID?,
        categoryID: UUID?
    ) -> Bool {
        guard sourceID != nil else { return false }
        if kind == .transfer {
            return destinationID != nil && destinationID != sourceID
        }
        return categoryID != nil
    }
}
