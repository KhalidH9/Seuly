import SwiftUI

/// Month-over-month spending change, styled for the gradient rather than
/// reusing the light-background trend badge.
struct DashboardHeroChangeView: View {
    @Environment(\.seulyTheme) private var theme
    let change: Double

    var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            HStack(spacing: 3) {
                Image(
                    systemName: change <= 0
                        ? "arrow.down.right"
                        : "arrow.up.right"
                )
                .font(SeulyFont.caption2.weight(.bold))
                Text(
                    abs(change),
                    format: .percent.precision(.fractionLength(0))
                )
                .font(SeulyFont.moneyCaption)
            }
            Text(L10n.text("change.last_month", table: .dashboard))
                .font(SeulyFont.caption2)
                .multilineTextAlignment(.trailing)
        }
        .foregroundStyle(theme.onBrandFill)
        .padding(.horizontal, SeulyLayout.spacingS)
        .padding(.vertical, 6)
        .background(
            theme.onBrandFill.opacity(0.16),
            in: RoundedRectangle(
                cornerRadius: SeulyLayout.compactRadius,
                style: .continuous
            )
        )
        .accessibilityElement(children: .combine)
    }
}
