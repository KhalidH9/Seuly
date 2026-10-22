import Foundation

extension UniversalSearchCatalog {
    var transactionResults: [UniversalSearchResult] {
        workspace.transactions.compactMap(transactionResult)
    }

    private func transactionResult(
        _ transaction: FinancialTransaction
    ) -> UniversalSearchResult? {
        guard transaction.status != .void else { return nil }
        let category = workspace.category(id: transaction.categoryID)
        let account = workspace.account(id: transaction.displayAccountID)
        let title = transaction.merchant.isEmpty
            ? transaction.kind.displayName
            : transaction.merchant
        let details = [
            transaction.kind.displayName,
            category?.localizedName,
            account?.name
        ].compactMap { $0 }.filter { !$0.isEmpty }
        let currency = account.flatMap {
            workspace.currency(for: $0.currencyCode)
        } ?? workspace.currency
        let terms = [
            transaction.note,
            category?.name ?? "",
            account?.institutionName ?? ""
        ].joined(separator: " ")
        return UniversalSearchResult(
            id: .transaction(transaction.id),
            kind: .transaction,
            title: title,
            subtitle: LocalizedTextFormatter.dotSeparated(details),
            metadata: AppFormatters.fullDate(transaction.effectiveDate),
            amountMinor: transaction.signedAmountMinor,
            currencyCode: currency?.code,
            destination: .transaction(transaction.id),
            searchTerms: terms,
            sensitiveSearchTerms: UniversalSearchAmountTerms.make(
                minorUnits: transaction.amountMinor,
                currency: currency
            ),
            sortDate: transaction.effectiveDate
        )
    }
}
