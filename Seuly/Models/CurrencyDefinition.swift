import Foundation

struct CurrencyDefinition: Identifiable, Equatable, Sendable {
    static let maximumAbsoluteMinorUnits: Int64 = 9_000_000_000_000_000
    let code: String
    let name: String
    let symbol: String
    let minorUnit: Int
    let isActive: Bool

    var id: String { code }
    var isSaudiRiyal: Bool { code == "SAR" }
    var semanticSymbol: String {
        isSaudiRiyal ? "\u{20C1}" : symbol
    }
    var localizedName: String {
        L10n.databaseValue(code, prefix: "currency")
    }

    func minorUnits(
        from amountText: String,
        allowsNegative: Bool = false,
        locale: Locale = AppLocale.locale
    ) -> Int64? {
        let value = amountText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard
            let decimal = Self.decimal(from: value, locale: locale),
            allowsNegative || decimal >= 0
        else { return nil }
        let multiplier = Decimal(
            sign: .plus,
            exponent: minorUnit,
            significand: 1
        )
        var scaled = decimal * multiplier
        var rounded = Decimal()
        NSDecimalRound(&rounded, &scaled, 0, .bankers)
        guard
            rounded <= Decimal(Self.maximumAbsoluteMinorUnits),
            rounded >= Decimal(-Self.maximumAbsoluteMinorUnits)
        else { return nil }
        return NSDecimalNumber(decimal: rounded).int64Value
    }

    func majorAmount(from minorUnits: Int64) -> Decimal {
        let divisor = Decimal(
            sign: .plus,
            exponent: minorUnit,
            significand: 1
        )
        return Decimal(minorUnits) / divisor
    }

    func majorUnits(from minorUnits: Int64) -> Double {
        NSDecimalNumber(
            decimal: majorAmount(from: minorUnits)
        ).doubleValue
    }

    private static func decimal(
        from value: String,
        locale: Locale
    ) -> Decimal? {
        guard !value.isEmpty else { return nil }
        for candidate in [locale, Locale(identifier: "en_US_POSIX")] {
            let formatter = NumberFormatter()
            formatter.locale = candidate
            formatter.numberStyle = .decimal
            formatter.isLenient = false
            formatter.generatesDecimalNumbers = true
            if let number = formatter.number(from: value) {
                return number.decimalValue
            }
        }
        return nil
    }
}
