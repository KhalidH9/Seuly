import SwiftUI

/// New password and confirmation. The confirmation turns red only once
/// something has been typed into it, never while it is still empty.
struct PasswordRecoveryFormView: View {
    private enum Field {
        case password
        case confirmation
    }

    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: PasswordRecoveryViewModel
    @FocusState private var focusedField: Field?

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
            LabeledFormField(
                L10n.text("recovery.field.password", table: .auth)
            ) {
                SeulyPasswordField(
                    text: $viewModel.password,
                    textContentType: .newPassword,
                    isFocused: focusedField == .password,
                    submitLabel: .next,
                    onSubmit: { focusedField = .confirmation }
                )
                .focused($focusedField, equals: .password)
            }
            LabeledFormField(
                L10n.text("recovery.field.confirmation", table: .auth)
            ) {
                SeulyPasswordField(
                    text: $viewModel.confirmation,
                    textContentType: .newPassword,
                    isFocused: focusedField == .confirmation,
                    hasError: hasMismatch,
                    onSubmit: {
                        Task { await viewModel.updatePassword() }
                    }
                )
                .focused($focusedField, equals: .confirmation)
            }
            PasswordRequirementRow(
                title: L10n.text("password.rule.length", table: .auth),
                isSatisfied: AuthCredentialRules
                    .isValidPassword(viewModel.password)
            )
            if hasMismatch {
                Text(L10n.text("recovery.mismatch", table: .auth))
                    .font(SeulyFont.caption)
                    .foregroundStyle(theme.errorText)
            }
        }
    }

    private var hasMismatch: Bool {
        !viewModel.confirmation.isEmpty
            && viewModel.password != viewModel.confirmation
    }
}
