import SwiftUI

/// Paired statistic used two or three across inside a card.
struct MetricTile: View {
    @Environment(\.seulyTheme) private var theme
    let title: String
    let systemImage: String
    let minorUnits: Int64
    let currency: CurrencyDefinition?
    let hidesAmount: Bool
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingS) {
            SeulyIconTile(
                systemImage: systemImage,
                tint: tint,
                background: tint.opacity(0.14),
                size: SeulyLayout.compactIcon
            )
            PrivacySensitiveAmount(
                minorUnits: minorUnits,
                currency: currency,
                isHidden: hidesAmount,
                style: SeulyFont.moneyMetric,
                compact: true,
                symbolScale: .headline
            )
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            Text(title)
                .font(SeulyFont.caption)
                .foregroundStyle(theme.textSecondary)
        }
        .padding(SeulyLayout.spacingM)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            theme.surfaceSecondary,
            in: RoundedRectangle(
                cornerRadius: SeulyLayout.controlRadius,
                style: .continuous
            )
        )
        .accessibilityElement(children: .combine)
    }
}
