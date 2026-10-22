import SwiftUI

/// A month figure inside the hero card. Sized as a supporting statistic so it
/// never competes with the net-worth line above it.
struct DashboardHeroMetricView: View {
    @Environment(\.seulyTheme) private var theme
    let title: String
    let amountMinor: Int64
    let systemImage: String
    let currency: CurrencyDefinition?
    let hidesAmount: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingXS) {
            HStack(spacing: SeulyLayout.spacingXS) {
                Image(systemName: systemImage)
                    .font(SeulyFont.caption2.weight(.bold))
                Text(title)
                    .font(SeulyFont.caption)
            }
            .foregroundStyle(theme.onBrandFill.opacity(0.85))
            PrivacySensitiveAmount(
                minorUnits: amountMinor,
                currency: currency,
                isHidden: hidesAmount,
                style: SeulyFont.moneyRow,
                color: theme.onBrandFill,
                compact: true,
                symbolScale: .body
            )
            .lineLimit(1)
            .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}
