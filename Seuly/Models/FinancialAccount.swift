import Foundation

struct FinancialAccount: Identifiable, Equatable, Sendable {
    let id: UUID
    let userID: UUID
    var name: String
    var kind: AccountKind
    var currencyCode: String
    var openingBalanceMinor: Int64
    var balanceMinor: Int64
    var institutionName: String?
    var iconKey: String
    var colorRole: ColorRole
    var includeInNetWorth: Bool
    var sortOrder: Int
    var archivedAt: Date?
}
