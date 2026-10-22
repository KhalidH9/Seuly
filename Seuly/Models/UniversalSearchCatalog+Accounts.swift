import Foundation

extension UniversalSearchCatalog {
    var accountResults: [UniversalSearchResult] {
        workspace.accounts.compactMap { account in
            guard account.archivedAt == nil else { return nil }
            let currency = workspace.currency(for: account.currencyCode)
            let subtitle = [
                account.kind.displayName,
                account.institutionName
            ].compactMap { $0 }
            return UniversalSearchResult(
                id: .account(account.id),
                kind: .account,
                title: account.name,
                subtitle: LocalizedTextFormatter.dotSeparated(subtitle),
                metadata: currency?.localizedName ?? account.currencyCode,
                systemImage: UniversalSearchSymbol.sanitized(
                    account.iconKey,
                    fallback: account.kind.systemImage
                ),
                amountMinor: account.balanceMinor,
                currencyCode: account.currencyCode,
                destination: .account(account.id),
                sensitiveSearchTerms: UniversalSearchAmountTerms.make(
                    minorUnits: account.balanceMinor,
                    currency: currency
                )
            )
        }
    }

    var categoryResults: [UniversalSearchResult] {
        workspace.categories.compactMap { category in
            guard category.archivedAt == nil else { return nil }
            let kind: TransactionKind = category.kind == .income
                ? .income : .expense
            return UniversalSearchResult(
                id: .category(category.id),
                kind: .category,
                title: category.localizedName,
                subtitle: kind.displayName,
                systemImage: UniversalSearchSymbol.sanitized(
                    category.iconKey,
                    fallback: UniversalSearchKind.category.systemImage
                ),
                destination: .category(category.id),
                searchTerms: category.name
            )
        }
    }
}
