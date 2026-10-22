import Foundation

extension AccountKind {
    var systemImage: String {
        switch self {
        case .cash: "banknote.fill"
        case .checking: "building.columns.fill"
        case .savings: "sparkles"
        case .investment: "chart.line.uptrend.xyaxis"
        case .creditCard: "creditcard.fill"
        case .loan: "doc.text.fill"
        case .otherAsset: "shippingbox.fill"
        case .otherLiability: "exclamationmark.circle.fill"
        }
    }
}

extension TransactionKind {
    var systemImage: String {
        switch self {
        case .expense: "arrow.up.right"
        case .income: "arrow.down.left"
        case .transfer: "arrow.left.arrow.right"
        }
    }
}

extension GoalKind {
    var systemImage: String {
        switch self {
        case .savings: "target"
        case .debt: "arrow.down.circle.fill"
        case .investment: "chart.line.uptrend.xyaxis"
        case .other: "star.fill"
        }
    }
}

extension RecurringCadence {
    var shortDescription: String {
        L10n.text("recurring.cadence.every_\(rawValue)", table: .data)
    }
}
