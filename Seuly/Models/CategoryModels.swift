import Foundation

enum CategoryKind: String, CaseIterable, Codable, Sendable {
    case income
    case expense
}

struct FinanceCategory: Identifiable, Equatable, Sendable {
    let id: UUID
    let userID: UUID
    var parentID: UUID?
    var kind: CategoryKind
    var name: String
    var iconKey: String
    var colorRole: ColorRole
    var sortOrder: Int
    var archivedAt: Date?

    var localizedName: String {
        L10n.databaseValue(name, prefix: "category")
    }
}
