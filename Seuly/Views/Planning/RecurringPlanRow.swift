import SwiftUI

struct RecurringPlanRow: View {
    @Environment(\.seulyTheme) private var theme
    let rule: RecurringRule
    let amountMinor: Int64
    let currency: CurrencyDefinition?
    let hidesAmount: Bool

    var body: some View {
        HStack(spacing: SeulyLayout.spacingM) {
            SeulyIconTile(
                systemImage: "repeat",
                tint: theme.textColorOnSoftBackground(for: rule.kind),
                background: theme.softColor(for: rule.kind)
            )
            VStack(alignment: .leading, spacing: 2) {
                Text(
                    rule.merchant.isEmpty
                        ? rule.kind.displayName
                        : rule.merchant
                )
                .font(SeulyFont.bodyEmphasized)
                .foregroundStyle(theme.textPrimary)
                .lineLimit(1)
                Text(
                    L10n.format(
                        "recurring.next",
                        table: .planning,
                        AppFormatters.dayMonth(rule.nextRunDate),
                        rule.cadence.shortDescription
                    )
                )
                .font(SeulyFont.caption)
                .foregroundStyle(theme.textSecondary)
                .lineLimit(1)
            }
            Spacer(minLength: SeulyLayout.spacingS)
            PrivacySensitiveAmount(
                minorUnits: amountMinor,
                currency: currency,
                isHidden: hidesAmount,
                style: SeulyFont.moneyRow,
                color: theme.textColor(for: rule.kind),
                symbolScale: .body
            )
            .lineLimit(1)
        }
        .frame(minHeight: SeulyLayout.rowHeight)
        .accessibilityElement(children: .combine)
    }
}
