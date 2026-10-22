import Foundation

extension UniversalSearchCatalog {
    func rankedBefore(
        _ lhs: (UniversalSearchResult, Int),
        _ rhs: (UniversalSearchResult, Int)
    ) -> Bool {
        if lhs.1 != rhs.1 { return lhs.1 > rhs.1 }
        return newestFirst(lhs.0, rhs.0)
    }

    func newestFirst(
        _ lhs: UniversalSearchResult,
        _ rhs: UniversalSearchResult
    ) -> Bool {
        if lhs.sortDate != rhs.sortDate {
            return (lhs.sortDate ?? .distantPast) > (rhs.sortDate ?? .distantPast)
        }
        if lhs.kind != rhs.kind {
            return kindPriority(lhs.kind) < kindPriority(rhs.kind)
        }
        return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
    }

    func soonestFirst(
        _ lhs: UniversalSearchResult,
        _ rhs: UniversalSearchResult
    ) -> Bool {
        (lhs.sortDate ?? .distantFuture) < (rhs.sortDate ?? .distantFuture)
    }

    private func kindPriority(_ kind: UniversalSearchKind) -> Int {
        UniversalSearchKind.allCases.firstIndex(of: kind) ?? .max
    }
}
