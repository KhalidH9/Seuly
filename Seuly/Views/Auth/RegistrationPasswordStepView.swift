import SwiftUI

struct RegistrationPasswordStepView: View {
    @Bindable var viewModel: AuthViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingXL) {
            RegistrationStepHeader(
                title: L10n.text("register.password.title", table: .auth),
                message: L10n.text("register.password.message", table: .auth)
            )
            SeulyCard {
                VStack(alignment: .leading, spacing: SeulyLayout.spacingM) {
                    LabeledFormField(
                        L10n.text("field.password", table: .auth)
                    ) {
                        SeulyPasswordField(
                            text: $viewModel.password,
                            textContentType: .newPassword,
                            isFocused: isFocused,
                            onSubmit: {
                                Task { await viewModel.advanceRegistration() }
                            }
                        )
                        .focused($isFocused)
                    }
                    PasswordRequirementRow(
                        title: L10n.text("password.rule.length", table: .auth),
                        isSatisfied: viewModel.isPasswordValid
                    )
                }
            }
        }
        .onAppear { isFocused = true }
    }
}
