import Foundation

enum UniversalSearchKind: String, CaseIterable, Identifiable, Sendable {
    case transaction
    case account
    case budget
    case category
    case goal
    case recurring

    var id: String { rawValue }
    var displayName: String {
        L10n.text("search.kind.\(rawValue)", table: .shared)
    }

    var systemImage: String {
        switch self {
        case .transaction: "arrow.left.arrow.right.circle.fill"
        case .account: "building.columns.fill"
        case .budget: "chart.pie.fill"
        case .category: "square.grid.2x2.fill"
        case .goal: "target"
        case .recurring: "arrow.triangle.2.circlepath.circle.fill"
        }
    }
}
