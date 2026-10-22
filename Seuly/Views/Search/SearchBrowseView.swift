import SwiftUI

/// Idle state: browse by kind, then the handful of things most recently
/// touched. Mirrors how a storefront offers categories before a query.
struct SearchBrowseView: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: UniversalSearchViewModel
    let onSelect: (UniversalSearchResult) -> Void

    var body: some View {
        if !viewModel.hasSearchableData {
            UniversalSearchEmptyState(
                hasSearchableData: false,
                onClear: viewModel.clearQuery
            )
        } else {
            List {
                Section {
                    ForEach(viewModel.browsableKinds) { kind in
                        NavigationLink {
                            SearchScopeScreen(
                                viewModel: viewModel,
                                kind: kind,
                                onSelect: onSelect
                            )
                        } label: {
                            SearchBrowseRow(
                                kind: kind,
                                count: viewModel.resultCount(for: kind)
                            )
                        }
                    }
                } header: {
                    Text(L10n.text("search.browse", table: .shared))
                        .font(SeulyFont.footnoteEmphasized)
                        .foregroundStyle(theme.textSecondary)
                }
                Section {
                    ForEach(viewModel.quickAccessResults) { result in
                        UniversalSearchResultRow(
                            result: result,
                            currency: viewModel.currency(for: result.currencyCode),
                            hidesAmount: viewModel.isPrivacyModeEnabled
                        ) {
                            onSelect(result)
                        }
                    }
                } header: {
                    Text(L10n.text("search.latest", table: .shared))
                        .font(SeulyFont.footnoteEmphasized)
                        .foregroundStyle(theme.textSecondary)
                }
            }
            .listStyle(.plain)
        }
    }
}
