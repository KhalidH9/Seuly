import SwiftUI

struct CurrencyMark: View {
    let currency: CurrencyDefinition?
    var symbolScale: SaudiRiyalSymbolScale = .body

    var body: some View {
        Group {
            if currency?.isSaudiRiyal == true {
                SaudiRiyalGlyph(scale: symbolScale)
            } else {
                Text(
                    currency?.code
                        ?? L10n.text("not_available", table: .shared)
                )
            }
        }
        .accessibilityLabel(
            currency?.localizedName
                ?? L10n.text("not_available", table: .shared)
        )
    }
}
