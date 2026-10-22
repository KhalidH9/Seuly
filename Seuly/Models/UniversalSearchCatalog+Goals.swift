import Foundation

extension UniversalSearchCatalog {
    var goalResults: [UniversalSearchResult] {
        workspace.goals.filter { $0.status == .active }.map { goal in
            UniversalSearchResult(
                id: .goal(goal.id),
                kind: .goal,
                title: goal.name,
                subtitle: goal.kind.displayName,
                metadata: goal.targetDate.map(AppFormatters.fullDate) ?? "",
                systemImage: UniversalSearchSymbol.sanitized(
                    goal.iconKey,
                    fallback: goal.kind.systemImage
                ),
                amountMinor: goal.targetMinor,
                currencyCode: goal.currencyCode,
                destination: .planning(kind: .goal, entityID: goal.id),
                sensitiveSearchTerms: UniversalSearchAmountTerms.make(
                    minorUnits: goal.targetMinor,
                    currency: workspace.currency(for: goal.currencyCode)
                ),
                sortDate: goal.targetDate
            )
        }
    }
}
