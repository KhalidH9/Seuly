import Foundation

extension FinanceAnalytics {
    var categorySpend: [CategorySpend] {
        let expenses = monthTransactions.filter { $0.kind == .expense }
        let grouped = Dictionary(grouping: expenses) { $0.categoryID }
        return grouped.compactMap { categoryID, transactions in
            guard
                let categoryID,
                let category = workspace.categories.first(where: {
                    $0.id == categoryID
                })
            else { return nil }
            return CategorySpend(
                category: category,
                amountMinor: transactions.lazy.map(\.amountMinor).sumClamped()
            )
        }
        .sorted { $0.amountMinor > $1.amountMinor }
    }

    var dailySpend: [DailySpend] {
        let expenses = monthTransactions.filter { $0.kind == .expense }
        let grouped = Dictionary(grouping: expenses) {
            calendar.startOfDay(for: $0.effectiveDate)
        }
        return grouped.map { date, transactions in
            DailySpend(
                date: date,
                amountMinor: transactions.lazy.map(\.amountMinor).sumClamped()
            )
        }
        .sorted { $0.date < $1.date }
    }

    var insights: [String] {
        var result: [String] = []
        if let top = categorySpend.first {
            result.append(
                L10n.format(
                    "insight.top_category",
                    table: .data,
                    top.category.localizedName
                )
            )
        }
        if let change = expenseChange {
            let percentage = PercentageFormatter.localizedWholeMagnitudeText(
                from: change
            )
            if change < 0 {
                result.append(
                    L10n.format(
                        "insight.spending_lower",
                        table: .data,
                        percentage
                    )
                )
            } else if change > 0.05 {
                result.append(
                    L10n.format(
                        "insight.spending_higher",
                        table: .data,
                        percentage
                    )
                )
            }
        }
        if monthIncomeMinor > 0 {
            let rate = Double(monthNetMinor) / Double(monthIncomeMinor)
            if rate > 0.2 {
                result.append(
                    L10n.format(
                        "insight.income_kept",
                        table: .data,
                        AppFormatters.integer(Int(rate * 100))
                    )
                )
            }
        }
        if result.isEmpty {
            result.append(
                L10n.text("insight.empty", table: .data)
            )
        }
        return result
    }
}
