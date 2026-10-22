import SwiftUI

struct OnboardingStepIntroductionView: View {
    @Environment(\.seulyTheme) private var theme
    let eyebrow: String
    let title: String
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingS) {
            Text(eyebrow)
                .seulyEyebrow()
                .foregroundStyle(theme.brandPrimary)
            Text(title)
                .font(SeulyFont.screenTitle)
                .foregroundStyle(theme.textPrimary)
            Text(message)
                .font(SeulyFont.body)
                .foregroundStyle(theme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}
