import SwiftUI

/// Everything of one kind, pushed from the browse list.
struct SearchScopeScreen: View {
    let viewModel: UniversalSearchViewModel
    let kind: UniversalSearchKind
    let onSelect: (UniversalSearchResult) -> Void

    var body: some View {
        List {
            ForEach(viewModel.results(for: kind)) { result in
                UniversalSearchResultRow(
                    result: result,
                    currency: viewModel.currency(for: result.currencyCode),
                    hidesAmount: viewModel.isPrivacyModeEnabled
                ) {
                    onSelect(result)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(kind.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
