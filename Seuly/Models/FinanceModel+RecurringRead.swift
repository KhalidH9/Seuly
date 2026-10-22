import Foundation

extension FinanceModel {
    func fetchRecurringRules(
        userID: UUID
    ) async throws -> [RecurringRule] {
        let rows: [RecurringRow] = try await fetchKeysetPages(
            id: \.id
        ) { cursor, limit in
            var query = client.from("recurring_rules")
                .select("*, recurring_rule_legs(*)")
                .eq("user_id", value: userID)
                .eq("status", value: RecurringStatus.active.rawValue)
            if let cursor {
                query = query.gt("id", value: cursor.uuidString)
            }
            return try await query.order("id").limit(limit).execute().value
        }
        return try rows.map { row in
            guard
                let kind = TransactionKind(rawValue: row.transactionKind),
                let cadence = RecurringCadence(rawValue: row.cadence),
                let status = RecurringStatus(rawValue: row.status)
            else {
                throw SupabaseMappingError.unsupportedValue(
                    field: "recurring_rules.kind/cadence/status",
                    value: [
                        row.transactionKind,
                        row.cadence,
                        row.status
                    ].joined(separator: "/")
                )
            }
            return RecurringRule(
                id: row.id,
                userID: row.userID,
                kind: kind,
                merchant: row.merchant ?? "",
                note: row.memo ?? "",
                cadence: cadence,
                nextRunOn: try LocalDate(databaseValue: row.nextRunOn),
                status: status,
                legs: row.recurringRuleLegs.map {
                    RecurringLeg(
                        id: $0.id,
                        accountID: $0.accountID,
                        categoryID: $0.categoryID,
                        amountMinor: $0.amountMinor
                    )
                }
            )
        }.sorted { $0.nextRunDate < $1.nextRunDate }
    }
}
