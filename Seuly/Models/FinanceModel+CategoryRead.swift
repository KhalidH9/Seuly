import Foundation

extension FinanceModel {
    func fetchCategories(userID: UUID) async throws -> [FinanceCategory] {
        let rows: [CategoryRow] = try await fetchKeysetPages(
            id: \.id
        ) { cursor, limit in
            var query = client.from("categories")
                .select().eq("user_id", value: userID)
            if let cursor {
                query = query.gt("id", value: cursor.uuidString)
            }
            return try await query.order("id").limit(limit).execute().value
        }
        return try rows.map { row in
            guard
                let kind = CategoryKind(rawValue: row.kind),
                let colorRole = row.colorRole.flatMap({
                    ColorRole(rawValue: $0)
                })
            else {
                throw SupabaseMappingError.unsupportedValue(
                    field: "categories.kind/color_role",
                    value: "\(row.kind)/\(row.colorRole ?? "nil")"
                )
            }
            return FinanceCategory(
                id: row.id,
                userID: row.userID,
                parentID: row.parentID,
                kind: kind,
                name: row.name,
                iconKey: row.iconKey ?? "square.grid.2x2.fill",
                colorRole: colorRole,
                sortOrder: row.sortOrder,
                archivedAt: try row.archivedAt.map(
                    DatabaseDate.timestamp
                )
            )
        }.sorted { $0.sortOrder < $1.sortOrder }
    }
}
