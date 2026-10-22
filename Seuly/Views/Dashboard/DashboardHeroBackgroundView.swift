import SwiftUI

/// Hero backdrop: the brand gradient with two soft geometric accents placed
/// off the trailing edge so they never sit under the numbers.
struct DashboardHeroBackgroundView: View {
    @Environment(\.seulyTheme) private var theme

    var body: some View {
        ZStack {
            theme.primaryGradient
            Circle()
                .fill(theme.onBrandFill.opacity(0.09))
                .frame(width: 190, height: 190)
                .offset(x: 130, y: -80)
            Circle()
                .strokeBorder(theme.onBrandFill.opacity(0.1), lineWidth: 24)
                .frame(width: 230, height: 230)
                .offset(x: 150, y: 110)
        }
        .clipped()
        .accessibilityHidden(true)
    }
}
