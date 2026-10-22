import SwiftUI

/// Distinguishes "nothing matched" from "nothing to search yet", because only
/// the first one has an action worth offering.
struct UniversalSearchEmptyState: View {
    let hasSearchableData: Bool
    let onClear: () -> Void

    var body: some View {
        EmptyStateView(
            systemImage: hasSearchableData ? "magnifyingglass" : "tray",
            title: localized("title"),
            message: localized("message"),
            actionTitle: hasSearchableData
                ? L10n.text("search.empty.no_results.action", table: .shared)
                : nil,
            action: hasSearchableData ? onClear : nil
        )
    }

    private func localized(_ suffix: String) -> String {
        L10n.text(
            hasSearchableData
                ? "search.empty.no_results.\(suffix)"
                : "search.empty.no_data.\(suffix)",
            table: .shared
        )
    }
}
