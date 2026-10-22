import Foundation

enum AccountKind: String, CaseIterable, Codable, Identifiable, Sendable {
    case cash
    case checking
    case savings
    case investment
    case creditCard = "credit_card"
    case loan
    case otherAsset = "other_asset"
    case otherLiability = "other_liability"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .cash: localized("cash")
        case .checking: localized("checking")
        case .savings: localized("savings")
        case .investment: localized("investment")
        case .creditCard: localized("credit_card")
        case .loan: localized("loan")
        case .otherAsset: localized("other_asset")
        case .otherLiability: localized("other_liability")
        }
    }

    var isLiquid: Bool { self == .cash || self == .checking }

    var isLiability: Bool {
        self == .creditCard || self == .loan || self == .otherLiability
    }

    private func localized(_ value: String) -> String {
        L10n.text("account.kind.\(value)", table: .data)
    }
}
