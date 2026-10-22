import Foundation

extension AccountFormViewModel {
    var currency: CurrencyDefinition? { model.workspace.currency }

    var parsedBalance: Int64? {
        currency?.minorUnits(
            from: balanceText.isEmpty ? "0" : balanceText,
            allowsNegative: true
        )
    }

    func currency(for code: String) -> CurrencyDefinition? {
        model.workspace.currency(for: code)
    }

    func normalizedBalance(_ balance: Int64) -> Int64 {
        kind.isLiability && balance > 0 ? -balance : balance
    }

    func displayedBalance(for account: FinancialAccount) -> Int64 {
        let balance = account.openingBalanceMinor
        guard balance != .min else { return .max }
        return account.kind.isLiability && balance < 0 ? -balance : balance
    }
}
