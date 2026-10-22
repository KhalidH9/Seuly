import SwiftUI

/// Renders a formatted amount, swapping in the Saudi riyal glyph when the
/// currency calls for it. The numeric run is pinned left-to-right.
struct MoneyAmountText: View {
    let presentation: MoneyPresentation
    let symbolScale: SaudiRiyalSymbolScale

    init(
        minorUnits: Int64,
        currency: CurrencyDefinition?,
        showSign: Bool = false,
        compact: Bool = false,
        symbolScale: SaudiRiyalSymbolScale = .body
    ) {
        self.symbolScale = symbolScale
        presentation = MoneyFormatter.presentation(
            minorUnits: minorUnits,
            currency: currency,
            showSign: showSign,
            compact: compact
        )
    }

    var body: some View {
        Group {
            if presentation.usesSaudiRiyalSymbol {
                SeulyNumeralText {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text(presentation.sign)
                        SaudiRiyalGlyph(scale: symbolScale)
                        Text(" \(presentation.amountText)")
                    }
                }
            } else {
                Text(presentation.plainText)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(presentation.accessibilityText)
    }
}
