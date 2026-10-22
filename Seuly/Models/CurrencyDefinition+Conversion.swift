import Foundation

extension CurrencyDefinition {
    func minorUnits(fromMajorUnits amount: Double) -> Int64? {
        guard amount.isFinite else { return nil }
        let multiplier = Decimal(
            sign: .plus,
            exponent: minorUnit,
            significand: 1
        )
        var scaled = Decimal(amount) * multiplier
        var rounded = Decimal()
        NSDecimalRound(&rounded, &scaled, 0, .bankers)
        guard
            rounded <= Decimal(Self.maximumAbsoluteMinorUnits),
            rounded >= Decimal(-Self.maximumAbsoluteMinorUnits)
        else { return nil }
        return NSDecimalNumber(decimal: rounded).int64Value
    }
}
