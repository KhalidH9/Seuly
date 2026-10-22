import Foundation

extension FinanceModel {
    func fetchBudgets(userID: UUID) async throws -> [BudgetPeriod] {
        let rows: [BudgetRow] = try await client
            .from("budgets")
            .select("*, budget_lines(*)")
            .eq("user_id", value: userID)
            .is("archived_at", value: nil)
            .order("starts_on", ascending: false)
            .limit(24)
            .execute()
            .value
        return try rows.map { row in
            BudgetPeriod(
                id: row.id,
                userID: row.userID,
                name: row.name,
                currencyCode: row.currencyCode,
                periodStart: try LocalDate(databaseValue: row.startsOn),
                periodEnd: try LocalDate(databaseValue: row.endsOn),
                lines: row.budgetLines.map {
                    BudgetLine(
                        id: $0.id,
                        budgetID: $0.budgetID,
                        categoryID: $0.categoryID,
                        limitMinor: $0.limitMinor
                    )
                }
            )
        }
    }
}
