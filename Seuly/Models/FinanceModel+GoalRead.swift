import Foundation

extension FinanceModel {
    func fetchGoals(userID: UUID) async throws -> [SavingsGoal] {
        let rows: [GoalOverviewRow] = try await fetchKeysetPages(
            id: \.id
        ) { cursor, limit in
            var query = client.from("goal_overview").select()
                .eq("user_id", value: userID)
                .eq("status", value: GoalStatus.active.rawValue)
            if let cursor {
                query = query.gt("id", value: cursor.uuidString)
            }
            return try await query.order("id").limit(limit).execute().value
        }
        return try rows.map(mapGoal)
    }

    func mapGoal(_ row: GoalOverviewRow) throws -> SavingsGoal {
        guard
            let kind = GoalKind(rawValue: row.kind),
            let status = GoalStatus(rawValue: row.status),
            let colorRole = row.colorRole.flatMap({
                ColorRole(rawValue: $0)
            })
        else {
            throw SupabaseMappingError.unsupportedValue(
                field: "goals.kind/status/color_role",
                value: "\(row.kind)/\(row.status)/\(row.colorRole ?? "nil")"
            )
        }
        return SavingsGoal(
            id: row.id,
            userID: row.userID,
            name: row.name,
            kind: kind,
            currencyCode: row.currencyCode,
            targetMinor: row.targetMinor,
            targetOn: try row.targetOn.map {
                try LocalDate(databaseValue: $0)
            },
            status: status,
            iconKey: row.iconKey ?? "target",
            colorRole: colorRole,
            progressMinor: max(0, row.progressMinor)
        )
    }
}
