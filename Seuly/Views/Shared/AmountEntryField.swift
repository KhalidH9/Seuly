import SwiftUI

/// The headline input of every money form. Oversized figures with the currency
/// mark beside them.
///
/// The field fills the well rather than sizing to its text, so a single tap
/// anywhere focuses it -- the previous intrinsic width needed a tap gesture to
/// compensate, and that gesture swallowed the first tap.
struct AmountEntryField: View {
    @Environment(\.seulyTheme) private var theme
    @Binding var text: String
    let currency: CurrencyDefinition?
    var title: String = L10n.text("amount", table: .shared)
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: SeulyLayout.spacingXS) {
            Text(title)
                .font(SeulyFont.footnoteEmphasized)
                .foregroundStyle(theme.textSecondary)
                .multilineTextAlignment(.center)
            SeulyNumeralText {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    CurrencyMark(currency: currency, symbolScale: .title)
                        .font(SeulyFont.moneyTitle)
                        .foregroundStyle(theme.textTertiary)
                        .accessibilityHidden(true)
                    field
                }
            }
        }
        .padding(SeulyLayout.spacingL)
        .frame(maxWidth: .infinity)
        .background(theme.surfacePrimary, in: shape)
        .overlay {
            shape
                .strokeBorder(border, lineWidth: isFocused ? 2 : 0)
                .allowsHitTesting(false)
        }
    }

    private var field: some View {
        TextField(
            L10n.text("amount.placeholder", table: .shared),
            text: $text
        )
        .keyboardType(.decimalPad)
        .focused($isFocused)
        .font(SeulyFont.moneyHero)
        .foregroundStyle(theme.textPrimary)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityLabel(title)
        .accessibilityHint(
            currency?.localizedName
                ?? L10n.text("not_available", table: .shared)
        )
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(
            cornerRadius: SeulyLayout.cardRadius,
            style: .continuous
        )
    }

    private var border: Color {
        isFocused ? theme.focusBorder : .clear
    }
}
