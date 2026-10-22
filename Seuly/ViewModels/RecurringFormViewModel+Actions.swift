import Foundation

extension RecurringFormViewModel {
    func save() async -> Bool {
        guard
            canSave,
            let sourceAccountID = entry.sourceAccountID,
            let amount = entry.amountMinor
        else {
            errorMessage = L10n.text(
                "validation.recurring.incomplete",
                table: .errors
            )
            return false
        }
        isSaving = true
        defer { isSaving = false }
        let request = beginPersistenceRequest()
        let succeeded = await model.createRecurringRule(
            RecurringRuleDraft(
                id: request.id,
                kind: entry.kind,
                amountMinor: amount,
                sourceAccountID: sourceAccountID,
                destinationAccountID: entry.kind == .transfer
                    ? entry.destinationAccountID
                    : nil,
                categoryID: entry.kind == .transfer
                    ? nil
                    : entry.categoryID,
                merchant: entry.merchant,
                note: entry.note,
                cadence: cadence,
                nextRunDate: nextRunDate,
                localDate: request.localDate
            )
        )
        errorMessage = succeeded ? nil : model.errorMessage
        return succeeded
    }
}
