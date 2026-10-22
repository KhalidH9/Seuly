import Foundation

extension ActivityViewModel {
    func requestEditAfterDetailDismissal(
        _ transaction: FinancialTransaction
    ) {
        detailDismissalAction = .edit(transaction)
        selectedTransaction = nil
    }

    func requestDeletionAfterDetailDismissal(
        _ transaction: FinancialTransaction
    ) {
        detailDismissalAction = .delete(transaction)
        selectedTransaction = nil
    }

    func takeDetailDismissalAction() -> DetailDismissalAction? {
        defer { detailDismissalAction = nil }
        return detailDismissalAction
    }

    var analytics: FinanceAnalytics {
        FinanceAnalytics(workspace: workspace)
    }

    func signedAmount(
        for transaction: FinancialTransaction
    ) -> Int64 {
        transaction.signedAmountMinor
    }

    func destinationAccount(
        for transaction: FinancialTransaction
    ) -> FinancialAccount? {
        workspace.account(id: transaction.destinationAccountID)
    }

    func dayTitle(_ date: Date) -> String {
        if FinanceCalendar.current.isDateInToday(date) {
            return L10n.text("date.today", table: .data)
        }
        if FinanceCalendar.current.isDateInYesterday(date) {
            return L10n.text("date.yesterday", table: .data)
        }
        return date.formatted(
            Date.FormatStyle()
                .weekday(.wide)
                .day()
                .month(.wide)
                .locale(AppLocale.locale)
        )
    }
}
