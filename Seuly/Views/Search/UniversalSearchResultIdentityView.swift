import SwiftUI

struct UniversalSearchResultIdentityView: View {
    @Environment(\.seulyTheme) private var theme
    let result: UniversalSearchResult

    var body: some View {
        HStack(spacing: SeulyLayout.spacingM) {
            SeulyIconTile(
                systemImage: safeSystemImage,
                tint: theme.brandPrimary,
                background: theme.brandPrimarySoft
            )
            VStack(alignment: .leading, spacing: 2) {
                Text(result.title)
                    .font(SeulyFont.bodyEmphasized)
                    .foregroundStyle(theme.textPrimary)
                    .lineLimit(1)
                Text(result.subtitle)
                    .font(SeulyFont.caption)
                    .foregroundStyle(theme.textSecondary)
                    .lineLimit(1)
                if !result.metadata.isEmpty {
                    Text(result.metadata)
                        .font(SeulyFont.caption2)
                        .foregroundStyle(theme.textTertiary)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var safeSystemImage: String {
        result.systemImage.isEmpty
            ? result.kind.systemImage
            : result.systemImage
    }
}
