import Foundation

extension FinanceModel {
    func fetchKeysetPages<Row>(
        pageSize: Int = 500,
        id: (Row) -> UUID,
        page: (UUID?, Int) async throws -> [Row]
    ) async throws -> [Row] {
        var values: [Row] = []
        var cursor: UUID?
        while true {
            try Task.checkCancellation()
            let next = try await page(cursor, pageSize)
            try Task.checkCancellation()
            values.append(contentsOf: next)
            guard next.count == pageSize, let last = next.last else {
                return values
            }
            cursor = id(last)
        }
    }
}
