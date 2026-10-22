import SwiftUI

struct RegistrationNameStepView: View {
    @Bindable var viewModel: AuthViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingXL) {
            RegistrationStepHeader(
                title: L10n.text("register.name.title", table: .auth),
                message: L10n.text("register.name.message", table: .auth)
            )
            SeulyCard {
                LabeledFormField(L10n.text("field.name", table: .auth)) {
                    TextField(
                        L10n.text("field.name_placeholder", table: .auth),
                        text: $viewModel.displayName
                    )
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                    .submitLabel(.next)
                    .focused($isFocused)
                    .seulyField(isFocused: isFocused)
                    .onSubmit { Task { await viewModel.advanceRegistration() } }
                }
            }
        }
        .onAppear { isFocused = true }
    }
}
