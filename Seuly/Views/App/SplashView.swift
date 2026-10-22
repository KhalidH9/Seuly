import SwiftUI

/// First frame. Its background matches the static launch screen colour, so
/// the mark appears to settle onto a page that was already there rather than
/// replacing one screen with another.
struct SplashView: View {
    @Environment(\.seulyTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var hasSettled = false
    @State private var showsActivity = false

    var body: some View {
        VStack(spacing: SeulyLayout.spacingL) {
            Spacer()
            SeulyLogo(size: 96)
                .scaleEffect(hasSettled || reduceMotion ? 1 : 0.86)
                .opacity(hasSettled || reduceMotion ? 1 : 0)
            VStack(spacing: 6) {
                Text(L10n.text("brand.name", table: .shared))
                    .font(SeulyFont.heroTitle)
                    .foregroundStyle(theme.textPrimary)
                Text(L10n.text("brand.tagline", table: .shared))
                    .font(SeulyFont.subheadline)
                    .foregroundStyle(theme.textSecondary)
            }
            .opacity(hasSettled || reduceMotion ? 1 : 0)
            Spacer()
            SeulyActivityIndicator(size: 30)
                .opacity(showsActivity ? 1 : 0)
                .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.backgroundPrimary.ignoresSafeArea())
        .task { await reveal() }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.text("brand.name", table: .shared))
    }

    /// The indicator waits out a short grace period so a fast launch never
    /// flashes a spinner the user cannot read.
    private func reveal() async {
        withAnimation(
            SeulyMotion.respectful(
                SeulyMotion.emphasis,
                reduceMotion: reduceMotion
            )
        ) { hasSettled = true }
        try? await Task.sleep(for: .milliseconds(600))
        withAnimation(SeulyMotion.content) { showsActivity = true }
    }
}
