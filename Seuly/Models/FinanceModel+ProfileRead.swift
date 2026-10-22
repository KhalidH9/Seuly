import Foundation

extension FinanceModel {
    func fetchProfile(userID: UUID) async throws -> FinanceProfile? {
        let rows: [ProfileRow] = try await client
            .from("profile_overview")
            .select()
            .eq("id", value: userID)
            .limit(1)
            .execute()
            .value
        return try rows.first.map {
            FinanceProfile(
                id: $0.id,
                displayName: $0.displayName,
                currencyCode: $0.currencyCode,
                onboardingCompleted: $0.onboardingCompleted,
                createdAt: try DatabaseDate.timestamp(from: $0.createdAt)
            )
        }
    }
}
