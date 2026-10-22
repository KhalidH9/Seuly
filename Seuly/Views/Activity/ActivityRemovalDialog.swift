import SwiftUI

struct ActivityRemovalDialog<Content: View>: View {
    @Bindable var viewModel: ActivityViewModel
    private let content: Content

    init(
        viewModel: ActivityViewModel,
        @ViewBuilder content: () -> Content
    ) {
        self.viewModel = viewModel
        self.content = content()
    }

    var body: some View {
        content.confirmationDialog(
            L10n.text("remove.title", table: .activity),
            isPresented: Binding(
                get: { viewModel.deletionCandidate != nil },
                set: {
                    if !$0 { viewModel.deletionCandidate = nil }
                }
            ),
            titleVisibility: .visible
        ) {
            Button(
                L10n.text("remove.confirm", table: .activity),
                role: .destructive
            ) {
                guard let candidate = viewModel.deletionCandidate else {
                    return
                }
                Task { await viewModel.delete(candidate) }
            }
            Button(
                L10n.text("cancel", table: .shared),
                role: .cancel
            ) {
                viewModel.deletionCandidate = nil
            }
        } message: {
            Text(L10n.text("remove.message", table: .activity))
        }
    }
}
