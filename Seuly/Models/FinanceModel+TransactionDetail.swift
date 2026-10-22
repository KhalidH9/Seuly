import Foundation

extension FinanceModel {
    func fetchTransaction(
        id: UUID,
        userID: UUID
    ) async throws -> FinancialTransaction {
        let row: TransactionRecord = try await client
            .from("financial_transactions")
            .select("*, transaction_legs(*)")
            .eq("user_id", value: userID)
            .eq("id", value: id)
            .single()
            .execute()
            .value
        return try mapTransaction(row)
    }
}
