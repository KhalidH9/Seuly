import Foundation

enum MoneyFormatter {
    static func string(
        minorUnits: Int64,
        currency: CurrencyDefinition?,
        showSign: Bool = false,
        compact: Bool = false
    ) -> String {
        presentation(
            minorUnits: minorUnits,
            currency: currency,
            showSign: showSign,
            compact: compact
        ).plainText
    }

    static func editableString(
        minorUnits: Int64,
        currency: CurrencyDefinition?,
        locale: Locale = AppLocale.locale
    ) -> String {
        guard let currency else { return "" }
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = currency.minorUnit
        let amount = currency.majorAmount(from: minorUnits)
        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? ""
    }
}
