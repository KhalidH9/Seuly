import SwiftUI

/// The search tab, kept structurally apart from the content tabs: its own
/// stack, its own plain-list chrome, and a browse state that stands in for
/// results before anything is typed.
struct UniversalSearchView: View {
    @Environment(\.seulyTheme) private var theme
    @State private var viewModel: UniversalSearchViewModel
    let onSelect: (UniversalSearchResult) -> Void

    init(
        viewModel: UniversalSearchViewModel,
        onSelect: @escaping (UniversalSearchResult) -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onSelect = onSelect
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isShowingRecent {
                    SearchBrowseView(
                        viewModel: viewModel,
                        onSelect: onSelect
                    )
                } else {
                    SearchResultsView(
                        viewModel: viewModel,
                        onSelect: onSelect
                    )
                }
            }
            .navigationTitle(L10n.text("search.title", table: .shared))
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $viewModel.query,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text(L10n.text("search.prompt", table: .shared))
            )
            .background(theme.backgroundPrimary.ignoresSafeArea())
            .toolbarBackground(
                theme.navigationBackground,
                for: .navigationBar
            )
        }
    }
}
