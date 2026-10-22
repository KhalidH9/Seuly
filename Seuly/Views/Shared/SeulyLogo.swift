import SwiftUI

/// Brand lockup: the monogram, optionally followed by the wordmark. Drawn
/// without a background tile so the mark reads as part of the page.
struct SeulyLogo: View {
    @Environment(\.seulyTheme) private var theme
    var size: CGFloat = 64
    var showsWordmark = false
    var tint: Color?

    var body: some View {
        HStack(spacing: size * 0.18) {
            SeulyMark(size: size, tint: tint)
            if showsWordmark {
                Text(L10n.text("brand.name", table: .shared))
                    .font(.system(size: size * 0.46, weight: .bold))
                    .foregroundStyle(tint ?? theme.textPrimary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.text("brand.name", table: .shared))
    }
}
