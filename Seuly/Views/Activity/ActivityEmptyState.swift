import SwiftUI

/// Two distinct empty states: nothing recorded yet, versus nothing matching
/// the current filters. The action differs accordingly.
struct ActivityEmptyState: View {
    let viewModel: ActivityViewModel
    let onAdd: () -> Void

    var body: some View {
        EmptyStateView(
            systemImage: viewModel.hasActiveFilters
                ? "line.3.horizontal.decrease.circle"
                : "arrow.left.arrow.right.circle",
            title: localized("title"),
            message: localized("message"),
            actionTitle: localized("action")
        ) {
            if viewModel.hasActiveFilters {
                viewModel.clearFilters()
            } else {
                onAdd()
            }
        }
    }

    private func localized(_ suffix: String) -> String {
        L10n.text(
            viewModel.hasActiveFilters
                ? "empty.filtered.\(suffix)"
                : "empty.initial.\(suffix)",
            table: .activity
        )
    }
}
