import SwiftUI

/// Sign-in. Mark, one line of welcome, two fields, one prominent action, and
/// the way out to registration. Nothing sits below the form.
struct LoginView: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: AuthViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: SeulyLayout.sectionSpacing) {
                Spacer(minLength: 40)
                header
                LoginFormView(viewModel: viewModel)
                createAccountButton
            }
            .padding(.horizontal, SeulyLayout.screenPadding)
            .padding(.bottom, SeulyLayout.sectionSpacing)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
    }

    private var header: some View {
        VStack(spacing: SeulyLayout.spacingL) {
            SeulyMark(size: 64)
            VStack(spacing: SeulyLayout.spacingXS) {
                Text(L10n.text("login.title", table: .auth))
                    .font(SeulyFont.screenTitle)
                    .foregroundStyle(theme.textPrimary)
                Text(L10n.text("login.message", table: .auth))
                    .font(SeulyFont.subheadline)
                    .foregroundStyle(theme.textSecondary)
            }
            .multilineTextAlignment(.center)
        }
        .accessibilityElement(children: .combine)
    }

    private var createAccountButton: some View {
        Button {
            viewModel.changeMode(.createAccount)
        } label: {
            HStack(spacing: SeulyLayout.spacingXS) {
                Text(L10n.text("login.no_account", table: .auth))
                    .foregroundStyle(theme.textSecondary)
                Text(L10n.text("register.action", table: .auth))
                    .foregroundStyle(theme.brandPrimary)
                    .fontWeight(.semibold)
            }
            .font(SeulyFont.subheadline)
            .frame(minHeight: SeulyLayout.minimumTapTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isSubmitting)
    }
}
