import SwiftUI

/// An upcoming obligation. The due date leads as a calendar block because the
/// question this row answers is "when", not "what".
struct UpcomingRuleRow: View {
    @Environment(\.seulyTheme) private var theme
    let occurrence: RecurringOccurrence
    let amountMinor: Int64
    let currency: CurrencyDefinition?
    let hidesAmount: Bool

    var body: some View {
        HStack(spacing: SeulyLayout.spacingM) {
            Text(AppFormatters.dayMonth(occurrence.dueDate))
                .font(SeulyFont.captionEmphasized)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .foregroundStyle(theme.brandPrimary)
                .frame(width: 56, height: 44)
                .background(
                    theme.brandPrimarySoft,
                    in: RoundedRectangle(
                        cornerRadius: SeulyLayout.iconTileRadius,
                        style: .continuous
                    )
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(SeulyFont.bodyEmphasized)
                    .foregroundStyle(theme.textPrimary)
                    .lineLimit(1)
                Text(cadenceText)
                    .font(SeulyFont.caption)
                    .foregroundStyle(theme.textSecondary)
            }
            Spacer(minLength: SeulyLayout.spacingS)
            PrivacySensitiveAmount(
                minorUnits: amountMinor,
                currency: currency,
                isHidden: hidesAmount,
                style: SeulyFont.moneyRow,
                color: theme.textColor(for: occurrence.rule.kind),
                symbolScale: .body
            )
            .lineLimit(1)
        }
        .frame(minHeight: SeulyLayout.rowHeight)
        .accessibilityElement(children: .combine)
    }

    private var title: String {
        occurrence.rule.merchant.isEmpty
            ? occurrence.rule.kind.displayName
            : occurrence.rule.merchant
    }

    private var cadenceText: String {
        L10n.text(
            "recurring.cadence.\(occurrence.rule.cadence.rawValue)",
            table: .dashboard
        )
    }
}
