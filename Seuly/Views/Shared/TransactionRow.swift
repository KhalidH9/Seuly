import SwiftUI

/// Canonical transaction row: category glyph, merchant, context line, signed
/// amount. Collapses to a stacked layout at accessibility text sizes.
struct TransactionRow: View {
    @Environment(\.seulyTheme) private var theme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let transaction: FinancialTransaction
    let category: FinanceCategory?
    let account: FinancialAccount?
    let amountMinor: Int64
    let currency: CurrencyDefinition?
    let hidesAmount: Bool
    var showsDate = true

    var body: some View {
        HStack(alignment: .center, spacing: SeulyLayout.spacingM) {
            SeulyIconTile(
                systemImage: category?.iconKey
                    ?? transaction.kind.systemImage,
                tint: theme.textColorOnSoftBackground(for: transaction.kind),
                background: theme.softColor(for: transaction.kind)
            )
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(SeulyFont.bodyEmphasized)
                    .foregroundStyle(theme.textPrimary)
                    .lineLimit(1)
                Text(contextLine)
                    .font(SeulyFont.caption)
                    .foregroundStyle(theme.textSecondary)
                    .lineLimit(1)
            }
            Spacer(minLength: SeulyLayout.spacingS)
            VStack(alignment: .trailing, spacing: 2) {
                PrivacySensitiveAmount(
                    minorUnits: amountMinor,
                    currency: currency,
                    isHidden: hidesAmount,
                    style: SeulyFont.moneyRow,
                    color: theme.textColor(for: transaction.kind),
                    showSign: transaction.kind == .income,
                    symbolScale: .body
                )
                .lineLimit(1)
                if showsDate && !dynamicTypeSize.isAccessibilitySize {
                    Text(AppFormatters.dayMonth(transaction.effectiveDate))
                        .font(SeulyFont.caption2)
                        .foregroundStyle(theme.textTertiary)
                }
            }
        }
        .frame(minHeight: SeulyLayout.rowHeight)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }

    private var title: String {
        transaction.merchant.isEmpty
            ? transaction.kind.displayName
            : transaction.merchant
    }

    private var contextLine: String {
        let categoryName = category?.localizedName
            ?? transaction.kind.displayName
        guard let account else { return categoryName }
        let dot = L10n.text("separator.dot", table: .shared)
        return "\(categoryName) \(dot) \(account.name)"
    }
}
