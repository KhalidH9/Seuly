import Foundation

/// Ranked category shares for the breakdown card. The tail is folded into a
/// single remainder rather than given more colours, so the chart never carries
/// more classes than a reader can tell apart.
extension InsightsViewModel {
    struct CategoryShare: Identifiable {
        let id: String
        let name: String
        let iconKey: String
        let amountMinor: Int64
        let fraction: Double
        let rank: Int
    }

    /// Slots kept before the remainder. Five named plus one "other" stays at
    /// the six-segment ceiling for part-to-whole.
    private var visibleShareCount: Int { 5 }

    var categoryShares: [CategoryShare] {
        let spend = analytics.categorySpend
        let total = spend.map(\.amountMinor).reduce(Int64(0), +)
        guard total > 0 else { return [] }
        var shares = spend.prefix(visibleShareCount).enumerated().map {
            index, item in
            CategoryShare(
                id: item.category.id.uuidString,
                name: item.category.localizedName,
                iconKey: item.category.iconKey,
                amountMinor: item.amountMinor,
                fraction: Double(item.amountMinor) / Double(total),
                rank: index
            )
        }
        let remainder = spend.dropFirst(visibleShareCount)
            .map(\.amountMinor)
            .reduce(Int64(0), +)
        guard remainder > 0 else { return shares }
        shares.append(
            CategoryShare(
                id: "other",
                name: L10n.text("category.other", table: .insights),
                iconKey: "ellipsis.circle",
                amountMinor: remainder,
                fraction: Double(remainder) / Double(total),
                rank: shares.count
            )
        )
        return shares
    }

    var categoryCount: Int { analytics.categorySpend.count }
}
