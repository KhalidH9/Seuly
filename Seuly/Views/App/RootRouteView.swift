import SwiftUI

/// Renders the destination for the current app route. Split out from
/// `RootView` so lifecycle wiring and route rendering stay separately legible.
struct RootRouteView: View {
    let viewModel: AppViewModel

    @ViewBuilder
    var body: some View {
        switch viewModel.route {
        case .configurationRequired:
            ConfigurationRequiredView(
                message: viewModel.configurationMessage
                    ?? L10n.text("configuration.fallback", table: .app)
            )
        case .launching:
            SplashView()
        case .loadingWorkspace:
            LoadingStateView()
        case .authentication:
            if let child = viewModel.authViewModel {
                AuthView(viewModel: child)
            } else {
                LoadingStateView()
            }
        case .onboarding:
            if let child = viewModel.onboardingViewModel {
                OnboardingView(viewModel: child)
            } else {
                LoadingStateView()
            }
        case .passwordRecovery:
            if let child = viewModel.passwordRecoveryViewModel {
                PasswordRecoveryView(viewModel: child)
            } else {
                LoadingStateView()
            }
        case .main:
            if let child = viewModel.mainTabViewModel {
                MainTabView(viewModel: child)
            } else {
                LoadingStateView()
            }
        case .unavailable(let message):
            WorkspaceUnavailableView(
                message: message,
                retry: { Task { await viewModel.retryWorkspace() } }
            )
        }
    }
}
