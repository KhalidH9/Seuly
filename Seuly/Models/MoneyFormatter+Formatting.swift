import Foundation

extension MoneyFormatter {
    static func decimalString(_ amount: Decimal, digits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = AppLocale.locale
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = digits
        formatter.maximumFractionDigits = digits
        return formatter.string(from: NSDecimalNumber(decimal: amount))
            ?? "\(amount)"
    }

    static func currencyString(
        _ amount: Decimal,
        currency: CurrencyDefinition,
        digits: Int
    ) -> String {
        let formatter = NumberFormatter()
        formatter.locale = AppLocale.locale
        formatter.numberStyle = .currency
        formatter.currencyCode = currency.code
        formatter.minimumFractionDigits = digits
        formatter.maximumFractionDigits = digits
        return formatter.string(from: NSDecimalNumber(decimal: amount))
            ?? "\(amount) \(currency.code)"
    }

    static func localizedSign(
        for amount: Decimal,
        showSign: Bool
    ) -> String {
        let formatter = NumberFormatter()
        formatter.locale = AppLocale.locale
        if amount < 0 { return formatter.minusSign }
        if amount > 0 && showSign { return formatter.plusSign }
        return ""
    }

    static func compactScale(
        for amount: Decimal,
        compact: Bool
    ) -> (divisor: Decimal, suffix: String)? {
        guard compact else { return nil }
        let absolute = NSDecimalNumber(decimal: amount).doubleValue
        switch absolute {
        case 1_000_000_000...:
            return (1_000_000_000, compactSuffix("billion"))
        case 1_000_000...:
            return (1_000_000, compactSuffix("million"))
        case 1_000...:
            return (1_000, compactSuffix("thousand"))
        default: return nil
        }
    }

    private static func compactSuffix(_ key: String) -> String {
        L10n.text("number.compact.\(key)", table: .data)
    }
}
