import SwiftUI

/// Setup flow. A welcome page runs ahead of the three saved steps; whether it
/// has been passed is view state only, so the persisted step count is
/// untouched.
struct OnboardingView: View {
    @Environment(\.seulyTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: OnboardingViewModel
    @State private var hasStarted = false

    init(viewModel: OnboardingViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            if hasStarted {
                setupFlow
            } else {
                OnboardingWelcomeView {
                    withAnimation(
                        SeulyMotion.respectful(
                            SeulyMotion.route,
                            reduceMotion: reduceMotion
                        )
                    ) { hasStarted = true }
                }
            }
        }
        .background(theme.backgroundPrimary.ignoresSafeArea())
    }

    private var setupFlow: some View {
        VStack(spacing: 0) {
            OnboardingHeaderView(viewModel: viewModel)
            ScrollView {
                VStack(spacing: SeulyLayout.sectionSpacing) {
                    stepContent
                        .seulyTransition(reduceMotion)
                    if let error = viewModel.errorMessage {
                        ErrorBanner(message: error)
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
                    value: viewModel.step
                )
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            OnboardingFooterView(viewModel: viewModel)
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.step {
        case 0:
            OnboardingIdentityStepView(viewModel: viewModel)
        case 1:
            OnboardingAccountStepView(viewModel: viewModel)
        default:
            OnboardingPlanStepView(viewModel: viewModel)
        }
    }
}
