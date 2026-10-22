import SwiftUI

/// Query results, grouped by kind.
struct SearchResultsView: View {
    let viewModel: UniversalSearchViewModel
    let onSelect: (UniversalSearchResult) -> Void

    var body: some View {
        Group {
            if viewModel.sections.isEmpty {
                UniversalSearchEmptyState(
                    hasSearchableData: viewModel.hasSearchableData,
                    onClear: viewModel.clearQuery
                )
            } else {
                List {
                    ForEach(viewModel.sections) { section in
                        UniversalSearchResultsSection(
                            section: section,
                            hidesAmount: viewModel.isPrivacyModeEnabled,
                            currency: viewModel.currency(for:),
                            onSelect: onSelect
                        )
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}
