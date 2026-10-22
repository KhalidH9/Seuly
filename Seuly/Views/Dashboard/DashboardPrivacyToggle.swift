import SwiftUI

/// Privacy switch, styled for the hero gradient. Lives beside the net-worth
/// figure because that is the number people most often want covered.
struct DashboardPrivacyToggle: View {
    @Environment(\.seulyTheme) private var theme
    let isEnabled: Bool
    let toggle: () -> Void

    var body: some View {
        Button(action: toggle) {
            Image(systemName: isEnabled ? "eye.slash.fill" : "eye.fill")
                .font(SeulyFont.subheadlineEmphasized)
                .foregroundStyle(theme.onBrandFill)
                .frame(
                    width: SeulyLayout.minimumTapTarget,
                    height: SeulyLayout.minimumTapTarget
                )
                .background(theme.onBrandFill.opacity(0.16), in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            L10n.text(
                isEnabled ? "balance.show_amounts" : "balance.hide_amounts",
                table: .dashboard
            )
        )
    }
}
