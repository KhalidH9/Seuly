import Foundation

extension FinanceModel {
    func fetchCurrencies() async throws -> [CurrencyDefinition] {
        let rows: [CurrencyRow] = try await client
            .from("currencies")
            .select("code, name, symbol, minor_unit, is_active")
            .order("code", ascending: true)
            .limit(250)
            .execute()
            .value
        guard !rows.isEmpty else {
            throw AppError.operationFailed(
                L10n.text("error.data.no_currencies", table: .errors)
            )
        }
        return rows.map {
            CurrencyDefinition(
                code: $0.code,
                name: $0.name,
                symbol: $0.symbol,
                minorUnit: $0.minorUnit,
                isActive: $0.isActive
            )
        }
    }
}
