import SwiftUI

/// Title and explanation for a registration step.
struct RegistrationStepHeader: View {
    @Environment(\.seulyTheme) private var theme
    let title: String
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingS) {
            Text(title)
                .font(SeulyFont.heroTitle)
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
