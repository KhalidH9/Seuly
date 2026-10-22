import SwiftUI

/// Money pulse: a single word for the month's state, backed by the reason it
/// was reached. The tinted dot repeats the state so colour is never the only
/// carrier.
struct MoneyPulseCard: View {
    @Environment(\.seulyTheme) private var theme
    let pulse: MoneyPulse

    var body: some View {
        SeulyCard {
            VStack(alignment: .leading, spacing: SeulyLayout.spacingM) {
                HStack(alignment: .top) {
                    SeulyIconTile(
                        systemImage: pulseIcon,
                        tint: theme.textColor(for: pulse),
                        background: theme.softColor(for: pulse),
                        size: SeulyLayout.compactIcon
                    )
                    Spacer()
                    Circle()
                        .fill(theme.color(for: pulse))
                        .frame(width: 8, height: 8)
                        .padding(SeulyLayout.spacingS)
                }
                Text(L10n.text("money_pulse.title", table: .dashboard))
                    .font(SeulyFont.footnoteEmphasized)
                    .foregroundStyle(theme.textSecondary)
                Text(pulse.title)
                    .font(SeulyFont.sectionTitle)
                    .foregroundStyle(theme.textColor(for: pulse))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(pulse.reason)
                    .font(SeulyFont.caption)
                    .foregroundStyle(theme.textSecondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }

    private var pulseIcon: String {
        switch pulse {
        case .calm: "checkmark.circle.fill"
        case .watch: "eye.fill"
        case .tight: "exclamationmark.triangle.fill"
        }
    }
}
