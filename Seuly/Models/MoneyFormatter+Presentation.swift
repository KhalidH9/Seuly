import Foundation

extension MoneyFormatter {
    static func presentation(
        minorUnits: Int64,
        currency: CurrencyDefinition?,
        showSign: Bool = false,
        compact: Bool = false
    ) -> MoneyPresentation {
        guard let currency else { return unavailablePresentation }
        let amount = currency.majorAmount(from: minorUnits)
        let magnitude = amount < 0 ? -amount : amount
        let scale = compactScale(for: magnitude, compact: compact)
        let digits = compact ? (scale == nil ? 0 : 1) : currency.minorUnit
        let scaledMagnitude = magnitude / (scale?.divisor ?? 1)
        let number = decimalString(scaledMagnitude, digits: digits)
        let amountText = number + (scale?.suffix ?? "")
        let sign = localizedSign(for: amount, showSign: showSign)
        let plain: String
        if currency.isSaudiRiyal {
            plain = "\(sign)\(currency.semanticSymbol) \(amountText)"
        } else {
            let base = currencyString(
                amount / (scale?.divisor ?? 1),
                currency: currency,
                digits: digits
            ) + (scale?.suffix ?? "")
            plain = amount > 0 && showSign ? "+\(base)" : base
        }
        return MoneyPresentation(
            sign: sign,
            amountText: amountText,
            plainText: plain,
            accessibilityText: accessibilityString(
                amount: amount,
                currency: currency,
                showSign: showSign
            ),
            usesSaudiRiyalSymbol: currency.isSaudiRiyal
        )
    }

    private static var unavailablePresentation: MoneyPresentation {
        let text = L10n.text("not_available", table: .shared)
        return MoneyPresentation(
            sign: "",
            amountText: text,
            plainText: text,
            accessibilityText: text,
            usesSaudiRiyalSymbol: false
        )
    }

    private static func accessibilityString(
        amount: Decimal,
        currency: CurrencyDefinition,
        showSign: Bool
    ) -> String {
        let magnitude = amount < 0 ? -amount : amount
        let sign = localizedSign(for: amount, showSign: showSign)
        let number = decimalString(magnitude, digits: currency.minorUnit)
        return "\(sign)\(number) \(currency.localizedName)"
    }
}
