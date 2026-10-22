import SwiftUI

/// Standard settings row: tinted glyph, title, optional detail value. The
/// disclosure chevron is left to `NavigationLink`.
struct ProfileNavigationRow: View {
    @Environment(\.seulyTheme) private var theme
    let systemImage: String
    let tint: Color
    let title: String
    var subtitle: String?
    var value: String?
    var forcesValueDirection = false

    var body: some View {
        HStack(spacing: SeulyLayout.spacingM) {
            SeulyIconTile(
                systemImage: systemImage,
                tint: tint,
                background: tint.opacity(0.14),
                size: SeulyLayout.compactIcon
            )
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(SeulyFont.body)
                    .foregroundStyle(theme.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(SeulyFont.caption)
                        .foregroundStyle(theme.textSecondary)
                }
            }
            Spacer(minLength: SeulyLayout.spacingS)
            if let value {
                valueLabel(value)
            }
        }
        .frame(minHeight: SeulyLayout.minimumTapTarget)
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private func valueLabel(_ value: String) -> some View {
        let label = Text(value)
            .font(SeulyFont.subheadline)
            .foregroundStyle(theme.textSecondary)
            .lineLimit(1)
        if forcesValueDirection {
            SeulyNumeralText { label }
        } else {
            label
        }
    }
}
