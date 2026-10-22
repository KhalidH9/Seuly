import SwiftUI

/// Registration as three short steps. One question per screen keeps each one
/// answerable at a glance, and the progress header says how much is left.
struct RegistrationView: View {
    @Environment(\.seulyTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Bindable var viewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 0) {
            RegistrationProgressHeader(viewModel: viewModel)
            ScrollView {
                VStack(spacing: SeulyLayout.spacingL) {
                    stepContent
                        .seulyTransition(reduceMotion)
                    if let message = viewModel.errorMessage {
                        ErrorBanner(message: message)
                    }
                }
                .padding(.horizontal, SeulyLayout.screenPadding)
                .padding(.top, SeulyLayout.sectionSpacing)
                .padding(.bottom, SeulyLayout.spacingXL)
                .animation(
                    SeulyMotion.respectful(
                        SeulyMotion.content,
                        reduceMotion: reduceMotion
                    ),
                    value: viewModel.registrationStep
                )
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            RegistrationFooterView(viewModel: viewModel)
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.currentRegistrationStep {
        case .name:
            RegistrationNameStepView(viewModel: viewModel)
        case .email:
            RegistrationEmailStepView(viewModel: viewModel)
        case .password:
            RegistrationPasswordStepView(viewModel: viewModel)
        }
    }
}
