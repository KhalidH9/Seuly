import SwiftUI

/// Says what the app does before asking for anything. Three claims, each tied
/// to something the app actually shows later.
struct OnboardingWelcomeView: View {
    @Environment(\.seulyTheme) private var theme
    let start: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: SeulyLayout.sectionSpacing) {
                    Spacer(minLength: SeulyLayout.spacingXL)
                    SeulyLogo(size: 88)
                    VStack(spacing: SeulyLayout.spacingS) {
                        Text(L10n.text("welcome.title", table: .onboarding))
                            .font(SeulyFont.screenTitle)
                            .foregroundStyle(theme.textPrimary)
                        Text(L10n.text("welcome.message", table: .onboarding))
                            .font(SeulyFont.body)
                            .foregroundStyle(theme.textSecondary)
                    }
                    .multilineTextAlignment(.center)
                    features
                }
                .padding(.horizontal, SeulyLayout.screenPadding)
                .padding(.bottom, SeulyLayout.spacingXL)
            }
            .scrollIndicators(.hidden)
            footer
        }
    }

    private var features: some View {
        VStack(spacing: SeulyLayout.spacingM) {
            OnboardingFeatureRow(
                systemImage: "drop.fill",
                title: L10n.text("welcome.feature.safe.title", table: .onboarding),
                message: L10n.text("welcome.feature.safe.message", table: .onboarding)
            )
            OnboardingFeatureRow(
                systemImage: "calendar.badge.clock",
                title: L10n.text("welcome.feature.upcoming.title", table: .onboarding),
                message: L10n.text("welcome.feature.upcoming.message", table: .onboarding)
            )
            OnboardingFeatureRow(
                systemImage: "eye.slash.fill",
                title: L10n.text("welcome.feature.privacy.title", table: .onboarding),
                message: L10n.text("welcome.feature.privacy.message", table: .onboarding)
            )
        }
    }

    private var footer: some View {
        VStack(spacing: SeulyLayout.spacingS) {
            Button(L10n.text("welcome.action", table: .onboarding), action: start)
                .buttonStyle(SeulyPrimaryButtonStyle())
            Text(L10n.text("welcome.footnote", table: .onboarding))
                .font(SeulyFont.caption)
                .foregroundStyle(theme.textTertiary)
        }
        .padding(.horizontal, SeulyLayout.screenPadding)
        .padding(.top, SeulyLayout.spacingM)
        .padding(.bottom, SeulyLayout.spacingS)
        .background(theme.backgroundSecondary)
    }
}
