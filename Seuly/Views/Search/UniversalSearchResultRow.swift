import SwiftUI

struct UniversalSearchResultRow: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let result: UniversalSearchResult
    let currency: CurrencyDefinition?
    let hidesAmount: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            adaptiveLayout {
                UniversalSearchResultIdentityView(result: result)
                if let amount = result.amountMinor {
                    PrivacySensitiveAmount(
                        minorUnits: amount,
                        currency: currency,
                        isHidden: hidesAmount,
                        style: SeulyFont.moneyRow,
                        compact: true,
                        showSign: showsPositiveSign(amount),
                        symbolScale: .body
                    )
                    .lineLimit(1)
                }
            }
            .frame(minHeight: SeulyLayout.rowHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }

    private var adaptiveLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(
                VStackLayout(
                    alignment: .leading,
                    spacing: SeulyLayout.spacingS
                )
            )
            : AnyLayout(
                HStackLayout(
                    alignment: .center,
                    spacing: SeulyLayout.spacingM
                )
            )
    }

    private func showsPositiveSign(_ amount: Int64) -> Bool {
        amount > 0 && (
            result.kind == .transaction || result.kind == .recurring
        )
    }
}
