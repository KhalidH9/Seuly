import SwiftUI

/// Live preview at the top of a create or edit form: shows the row the user
/// is about to produce, so the icon and colour choices have a consequence.
struct EntityPreviewCard: View {
    @Environment(\.seulyTheme) private var theme
    let systemImage: String
    let colorRole: ColorRole
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: SeulyLayout.spacingM) {
            SeulyIconTile(
                systemImage: systemImage,
                tint: theme.color(for: colorRole),
                background: theme.softColor(for: colorRole),
                size: SeulyLayout.prominentIcon
            )
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(SeulyFont.cardTitle)
                    .foregroundStyle(theme.textPrimary)
                    .lineLimit(2)
                Text(subtitle)
                    .font(SeulyFont.subheadline)
                    .foregroundStyle(theme.textSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(SeulyLayout.cardPadding)
        .background(
            theme.surfacePrimary,
            in: RoundedRectangle(
                cornerRadius: SeulyLayout.cardRadius,
                style: .continuous
            )
        )
        .animation(SeulyMotion.interactive, value: colorRole)
        .accessibilityElement(children: .combine)
    }
}
