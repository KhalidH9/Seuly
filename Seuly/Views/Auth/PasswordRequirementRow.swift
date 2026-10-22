import SwiftUI

/// A single password rule with its live pass state, so the requirement is
/// answered as it is typed instead of after a failed submit.
struct PasswordRequirementRow: View {
    @Environment(\.seulyTheme) private var theme
    let title: String
    let isSatisfied: Bool

    var body: some View {
        HStack(spacing: SeulyLayout.spacingS) {
            Image(
                systemName: isSatisfied
                    ? "checkmark.circle.fill"
                    : "circle"
            )
            .font(SeulyFont.subheadline)
            .foregroundStyle(isSatisfied ? theme.success : theme.textTertiary)
            Text(title)
                .font(SeulyFont.caption)
                .foregroundStyle(
                    isSatisfied ? theme.textSecondary : theme.textTertiary
                )
            Spacer(minLength: 0)
        }
        .animation(SeulyMotion.interactive, value: isSatisfied)
        .accessibilityElement(children: .combine)
        .accessibilityValue(
            L10n.text(
                isSatisfied ? "password.rule.met" : "password.rule.unmet",
                table: .auth
            )
        )
    }
}
