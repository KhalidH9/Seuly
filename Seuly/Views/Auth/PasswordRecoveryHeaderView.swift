import SwiftUI

struct PasswordRecoveryHeaderView: View {
    @Environment(\.seulyTheme) private var theme

    var body: some View {
        VStack(spacing: SeulyLayout.spacingL) {
            SeulyMark(size: 56)
            VStack(spacing: SeulyLayout.spacingXS) {
                Text(L10n.text("recovery.header.title", table: .auth))
                    .font(SeulyFont.heroTitle)
                    .foregroundStyle(theme.textPrimary)
                Text(L10n.text("recovery.header.message", table: .auth))
                    .font(SeulyFont.subheadline)
                    .foregroundStyle(theme.textSecondary)
            }
            .multilineTextAlignment(.center)
        }
        .accessibilityElement(children: .combine)
    }
}
