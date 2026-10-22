import SwiftUI

/// Monogram avatar on the brand gradient. Used at hero size in the profile
/// header and at control size in the dashboard toolbar.
struct ProfileAvatarView: View {
    @Environment(\.seulyTheme) private var theme
    let initials: String
    var size: CGFloat = 72

    var body: some View {
        Text(initials)
            .font(.system(size: size * 0.38, weight: .semibold))
            .foregroundStyle(theme.onBrandFill)
            .frame(width: size, height: size)
            .background(theme.primaryGradient, in: Circle())
            .overlay {
                Circle().strokeBorder(
                    theme.onBrandFill.opacity(0.18),
                    lineWidth: 1
                )
            }
            .accessibilityHidden(true)
    }
}
