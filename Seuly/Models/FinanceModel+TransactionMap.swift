import Foundation

extension FinanceModel {
    func mapTransaction(
        _ row: TransactionRecord
    ) throws -> FinancialTransaction {
        guard
            let kind = TransactionKind(rawValue: row.kind),
            let status = TransactionStatus(rawValue: row.status)
        else {
            throw SupabaseMappingError.unsupportedValue(
                field: "financial_transactions.kind/status",
                value: "\(row.kind)/\(row.status)"
            )
        }
        return FinancialTransaction(
            id: row.id,
            userID: row.userID,
            kind: kind,
            status: status,
            effectiveOn: try LocalDate(databaseValue: row.effectiveOn),
            occurredAt: try row.occurredAt.map(
                DatabaseDate.timestamp
            ),
            merchant: row.merchant ?? "",
            note: row.memo ?? "",
            legs: row.transactionLegs.map {
                TransactionLeg(
                    id: $0.id,
                    transactionID: $0.transactionID,
                    accountID: $0.accountID,
                    categoryID: $0.categoryID,
                    amountMinor: $0.amountMinor
                )
            },
            createdAt: try DatabaseDate.timestamp(from: row.createdAt)
        )
    }
}
