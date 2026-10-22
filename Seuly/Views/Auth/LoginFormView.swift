import SwiftUI

/// Sign-in fields and actions, grouped on one card.
struct LoginFormView: View {
    private enum Field {
        case email
        case password
    }

    @Bindable var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?

    var body: some View {
        VStack(spacing: SeulyLayout.spacingL) {
            SeulyCard {
                VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
                    LabeledFormField(L10n.text("field.email", table: .auth)) {
                        SeulyEmailField(
                            text: $viewModel.email,
                            isFocused: focusedField == .email
                        ) {
                            focusedField = .password
                        }
                        .focused($focusedField, equals: .email)
                    }
                    LabeledFormField(
                        L10n.text("field.password", table: .auth)
                    ) {
                        SeulyPasswordField(
                            text: $viewModel.password,
                            isFocused: focusedField == .password,
                            onSubmit: submit
                        )
                        .focused($focusedField, equals: .password)
                    }
                    forgotPasswordButton
                }
            }
            if let message = viewModel.errorMessage {
                ErrorBanner(message: message)
            }
            if let notice = viewModel.noticeMessage {
                AuthNoticeBanner(message: notice)
            }
            submitButton
        }
    }

    private var forgotPasswordButton: some View {
        Button(L10n.text("action.forgot_password", table: .auth)) {
            Task { await viewModel.resetPassword() }
        }
        .buttonStyle(SeulyTertiaryButtonStyle())
        .disabled(viewModel.isSubmitting)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var submitButton: some View {
        Button(action: submit) {
            SeulyButtonLabel(
                title: L10n.text("login.action", table: .auth),
                isBusy: viewModel.isSubmitting
            )
        }
        .buttonStyle(SeulyPrimaryButtonStyle())
        .disabled(!viewModel.canSubmit)
    }

    private func submit() {
        Task { await viewModel.submit() }
    }
}
