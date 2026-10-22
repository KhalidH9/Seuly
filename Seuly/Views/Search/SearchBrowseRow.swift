import SwiftUI

/// A browse destination: the kind, and how many of it there are.
struct SearchBrowseRow: View {
    @Environment(\.seulyTheme) private var theme
    let kind: UniversalSearchKind
    let count: Int

    var body: some View {
        HStack(spacing: SeulyLayout.spacingM) {
            SeulyIconTile(
                systemImage: kind.systemImage,
                tint: theme.brandPrimary,
                background: theme.brandPrimarySoft
            )
            Text(kind.displayName)
                .font(SeulyFont.body)
                .foregroundStyle(theme.textPrimary)
            Spacer(minLength: SeulyLayout.spacingS)
            Text(AppFormatters.integer(count))
                .font(SeulyFont.moneyCaption)
                .foregroundStyle(theme.textSecondary)
        }
        .frame(minHeight: SeulyLayout.rowHeight)
        .accessibilityElement(children: .combine)
    }
}
