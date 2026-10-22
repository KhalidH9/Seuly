import Foundation

enum UniversalSearchSymbol {
    private static let allowed: Set<String> = [
        "building.columns.fill", "creditcard.fill", "banknote.fill",
        "sparkles", "chart.line.uptrend.xyaxis", "briefcase.fill",
        "shippingbox.fill", "exclamationmark.circle.fill", "doc.text.fill",
        "laptopcomputer", "plus.circle.fill", "house.fill", "basket.fill",
        "fork.knife", "car.fill", "bag.fill", "bolt.fill", "repeat",
        "heart.fill", "square.grid.2x2.fill", "target",
        "arrow.down.circle.fill", "star.fill"
    ]

    static func sanitized(_ candidate: String, fallback: String) -> String {
        allowed.contains(candidate) ? candidate : fallback
    }
}
