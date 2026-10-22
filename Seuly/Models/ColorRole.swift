import Foundation

enum ColorRole: String, CaseIterable, Codable, Sendable {
    case teal
    case savings
    case investment
    case transfer
    case income
    case debt
    case information
    case warning
    case expense
    case neutral

    var displayName: String {
        L10n.text("color.role.\(rawValue)", table: .data)
    }
}
