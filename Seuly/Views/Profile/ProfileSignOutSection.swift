import SwiftUI

/// Sign out reads as a plain destructive row, the placement the platform
/// uses for the same action, and always confirms first.
struct ProfileSignOutSection: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: SettingsViewModel
    let confirm: () -> Void

    var body: some View {
        Section {
            Button(role: .destructive) {
                viewModel.showsSignOutConfirmation = true
            } label: {
                HStack(spacing: SeulyLayout.spacingS) {
                    if viewModel.isSigningOut {
                        SeulyActivityIndicator(size: 20, tint: theme.expense)
                    }
                    Text(L10n.text("sign_out.action", table: .settings))
                        .font(SeulyFont.body)
                    Spacer()
                }
                .frame(minHeight: SeulyLayout.minimumTapTarget)
            }
            .disabled(viewModel.isSigningOut)
        } footer: {
            Text(L10n.text("sign_out.footer", table: .settings))
        }
        .confirmationDialog(
            L10n.text("sign_out.confirmation", table: .settings),
            isPresented: $viewModel.showsSignOutConfirmation,
            titleVisibility: .visible
        ) {
            Button(
                L10n.text("sign_out.action", table: .settings),
                role: .destructive,
                action: confirm
            )
            Button(L10n.text("cancel", table: .shared), role: .cancel) {}
        }
    }
}
