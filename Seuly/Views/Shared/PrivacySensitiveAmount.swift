import SwiftUI

/// An amount that respects privacy mode. Hidden amounts keep the same slot
/// width so toggling privacy never reflows the surrounding layout.
struct PrivacySensitiveAmount: View {
    @Environment(\.seulyTheme) private var theme
    let minorUnits: Int64
    let currency: CurrencyDefinition?
    let isHidden: Bool
    var style: Font = SeulyFont.moneyTitle
    var color: Color?
    var compact = false
    var showSign = false
    var symbolScale: SaudiRiyalSymbolScale = .title2

    var body: some View {
        Group {
            if isHidden {
                Text(verbatim: "\u{2022}\u{2022}\u{2022}\u{2022}\u{2022}")
            } else {
                MoneyAmountText(
                    minorUnits: minorUnits,
                    currency: currency,
                    showSign: showSign,
                    compact: compact,
                    symbolScale: symbolScale
                )
            }
        }
        .font(style)
        .foregroundStyle(color ?? theme.textPrimary)
        .contentTransition(.numericText())
        .animation(SeulyMotion.content, value: minorUnits)
        .accessibilityLabel(accessibilityText)
    }

    private var accessibilityText: String {
        guard !isHidden else {
            return L10n.text("amount.hidden", table: .shared)
        }
        return MoneyFormatter.presentation(
            minorUnits: minorUnits,
            currency: currency,
            showSign: showSign
        ).accessibilityText
    }
}
