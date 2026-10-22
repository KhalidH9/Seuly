import SwiftUI

struct RootView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: AppViewModel

    init(viewModel: AppViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        RootRouteView(viewModel: viewModel)
            .animation(
                SeulyMotion.respectful(
                    SeulyMotion.route,
                    reduceMotion: reduceMotion
                ),
                value: viewModel.route
            )
            .task { await viewModel.start() }
            .onChange(
                of: viewModel.currentUserID,
                initial: true
            ) { _, userID in
                viewModel.prepareForUserTransition(to: userID)
            }
            .task(id: viewModel.currentUserID) {
                await viewModel.synchronizeWorkspace()
            }
            .onChange(of: scenePhase) { _, phase in
                guard phase == .active else { return }
                Task { await viewModel.applicationDidBecomeActive() }
            }
            .onOpenURL { url in
                Task { await viewModel.handle(url: url) }
            }
            .alert(
                L10n.text("callback.title", table: .app),
                isPresented: callbackErrorBinding
            ) {
                Button(
                    L10n.text("callback.ok", table: .app),
                    action: viewModel.dismissCallbackError
                )
            } message: {
                Text(
                    viewModel.callbackErrorMessage
                        ?? L10n.text("callback.fallback", table: .app)
                )
            }
    }

    private var callbackErrorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.callbackErrorMessage != nil },
            set: { if !$0 { viewModel.dismissCallbackError() } }
        )
    }
}
