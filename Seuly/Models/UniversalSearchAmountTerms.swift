import Foundation

enum UniversalSearchAmountTerms {
    static func make(
        minorUnits: Int64,
        currency: CurrencyDefinition?
    ) -> String {
        let localized = MoneyFormatter.editableString(
            minorUnits: minorUnits,
            currency: currency
        )
        let western = MoneyFormatter.editableString(
            minorUnits: minorUnits,
            currency: currency,
            locale: Locale(identifier: "en_US_POSIX")
        )
        let currencyTerms = currency.map {
            [$0.code, $0.name, $0.localizedName, $0.semanticSymbol]
        } ?? []
        return ([localized, western] + currencyTerms)
            .joined(separator: " ")
    }
}
