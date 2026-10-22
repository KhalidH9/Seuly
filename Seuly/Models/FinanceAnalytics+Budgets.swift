import Foundation

extension FinanceAnalytics {
    var currentBudget: BudgetPeriod? {
        let referenceDay = LocalDate(
            date: referenceDate,
            timeZone: calendar.timeZone
        )
        return workspace.budgets.first {
            $0.periodStart <= referenceDay && referenceDay < $0.periodEnd
        }
    }

    var budgetProgress: [BudgetProgress] {
        guard let currentBudget else { return [] }
        return currentBudget.lines.compactMap { line in
            guard let category = workspace.categories.first(where: {
                $0.id == line.categoryID
            }) else { return nil }
            let spent = monthTransactions
                .filter {
                    $0.kind == .expense && $0.categoryID == line.categoryID
                }
                .lazy.map(\.amountMinor).sumClamped()
            return BudgetProgress(
                line: line,
                category: category,
                spentMinor: spent
            )
        }
        .sorted { $0.fraction > $1.fraction }
    }

    var remainingBudgetMinor: Int64 {
        budgetProgress.lazy.map { max($0.remainingMinor, 0) }
            .sumClamped()
    }

    var monthProgress: Double {
        let day = calendar.component(.day, from: referenceDate)
        let days = calendar.range(
            of: .day,
            in: .month,
            for: referenceDate
        )?.count ?? 30
        return min(max(Double(day) / Double(days), 0), 1)
    }

    var budgetPace: Double {
        let limit = budgetProgress.lazy.map { $0.line.limitMinor }
            .sumClamped()
        guard limit > 0, monthProgress > 0 else { return 0 }
        let spent = budgetProgress.lazy.map(\.spentMinor).sumClamped()
        return (Double(spent) / Double(limit)) / monthProgress
    }
}
