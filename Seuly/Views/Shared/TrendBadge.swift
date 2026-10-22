import SwiftUI

struct TrendBadge: View {
    @Environment(\.seulyTheme) private var theme
    let change: Double
    var lowerIsBetter = false

    var body: some View {
        HStack(spacing: 3) {
            Image(
                systemName: change >= 0
                    ? "arrow.up.right"
                    : "arrow.down.right"
            )
            .font(SeulyFont.caption2.weight(.bold))
            Text(abs(change), format: .percent.precision(.fractionLength(0)))
                .font(SeulyFont.moneyCaption)
        }
        .foregroundStyle(isFavourable ? theme.incomeText : theme.expenseText)
        .padding(.horizontal, SeulyLayout.spacingS)
        .padding(.vertical, 5)
        .background(
            isFavourable ? theme.incomeLight : theme.expenseLight,
            in: Capsule()
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
    }

    private var isFavourable: Bool {
        lowerIsBetter ? change <= 0 : change >= 0
    }

    private var accessibilityText: String {
        L10n.format(
            change >= 0 ? "trend.up" : "trend.down",
            table: .shared,
            PercentageFormatter.localizedWholeMagnitudeText(from: change)
        )
    }
}
