import Foundation

enum PercentageFormatter {
    static let maximumWholePercentage = 999_999

    static func wholeMagnitude(from ratio: Double) -> Int {
        guard !ratio.isNaN else { return 0 }
        let magnitude = abs(ratio)
        guard magnitude.isFinite else { return maximumWholePercentage }
        let scaled = magnitude * 100
        guard scaled.isFinite else { return maximumWholePercentage }
        return Int(
            min(
                scaled.rounded(),
                Double(maximumWholePercentage)
            )
        )
    }

    static func wholeMagnitudeText(from ratio: Double) -> String {
        let percentage = wholeMagnitude(from: ratio)
        guard isCapped(ratio) else { return String(percentage) }
        return "\(percentage)+"
    }

    static func localizedWholeMagnitudeText(from ratio: Double) -> String {
        let value = AppFormatters.integer(wholeMagnitude(from: ratio))
        guard isCapped(ratio) else { return value }
        return L10n.format("number.capped", table: .data, value)
    }

    private static func isCapped(_ ratio: Double) -> Bool {
        guard !ratio.isNaN else { return false }
        let magnitude = abs(ratio)
        return !magnitude.isFinite
            || magnitude * 100 > Double(maximumWholePercentage)
    }
}
