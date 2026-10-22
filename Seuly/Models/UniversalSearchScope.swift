import Foundation

enum UniversalSearchScope: String, CaseIterable, Identifiable, Sendable {
    case all
    case transaction
    case account
    case budget
    case category
    case goal
    case recurring

    var id: String { rawValue }
    var displayName: String {
        guard self != .all else {
            return L10n.text("search.scope.all", table: .shared)
        }
        return kind?.displayName ?? ""
    }

    var kind: UniversalSearchKind? {
        UniversalSearchKind(rawValue: rawValue)
    }

    func includes(_ resultKind: UniversalSearchKind) -> Bool {
        kind == nil || kind == resultKind
    }
}
