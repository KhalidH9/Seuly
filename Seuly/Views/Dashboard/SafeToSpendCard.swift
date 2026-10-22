import SwiftUI

/// Safe to spend: the figure the app exists to produce. The explanation is a
/// tap away because a derived number needs to be auditable.
struct SafeToSpendCard: View {
    @Environment(\.seulyTheme) private var theme
    let analytics: FinanceAnalytics
    let currency: CurrencyDefinition?
    let hidesAmount: Bool
    @State private var showsExplanation = false

    var body: some View {
        SeulyCard {
            VStack(alignment: .leading, spacing: SeulyLayout.spacingM) {
                HStack(alignment: .top) {
                    SeulyIconTile(
                        systemImage: "drop.fill",
                        tint: theme.brandPrimary,
                        background: theme.brandPrimarySoft,
                        size: SeulyLayout.compactIcon
                    )
                    Spacer()
                    explanationButton
                }
                Text(L10n.text("safe.title", table: .dashboard))
                    .font(SeulyFont.footnoteEmphasized)
                    .foregroundStyle(theme.textSecondary)
                PrivacySensitiveAmount(
                    minorUnits: analytics.safeToSpendMinor,
                    currency: currency,
                    isHidden: hidesAmount,
                    style: SeulyFont.moneyTitle,
                    compact: true,
                    symbolScale: .title2
                )
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                secondaryContent
                    .font(SeulyFont.caption)
                    .foregroundStyle(theme.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .popover(isPresented: $showsExplanation) {
            SafeToSpendExplanationView()
        }
    }

    private var explanationButton: some View {
        Button {
            showsExplanation = true
        } label: {
            Image(systemName: "info.circle")
                .font(SeulyFont.subheadline)
                .foregroundStyle(theme.textTertiary)
                .frame(
                    width: SeulyLayout.minimumTapTarget,
                    height: SeulyLayout.minimumTapTarget
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(-SeulyLayout.spacingS)
        .accessibilityLabel(
            L10n.text("safe.explain_accessibility", table: .dashboard)
        )
    }

    @ViewBuilder
    private var secondaryContent: some View {
        if hidesAmount {
            Text(L10n.text("safe.month_end", table: .dashboard))
        } else {
            LocalizedInlineValue("safe.per_day", table: .dashboard) {
                MoneyAmountText(
                    minorUnits: analytics.safeToSpendTodayMinor,
                    currency: currency,
                    compact: true,
                    symbolScale: .caption
                )
            }
        }
    }
}
