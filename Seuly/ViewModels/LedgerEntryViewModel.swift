import Foundation
import Observation

@MainActor
@Observable
final class LedgerEntryViewModel {
    private let model: FinanceModel
    var kind: TransactionKind
    var amountText = ""
    var sourceAccountID: UUID?
    var destinationAccountID: UUID?
    var categoryID: UUID?
    var merchant = ""
    var note = ""

    init(model: FinanceModel, kind: TransactionKind) {
        self.model = model
        self.kind = kind
        sourceAccountID = activeAccounts.first?.id
        applySelections(for: kind)
    }

    var currency: CurrencyDefinition? { model.workspace.currency }
    var amountMinor: Int64? {
        currency?.minorUnits(from: amountText)
    }
    var activeAccounts: [FinancialAccount] {
        model.workspace.activeAccounts
    }
    var availableDestinations: [FinancialAccount] {
        model.workspace.activeAccounts(excluding: sourceAccountID)
    }
    var availableCategories: [FinanceCategory] {
        model.workspace.activeCategories(for: kind)
    }
    var hasValidLedger: Bool {
        guard let amountMinor, amountMinor > 0 else { return false }
        return LedgerSelectionRules.isValid(
            kind: kind,
            sourceID: sourceAccountID,
            destinationID: destinationAccountID,
            categoryID: categoryID
        )
    }

    func selectKind(_ newKind: TransactionKind) {
        kind = newKind
        applySelections(for: newKind)
    }

    func sourceChanged() {
        guard sourceAccountID == destinationAccountID else { return }
        destinationAccountID = LedgerSelectionRules.destinationID(
            for: kind,
            sourceID: sourceAccountID,
            workspace: model.workspace
        )
    }

    func populate(from transaction: FinancialTransaction) {
        kind = transaction.kind
        amountText = MoneyFormatter.editableString(
            minorUnits: transaction.amountMinor,
            currency: currency
        )
        sourceAccountID = transaction.kind == .income
            ? transaction.destinationAccountID
            : transaction.sourceAccountID
        destinationAccountID = transaction.kind == .transfer
            ? transaction.destinationAccountID
            : nil
        categoryID = transaction.categoryID
        merchant = transaction.merchant
        note = transaction.note
    }

    private func applySelections(for kind: TransactionKind) {
        categoryID = LedgerSelectionRules.categoryID(
            for: kind,
            workspace: model.workspace
        )
        destinationAccountID = LedgerSelectionRules.destinationID(
            for: kind,
            sourceID: sourceAccountID,
            workspace: model.workspace
        )
    }
}
