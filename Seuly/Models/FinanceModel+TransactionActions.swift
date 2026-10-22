import Foundation

extension FinanceModel {
    func saveTransaction(_ draft: TransactionDraft) async -> Bool {
        await performMutation(refreshing: .transaction(draft.id)) {
            try await client.rpc(
                "save_financial_transaction",
                params: SaveTransactionPayload(
                    transactionID: draft.id,
                    kind: draft.kind.rawValue,
                    effectiveOn: DatabaseDate.string(
                        from: draft.effectiveDate
                    ),
                    merchant: draft.merchant,
                    memo: draft.note,
                    amountMinor: draft.amountMinor,
                    sourceAccountID: draft.sourceAccountID,
                    destinationAccountID: draft.destinationAccountID,
                    categoryID: draft.categoryID,
                    localDate: draft.localDate.databaseValue
                )
            ).execute()
        }
    }

    func voidTransaction(id: UUID) async -> Bool {
        await performMutation(refreshing: .removedTransaction(id)) {
            try await client.rpc(
                "void_financial_transaction",
                params: VoidTransactionPayload(transactionID: id)
            ).execute()
        }
    }
}
