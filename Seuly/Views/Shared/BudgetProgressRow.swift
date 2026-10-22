import SwiftUI

/// Budget line: category, pace copy, spend against limit, and a track whose
/// tint escalates as the limit approaches.
struct BudgetProgressRow: View {
    @Environment(\.seulyTheme) private var theme
    let progress: BudgetProgress
    let currency: CurrencyDefinition?
    let hidesAmount: Bool

    var body: some View {
        VStack(spacing: SeulyLayout.spacingS) {
            HStack(spacing: SeulyLayout.spacingM) {
                SeulyIconTile(
                    systemImage: progress.category.iconKey,
                    tint: categoryColor,
                    background: categoryColor.opacity(0.14),
                    size: SeulyLayout.compactIcon
                )
                VStack(alignment: .leading, spacing: 2) {
                    Text(progress.category.localizedName)
                        .font(SeulyFont.subheadlineEmphasized)
                        .foregroundStyle(theme.textPrimary)
                        .lineLimit(1)
                    Text(paceText)
                        .font(SeulyFont.caption)
                        .foregroundStyle(paceColor)
                }
                Spacer(minLength: SeulyLayout.spacingS)
                VStack(alignment: .trailing, spacing: 1) {
                    PrivacySensitiveAmount(
                        minorUnits: progress.spentMinor,
                        currency: currency,
                        isHidden: hidesAmount,
                        style: SeulyFont.moneyCaption,
                        compact: true,
                        symbolScale: .subheadline
                    )
                    if !hidesAmount {
                        LocalizedInlineValue(
                            "budget.of_limit",
                            table: .shared
                        ) {
                            MoneyAmountText(
                                minorUnits: progress.line.limitMinor,
                                currency: currency,
                                compact: true,
                                symbolScale: .caption2
                            )
                        }
                        .font(SeulyFont.caption2)
                        .foregroundStyle(theme.textTertiary)
                    }
                }
            }
            SeulyProgressBar(progress: progress.fraction, tint: tint)
        }
        .accessibilityElement(children: .combine)
    }

    private var paceText: String {
        progress.fraction >= 1
            ? L10n.text("limit.reached", table: .shared)
            : L10n.format(
                "budget.used",
                table: .shared,
                AppFormatters.integer(Int(progress.fraction * 100))
            )
    }

    private var paceColor: Color {
        progress.fraction >= 1 ? theme.expenseText : theme.textSecondary
    }

    /// The track encodes budget health, not category identity: a category
    /// whose colour role happens to be red must not make an on-track budget
    /// look breached. Identity stays on the glyph tile.
    private var tint: Color {
        if progress.fraction >= 1 { return theme.expense }
        if progress.fraction >= 0.8 { return theme.warning }
        return theme.brandPrimary
    }

    private var categoryColor: Color {
        theme.color(for: progress.category.colorRole)
    }
}
