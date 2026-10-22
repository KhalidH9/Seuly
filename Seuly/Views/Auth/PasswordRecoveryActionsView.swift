import SwiftUI

struct PasswordRecoveryActionsView: View {
    @Bindable var viewModel: PasswordRecoveryViewModel

    var body: some View {
        VStack(spacing: SeulyLayout.spacingM) {
            if let error = viewModel.errorMessage {
                ErrorBanner(message: error)
            }
            Button {
                Task { await viewModel.updatePassword() }
            } label: {
                SeulyButtonLabel(
                    title: L10n.text("recovery.action.update", table: .auth),
                    isBusy: viewModel.isSubmitting
                )
            }
            .buttonStyle(SeulyPrimaryButtonStyle())
            .disabled(!viewModel.canSubmit)
            Button(L10n.text("recovery.action.cancel", table: .auth)) {
                Task { await viewModel.cancel() }
            }
            .buttonStyle(SeulyTertiaryButtonStyle())
            .disabled(viewModel.isSubmitting)
        }
    }
}
