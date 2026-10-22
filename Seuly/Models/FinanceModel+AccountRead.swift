import Foundation

extension FinanceModel {
    func fetchAccounts(userID: UUID) async throws -> [FinancialAccount] {
        let rows: [AccountRow] = try await fetchKeysetPages(
            id: \.id
        ) { cursor, limit in
            var query = client.from("account_overview")
                .select().eq("user_id", value: userID)
            if let cursor {
                query = query.gt("id", value: cursor.uuidString)
            }
            return try await query.order("id").limit(limit).execute().value
        }
        return try rows.map { row in
            guard
                let kind = AccountKind(rawValue: row.kind),
                let colorRole = row.colorRole.flatMap({
                    ColorRole(rawValue: $0)
                })
            else {
                throw SupabaseMappingError.unsupportedValue(
                    field: "accounts.kind/color_role",
                    value: "\(row.kind)/\(row.colorRole ?? "nil")"
                )
            }
            return FinancialAccount(
                id: row.id,
                userID: row.userID,
                name: row.name,
                kind: kind,
                currencyCode: row.currencyCode,
                openingBalanceMinor: row.openingBalanceMinor,
                balanceMinor: row.balanceMinor,
                institutionName: row.institutionName,
                iconKey: row.iconKey ?? "building.columns.fill",
                colorRole: colorRole,
                includeInNetWorth: row.includeInNetWorth,
                sortOrder: row.sortOrder,
                archivedAt: try row.archivedAt.map(
                    DatabaseDate.timestamp
                )
            )
        }.sorted { $0.sortOrder < $1.sortOrder }
    }
}
