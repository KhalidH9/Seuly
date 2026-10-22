import SwiftUI

/// Goal card: identity, ring of progress, saved against target, and the
/// contribute affordance when one is offered.
struct GoalProgressCard: View {
    @Environment(\.seulyTheme) private var theme
    let goal: SavingsGoal
    let currency: CurrencyDefinition?
    let hidesAmount: Bool
    var onContribute: (() -> Void)?

    var body: some View {
        SeulyCard {
            VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
                HStack(spacing: SeulyLayout.spacingM) {
                    SeulyIconTile(
                        systemImage: goal.iconKey,
                        tint: theme.color(for: goal.colorRole),
                        background: theme.softColor(for: goal.colorRole),
                        size: SeulyLayout.minimumTapTarget
                    )
                    VStack(alignment: .leading, spacing: 2) {
                        Text(goal.name)
                            .font(SeulyFont.cardTitle)
                            .foregroundStyle(theme.textPrimary)
                            .lineLimit(1)
                        if let date = goal.targetDate {
                            Text(
                                L10n.format(
                                    "goal.target_date",
                                    table: .shared,
                                    AppFormatters.monthYear(date)
                                )
                            )
                            .font(SeulyFont.caption)
                            .foregroundStyle(theme.textSecondary)
                        }
                    }
                    Spacer(minLength: SeulyLayout.spacingS)
                    StatusPill(title: progressText, kind: .neutral)
                }
                SeulyProgressBar(
                    progress: goal.progress,
                    tint: theme.color(for: goal.colorRole),
                    height: 9
                )
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 1) {
                        PrivacySensitiveAmount(
                            minorUnits: goal.progressMinor,
                            currency: currency,
                            isHidden: hidesAmount,
                            style: SeulyFont.moneySection,
                            symbolScale: .title3
                        )
                        if !hidesAmount {
                            LocalizedInlineValue(
                                "budget.of_limit",
                                table: .shared
                            ) {
                                MoneyAmountText(
                                    minorUnits: goal.targetMinor,
                                    currency: currency,
                                    compact: true,
                                    symbolScale: .caption2
                                )
                            }
                            .font(SeulyFont.caption)
                            .foregroundStyle(theme.textTertiary)
                        }
                    }
                    Spacer(minLength: SeulyLayout.spacingS)
                    if let onContribute {
                        Button(
                            L10n.text("add", table: .shared),
                            action: onContribute
                        )
                        .buttonStyle(SeulySecondaryButtonStyle())
                    }
                }
            }
        }
    }

    private var progressText: String {
        L10n.format(
            "goal.progress",
            table: .shared,
            AppFormatters.integer(Int(goal.progress * 100))
        )
    }
}
