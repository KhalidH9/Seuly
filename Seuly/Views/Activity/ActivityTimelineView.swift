import SwiftUI

/// The transaction timeline as a real list: day sections, sticky headers,
/// swipe actions, and row recycling all come from the platform rather than
/// being approximated inside a scroll view.
struct ActivityTimelineView: View {
    let viewModel: ActivityViewModel
    let onAdd: () -> Void
    let onEdit: (FinancialTransaction) -> Void

    var body: some View {
        List {
            Section {
                ActivitySummaryCard(viewModel: viewModel)
                    .seulyPlainListRow()
            }
            Section {
                ActivityFiltersView(viewModel: viewModel)
                    .seulyPlainListRow()
            }
            if let error = viewModel.errorMessage {
                Section {
                    ErrorBanner(message: error).seulyPlainListRow()
                }
            }
            if viewModel.groups.isEmpty {
                Section {
                    ActivityEmptyState(viewModel: viewModel, onAdd: onAdd)
                        .seulyPlainListRow()
                }
            } else {
                ForEach(viewModel.groups) { group in
                    ActivityDaySection(
                        viewModel: viewModel,
                        group: group,
                        onEdit: onEdit
                    )
                }
            }
        }
        .listStyle(.insetGrouped)
        .listSectionSpacing(SeulyLayout.spacingL)
    }
}
