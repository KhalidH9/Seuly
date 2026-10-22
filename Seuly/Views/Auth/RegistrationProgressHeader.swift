import SwiftUI

/// Progress chrome for registration, plus the way back to sign-in.
struct RegistrationProgressHeader: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: AuthViewModel

    var body: some View {
        VStack(spacing: SeulyLayout.spacingM) {
            HStack {
                Button {
                    viewModel.changeMode(.signIn)
                } label: {
                    Label(
                        L10n.text("register.have_account", table: .auth),
                        systemImage: "chevron.backward"
                    )
                    .labelStyle(.iconOnly)
                    .font(SeulyFont.bodyEmphasized)
                    .foregroundStyle(theme.brandPrimary)
                    .frame(
                        width: SeulyLayout.minimumTapTarget,
                        height: SeulyLayout.minimumTapTarget
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(
                    L10n.text("register.have_account", table: .auth)
                )
                Spacer()
                SeulyMark(size: 30)
                Spacer()
                Text(progressText)
                    .font(SeulyFont.captionEmphasized)
                    .foregroundStyle(theme.textSecondary)
                    .frame(width: SeulyLayout.minimumTapTarget * 1.6)
            }
            track
        }
        .padding(.horizontal, SeulyLayout.screenPadding)
        .padding(.bottom, SeulyLayout.spacingL)
        .background(theme.backgroundSecondary)
    }

    private var track: some View {
        HStack(spacing: 5) {
            ForEach(0..<AuthViewModel.registrationStepCount, id: \.self) {
                index in
                Capsule(style: .continuous)
                    .fill(
                        index <= viewModel.registrationStep
                            ? theme.brandPrimary
                            : theme.fillTertiary
                    )
                    .frame(height: 5)
            }
        }
        .animation(SeulyMotion.content, value: viewModel.registrationStep)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(progressText)
    }

    private var progressText: String {
        L10n.format(
            "register.progress",
            table: .auth,
            viewModel.registrationStep + 1,
            AuthViewModel.registrationStepCount
        )
    }
}
