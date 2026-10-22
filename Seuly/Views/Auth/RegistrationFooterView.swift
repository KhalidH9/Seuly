import SwiftUI

/// Pinned action bar. Continue is prominent on every step and becomes the
/// account-creating action on the last one.
struct RegistrationFooterView: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: AuthViewModel

    var body: some View {
        HStack(spacing: SeulyLayout.spacingM) {
            if !viewModel.isFirstRegistrationStep {
                Button(L10n.text("register.back", table: .auth)) {
                    withAnimation(SeulyMotion.content) {
                        viewModel.retreatRegistration()
                    }
                }
                .buttonStyle(SeulySecondaryButtonStyle())
                .disabled(viewModel.isSubmitting)
            }
            Button {
                Task { await viewModel.advanceRegistration() }
            } label: {
                SeulyButtonLabel(
                    title: continueTitle,
                    isBusy: viewModel.isSubmitting
                )
            }
            .buttonStyle(SeulyPrimaryButtonStyle())
            .disabled(!viewModel.canAdvanceRegistration)
        }
        .padding(.horizontal, SeulyLayout.screenPadding)
        .padding(.vertical, SeulyLayout.spacingM)
        .background(theme.backgroundSecondary)
        .overlay(alignment: .top) {
            Rectangle().fill(theme.divider).frame(height: 0.5)
        }
    }

    private var continueTitle: String {
        L10n.text(
            viewModel.isLastRegistrationStep
                ? "register.action"
                : "register.continue",
            table: .auth
        )
    }
}
