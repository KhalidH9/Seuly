import Foundation
import Observation

@MainActor
@Observable
final class UniversalSearchViewModel {
    var query = ""
    var selectedScope: UniversalSearchScope = .all

    private let model: FinanceModel
    private let preferences: PreferencesModel
    @ObservationIgnored private var cachedIndex: UniversalSearchIndexSnapshot?

    init(model: FinanceModel, preferences: PreferencesModel) {
        self.model = model
        self.preferences = preferences
    }

    var displayedResults: [UniversalSearchResult] {
        let index = searchIndex
        let catalog = UniversalSearchCatalog(
            workspace: model.workspace,
            referenceDate: index.referenceDay.date()
        )
        if isShowingRecent {
            return catalog.recentResults(
                scope: selectedScope,
                sourceResults: index.results
            )
        }
        return catalog.search(
            query: query,
            scope: selectedScope,
            includesAmounts: !isPrivacyModeEnabled,
            sourceResults: index.results
        )
    }

    var sections: [UniversalSearchSection] {
        let results = displayedResults
        return UniversalSearchKind.allCases.compactMap { kind in
            let values = results.filter { $0.kind == kind }
            return values.isEmpty ? nil : UniversalSearchSection(
                id: kind,
                results: values
            )
        }
    }

    var isShowingRecent: Bool {
        query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Everything currently indexed, used to build the browse counts.
    var indexedResults: [UniversalSearchResult] { searchIndex.results }
    var hasSearchableData: Bool { !searchIndex.results.isEmpty }
    var isPrivacyModeEnabled: Bool { preferences.isPrivacyModeEnabled }

    func currency(for code: String?) -> CurrencyDefinition? {
        guard let code else { return model.workspace.currency }
        return model.workspace.currency(for: code)
    }

    func clearQuery() {
        query = ""
        selectedScope = .all
    }

    func resetSession() {
        clearQuery()
    }

    private var searchIndex: UniversalSearchIndexSnapshot {
        let day = LocalDate(date: .now)
        let revision = model.workspaceRevision
        if let cachedIndex, cachedIndex.matches(revision: revision, day: day) {
            return cachedIndex
        }
        let results = UniversalSearchCatalog(
            workspace: model.workspace,
            referenceDate: day.date()
        ).allResults
        let value = UniversalSearchIndexSnapshot(
            workspaceRevision: revision,
            referenceDay: day,
            results: results
        )
        cachedIndex = value
        return value
    }
}
