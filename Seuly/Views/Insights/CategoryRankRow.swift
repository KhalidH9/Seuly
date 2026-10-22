import SwiftUI

/// One ranked category. Directly labelled, with its swatch carrying the link
/// back to the share bar and the text staying in ink tokens.
struct CategoryRankRow: View {
    @Environment(\.seulyTheme) private var theme
    let share: InsightsViewModel.CategoryShare
    let currency: CurrencyDefinition?
    let hidesAmount: Bool

    var body: some View {
        HStack(spacing: SeulyLayout.spacingM) {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(theme.chartRampColor(rank: share.rank))
                .frame(width: 10, height: 22)
                .accessibilityHidden(true)
            Text(share.name)
                .font(SeulyFont.subheadline)
                .foregroundStyle(theme.textPrimary)
                .lineLimit(1)
            Spacer(minLength: SeulyLayout.spacingS)
            Text(percentText)
                .font(SeulyFont.moneyCaption)
                .foregroundStyle(theme.textSecondary)
                .monospacedDigit()
            PrivacySensitiveAmount(
                minorUnits: share.amountMinor,
                currency: currency,
                isHidden: hidesAmount,
                style: SeulyFont.moneyCaption,
                compact: true,
                symbolScale: .caption
            )
            .lineLimit(1)
        }
        .frame(minHeight: 34)
        .accessibilityElement(children: .combine)
    }

    private var percentText: String {
        L10n.format(
            "goal.progress",
            table: .shared,
            AppFormatters.integer(Int((share.fraction * 100).rounded()))
        )
    }
}
