import SwiftUI

/// One value claim on the welcome page: glyph, headline, and the sentence
/// that makes the headline concrete.
struct OnboardingFeatureRow: View {
    @Environment(\.seulyTheme) private var theme
    let systemImage: String
    let title: String
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: SeulyLayout.spacingM) {
            SeulyIconTile(
                systemImage: systemImage,
                tint: theme.brandPrimary,
                background: theme.brandPrimarySoft
            )
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(SeulyFont.bodyEmphasized)
                    .foregroundStyle(theme.textPrimary)
                Text(message)
                    .font(SeulyFont.subheadline)
                    .foregroundStyle(theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}
