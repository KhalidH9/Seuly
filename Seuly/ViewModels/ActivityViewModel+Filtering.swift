import Foundation

extension ActivityViewModel {
    var selectedCategory: FinanceCategory? {
        workspace.category(id: selectedCategoryID)
    }

    var hasActiveFilters: Bool {
        !searchText.isEmpty
            || selectedKind != nil
            || selectedCategoryID != nil
            || period != .thisMonth
    }

    var filteredTransactions: [FinancialTransaction] {
        workspace.transactions
            .filter(matchesFilters)
            .sorted { $0.effectiveDate > $1.effectiveDate }
    }

    var groups: [TransactionDayGroup] {
        Dictionary(grouping: filteredTransactions) {
            FinanceCalendar.current.startOfDay(for: $0.effectiveDate)
        }
        .map {
            TransactionDayGroup(date: $0.key, transactions: $0.value)
        }
        .sorted { $0.date > $1.date }
    }

    func selectKind(_ kind: TransactionKind?) {
        selectedKind = kind
        selectedCategoryID = nil
    }

    private func matchesFilters(
        _ transaction: FinancialTransaction
    ) -> Bool {
        guard transaction.status != .void else { return false }
        if let selectedKind, transaction.kind != selectedKind { return false }
        if
            let selectedCategoryID,
            transaction.categoryID != selectedCategoryID
        { return false }
        if
            period == .thisMonth,
            !transaction.effectiveDate.isInSameMonth(as: .now)
        { return false }
        guard !searchText.isEmpty else { return true }
        let values = [
            transaction.merchant,
            transaction.note,
            category(for: transaction)?.localizedName ?? "",
            account(for: transaction)?.name ?? ""
        ]
        return values.joined(separator: " ")
            .localizedCaseInsensitiveContains(searchText)
    }
}
