import Foundation

struct UniversalSearchCatalog: Sendable {
    let workspace: FinanceWorkspace
    let referenceDate: Date

    init(workspace: FinanceWorkspace, referenceDate: Date = .now) {
        self.workspace = workspace
        self.referenceDate = referenceDate
    }

    var allResults: [UniversalSearchResult] {
        transactionResults
            + accountResults
            + budgetResults
            + categoryResults
            + goalResults
            + recurringResults
    }

    func search(
        query: String,
        scope: UniversalSearchScope,
        includesAmounts: Bool = true,
        sourceResults: [UniversalSearchResult]? = nil,
        limit: Int = 60
    ) -> [UniversalSearchResult] {
        let normalizedQuery = UniversalSearchMatcher.normalize(query)
        return (sourceResults ?? allResults)
            .filter { scope.includes($0.kind) }
            .compactMap { result -> (UniversalSearchResult, Int)? in
                guard let score = UniversalSearchMatcher.score(
                    normalizedQuery: normalizedQuery,
                    result: result,
                    includesSensitiveTerms: includesAmounts
                ) else { return nil }
                return (result, score)
            }
            .sorted(by: rankedBefore)
            .prefix(max(limit, 0))
            .map(\.0)
    }

    func recentResults(
        scope: UniversalSearchScope = .all,
        sourceResults: [UniversalSearchResult]? = nil,
        limit: Int = 10
    ) -> [UniversalSearchResult] {
        let candidates = sourceResults ?? allResults
        if scope != .all {
            return Array(
                candidates
                    .filter { scope.includes($0.kind) }
                    .sorted(by: newestFirst)
                    .prefix(max(limit, 0))
            )
        }
        let transactions = candidates.filter { $0.kind == .transaction }
            .sorted(by: newestFirst).prefix(6)
        let goals = candidates.filter { $0.kind == .goal }.prefix(2)
        let recurring = candidates.filter { $0.kind == .recurring }
            .sorted(by: soonestFirst).prefix(2)
        let primary = Array(transactions + goals + recurring)
        let values = primary.isEmpty ? candidates : primary
        return Array(values.prefix(max(limit, 0)))
    }
}
