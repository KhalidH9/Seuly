import Foundation

extension UniversalSearchCatalog {
    var budgetResults: [UniversalSearchResult] {
        workspace.budgets.filter(isCurrentBudget).map { budget in
            let names = budget.lines.compactMap {
                workspace.category(id: $0.categoryID)?.localizedName
            }
            let total = budget.lines.lazy.map(\.limitMinor).sumClamped()
            let currency = workspace.currency(for: budget.currencyCode)
            return UniversalSearchResult(
                id: .budget(budget.id),
                kind: .budget,
                title: budget.localizedName,
                subtitle: LocalizedTextFormatter.dateRange(
                    from: budget.startsOn,
                    through: inclusiveEnd(for: budget)
                ),
                amountMinor: total,
                currencyCode: budget.currencyCode,
                destination: .planning(kind: .budget, entityID: budget.id),
                searchTerms: ([budget.name] + names).joined(separator: " "),
                sensitiveSearchTerms: UniversalSearchAmountTerms.make(
                    minorUnits: total,
                    currency: currency
                ),
                sortDate: budget.startsOn
            )
        }
    }

    private func isCurrentBudget(_ budget: BudgetPeriod) -> Bool {
        let date = LocalDate(date: referenceDate)
        return budget.periodStart <= date && date < budget.periodEnd
    }

    private func inclusiveEnd(for budget: BudgetPeriod) -> Date {
        FinanceCalendar.current.date(
            byAdding: .day,
            value: -1,
            to: budget.endsOn
        ) ?? budget.endsOn
    }
}
