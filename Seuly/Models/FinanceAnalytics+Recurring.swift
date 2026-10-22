import Foundation

extension FinanceAnalytics {
    var upcomingRecurringOccurrences: [RecurringOccurrence] {
        let today = calendar.startOfDay(for: referenceDate)
        let monthEnd = referenceDate.endOfMonth(using: calendar)
        return workspace.recurringRules
            .filter { $0.status == .active }
            .flatMap { rule -> [RecurringOccurrence] in
                occurrences(for: rule, from: today, before: monthEnd)
            }
            .sorted { $0.dueDate < $1.dueDate }
    }

    var upcomingExpenseMinor: Int64 {
        upcomingRecurringOccurrences
            .filter { $0.rule.kind == .expense }
            .lazy.map { $0.rule.amountMinor }.sumClamped()
    }

    var uncoveredUpcomingExpenseMinor: Int64 {
        let remaining = Dictionary(
            uniqueKeysWithValues: budgetProgress.map {
                ($0.category.id, max($0.remainingMinor, 0))
            }
        )
        let expenses = Dictionary(
            grouping: upcomingRecurringOccurrences.filter {
                $0.rule.kind == .expense
            },
            by: { $0.rule.categoryID }
        )
        return expenses.reduce(Int64(0)) { total, item in
            let planned = item.value.lazy.map { $0.rule.amountMinor }
                .sumClamped()
            guard
                let categoryID = item.key,
                let reserved = remaining[categoryID]
            else { return total.addingClamped(planned) }
            return total.addingClamped(
                max(planned.subtractingClamped(reserved), 0)
            )
        }
    }

    var safeToSpendMinor: Int64 {
        max(
            liquidBalanceMinor
                .subtractingClamped(uncoveredUpcomingExpenseMinor)
                .subtractingClamped(remainingBudgetMinor),
            0
        )
    }

    var safeToSpendTodayMinor: Int64 {
        let days = max(
            calendar.dateComponents(
                [.day],
                from: calendar.startOfDay(for: referenceDate),
                to: referenceDate.endOfMonth(using: calendar)
            ).day ?? 1,
            1
        )
        return safeToSpendMinor / Int64(days)
    }

    private func occurrences(
        for rule: RecurringRule,
        from start: Date,
        before end: Date
    ) -> [RecurringOccurrence] {
        var result: [RecurringOccurrence] = []
        var date = calendar.startOfDay(for: rule.nextRunDate)
        while date < start {
            guard let next = advancedDate(from: date, cadence: rule.cadence) else {
                return result
            }
            date = next
        }
        while date < end {
            result.append(RecurringOccurrence(rule: rule, dueDate: date))
            guard let next = advancedDate(from: date, cadence: rule.cadence) else {
                break
            }
            date = next
        }
        return result
    }
}
