import Foundation

extension FinanceAnalytics {
    var accountBalances: [AccountBalance] {
        return workspace.accounts
            .filter { $0.archivedAt == nil }
            .map { account in
                AccountBalance(
                    account: account,
                    balanceMinor: account.balanceMinor
                )
            }
            .sorted { $0.account.sortOrder < $1.account.sortOrder }
    }

    var netWorthMinor: Int64 {
        accountBalances
            .filter(\.account.includeInNetWorth)
            .lazy.map(\.balanceMinor).sumClamped()
    }

    var liquidBalanceMinor: Int64 {
        accountBalances
            .filter { $0.account.kind.isLiquid }
            .lazy.map(\.balanceMinor).sumClamped()
    }

    var monthIncomeMinor: Int64 {
        monthTransactions
            .filter { $0.kind == .income }
            .lazy.map(\.amountMinor).sumClamped()
    }

    var monthExpenseMinor: Int64 {
        monthTransactions
            .filter { $0.kind == .expense }
            .lazy.map(\.amountMinor).sumClamped()
    }

    var monthNetMinor: Int64 {
        monthIncomeMinor.subtractingClamped(monthExpenseMinor)
    }

    var previousMonthExpenseMinor: Int64 {
        guard let date = calendar.date(
            byAdding: .month,
            value: -1,
            to: referenceDate
        ) else { return 0 }
        return postedTransactions
            .filter {
                $0.kind == .expense
                    && calendar.isDate(
                        $0.effectiveDate,
                        equalTo: date,
                        toGranularity: .month
                    )
            }
            .lazy.map(\.amountMinor).sumClamped()
    }

    var expenseChange: Double? {
        guard previousMonthExpenseMinor > 0 else { return nil }
        return Double(
            monthExpenseMinor.subtractingClamped(previousMonthExpenseMinor)
        )
            / Double(previousMonthExpenseMinor)
    }
}
