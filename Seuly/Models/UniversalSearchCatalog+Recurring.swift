import Foundation

extension UniversalSearchCatalog {
    var recurringResults: [UniversalSearchResult] {
        workspace.recurringRules.filter { $0.status == .active }.map { rule in
            let category = workspace.category(id: rule.categoryID)
            let subtitle = LocalizedTextFormatter.dotSeparated(
                [rule.kind.displayName, rule.cadence.displayName]
            )
            let account = recurringAccount(for: rule)
            let currency = account.flatMap {
                workspace.currency(for: $0.currencyCode)
            } ?? workspace.currency
            return UniversalSearchResult(
                id: .recurring(rule.id),
                kind: .recurring,
                title: rule.merchant,
                subtitle: subtitle,
                metadata: AppFormatters.fullDate(rule.nextRunDate),
                amountMinor: rule.signedAmountMinor,
                currencyCode: currency?.code,
                destination: .planning(kind: .recurring, entityID: rule.id),
                searchTerms: "\(rule.note) \(category?.localizedName ?? "")",
                sensitiveSearchTerms: UniversalSearchAmountTerms.make(
                    minorUnits: rule.signedAmountMinor,
                    currency: currency
                ),
                sortDate: rule.nextRunDate
            )
        }
    }

    private func recurringAccount(
        for rule: RecurringRule
    ) -> FinancialAccount? {
        let leg = rule.kind == .income
            ? rule.legs.first(where: { $0.amountMinor > 0 })
            : rule.legs.first(where: { $0.amountMinor < 0 })
        return workspace.account(id: leg?.accountID)
    }
}
