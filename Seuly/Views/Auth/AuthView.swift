import SwiftUI

/// Auth entry point. Sign-in is what loads; registration replaces it in place
/// so moving between them reads as one calm screen changing its mind rather
/// than two screens fighting over the same space.
struct AuthView: View {
    @Environment(\.seulyTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: AuthViewModel

    init(viewModel: AuthViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            theme.softBackgroundGradient.ignoresSafeArea()
            switch viewModel.mode {
            case .signIn:
                LoginView(viewModel: viewModel)
                    .transition(transition(isForward: false))
            case .createAccount:
                RegistrationView(viewModel: viewModel)
                    .transition(transition(isForward: true))
            }
        }
        .animation(
            SeulyMotion.respectful(
                SeulyMotion.content,
                reduceMotion: reduceMotion
            ),
            value: viewModel.mode
        )
    }

    private func transition(isForward: Bool) -> AnyTransition {
        guard !reduceMotion else { return .opacity }
        let edge: Edge = isForward ? .trailing : .leading
        return .asymmetric(
            insertion: .move(edge: edge).combined(with: .opacity),
            removal: .opacity
        )
    }
}
