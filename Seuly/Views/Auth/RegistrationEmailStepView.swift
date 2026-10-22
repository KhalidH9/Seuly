import SwiftUI

struct RegistrationEmailStepView: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: AuthViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingXL) {
            RegistrationStepHeader(
                title: L10n.text("register.email.title", table: .auth),
                message: L10n.text("register.email.message", table: .auth)
            )
            SeulyCard {
                VStack(alignment: .leading, spacing: SeulyLayout.spacingS) {
                    LabeledFormField(L10n.text("field.email", table: .auth)) {
                        SeulyEmailField(
                            text: $viewModel.email,
                            isFocused: isFocused,
                            hasError: showsError
                        ) {
                            Task { await viewModel.advanceRegistration() }
                        }
                        .focused($isFocused)
                    }
                    if showsError {
                        Text(L10n.text("validation.email", table: .auth))
                            .font(SeulyFont.caption)
                            .foregroundStyle(theme.errorText)
                    }
                }
            }
        }
        .onAppear { isFocused = true }
    }

    /// Only complain once there is something to complain about: an empty field
    /// is incomplete, not wrong.
    private var showsError: Bool {
        !viewModel.email.isEmpty && !viewModel.isEmailValid
    }
}
