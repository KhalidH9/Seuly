import Foundation

/// Browse support for the search tab: what kinds exist and how many of each,
/// so the idle state can offer real destinations instead of an empty page.
extension UniversalSearchViewModel {
    func resultCount(for kind: UniversalSearchKind) -> Int {
        indexedResults.count { $0.kind == kind }
    }

    /// Kinds that actually have something behind them. A browse row that leads
    /// nowhere is worse than no row.
    var browsableKinds: [UniversalSearchKind] {
        UniversalSearchKind.allCases.filter { resultCount(for: $0) > 0 }
    }

    func results(for kind: UniversalSearchKind) -> [UniversalSearchResult] {
        indexedResults.filter { $0.kind == kind }
    }

    var quickAccessResults: [UniversalSearchResult] {
        Array(displayedResults.prefix(6))
    }
}
