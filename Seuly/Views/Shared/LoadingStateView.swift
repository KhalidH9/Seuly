import SwiftUI

/// Full-page wait. Used while the workspace loads.
struct LoadingStateView: View {
    @Environment(\.seulyTheme) private var theme

    var body: some View {
        VStack(spacing: SeulyLayout.spacingL) {
            SeulyActivityIndicator(size: 52)
            Text(L10n.text("loading", table: .shared))
                .font(SeulyFont.subheadline)
                .foregroundStyle(theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.backgroundPrimary.ignoresSafeArea())
        .accessibilityElement(children: .combine)
    }
}
