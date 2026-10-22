import Foundation

extension TransactionFormViewModel {
    func selectKind(_ newKind: TransactionKind) {
        guard existingTransaction == nil else { return }
        entry.selectKind(newKind)
        errorMessage = nil
    }

    func save() async -> Bool {
        guard
            canSave,
            let amount = entry.amountMinor
        else {
            errorMessage = L10n.text(
                "validation.transaction.incomplete",
                table: .errors
            )
            return false
        }
        isSaving = true
        defer { isSaving = false }
        let request = beginPersistenceRequest()
        let succeeded = await model.saveTransaction(
            TransactionDraft(
                id: request.id,
                kind: entry.kind,
                amountMinor: amount,
                sourceAccountID: entry.sourceAccountID,
                destinationAccountID: entry.kind == .transfer
                    ? entry.destinationAccountID
                    : nil,
                categoryID: entry.kind == .transfer
                    ? nil
                    : entry.categoryID,
                merchant: entry.merchant,
                note: entry.note,
                effectiveDate: effectiveDate,
                localDate: request.localDate
            )
        )
        errorMessage = succeeded ? nil : model.errorMessage
        return succeeded
    }
}
