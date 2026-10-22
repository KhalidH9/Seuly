import Foundation

extension FinanceModel {
    func fetchTransactions(
        userID: UUID
    ) async throws -> [FinancialTransaction] {
        let pageSize = 500
        var rows: [TransactionRecord] = []
        var cursor: TransactionCursor?
        let earliestDate = DatabaseDate.string(
            from: FinanceHistoryPolicy.earliestVisibleDate()
        )
        while true {
            try Task.checkCancellation()
            let page = try await fetchTransactionPage(
                userID: userID,
                cursor: cursor,
                earliestDate: earliestDate,
                limit: pageSize
            )
            try Task.checkCancellation()
            rows.append(contentsOf: page)
            guard page.count == pageSize, let last = page.last else { break }
            cursor = TransactionCursor(
                createdAt: last.createdAt,
                id: last.id
            )
        }
        return try rows.map(mapTransaction).sorted {
            if $0.effectiveDate != $1.effectiveDate {
                return $0.effectiveDate > $1.effectiveDate
            }
            if $0.createdAt != $1.createdAt {
                return $0.createdAt > $1.createdAt
            }
            return $0.id.uuidString > $1.id.uuidString
        }
    }

    func fetchTransactionPage(
        userID: UUID,
        cursor: TransactionCursor?,
        earliestDate: String,
        limit: Int
    ) async throws -> [TransactionRecord] {
        var query = client
            .from("financial_transactions")
            .select("*, transaction_legs(*)")
            .eq("user_id", value: userID)
            .neq("status", value: TransactionStatus.void.rawValue)
            .gte("effective_on", value: earliestDate)
        if let cursor {
            query = query.or(
                "created_at.lt.\(cursor.createdAt),"
                    + "and(created_at.eq.\(cursor.createdAt),"
                    + "id.lt.\(cursor.id.uuidString))"
            )
        }
        return try await query
            .order("created_at", ascending: false)
            .order("id", ascending: false)
            .limit(limit)
            .execute()
            .value
    }
}
