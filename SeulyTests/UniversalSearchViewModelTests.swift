import XCTest
@testable import Seuly

@MainActor
final class UniversalSearchViewModelTests: XCTestCase {
    func testPrivacyModeRemovesAmountOnlyMatches() throws {
        let context = try makeContext()
        context.finance.workspace = TestData.searchWorkspace()
        let search = context.tabs.searchViewModel
        search.query = "٤٠٠٠"

        XCTAssertFalse(search.displayedResults.isEmpty)
        context.preferences.isPrivacyModeEnabled = true
        XCTAssertTrue(search.displayedResults.isEmpty)
    }

    func testResetClearsQueryAndScope() throws {
        let context = try makeContext()
        let search = context.tabs.searchViewModel
        search.query = "حساب"
        search.selectedScope = .account

        search.resetSession()

        XCTAssertTrue(search.query.isEmpty)
        XCTAssertEqual(search.selectedScope, .all)
    }

    private func makeContext() throws -> (
        finance: FinanceModel,
        tabs: MainTabViewModel,
        preferences: PreferencesModel
    ) {
        let defaults = try XCTUnwrap(
            UserDefaults(suiteName: "search-tests-\(UUID())")
        )
        let preferences = PreferencesModel(defaults: defaults)
        let app = AppViewModel(
            configuration: SupabaseConfiguration(
                url: URL(string: "https://example.supabase.co")!,
                publishableKey: String(repeating: "a", count: 40)
            ),
            preferences: preferences
        )
        return (
            try XCTUnwrap(app.financeModel),
            try XCTUnwrap(app.mainTabViewModel),
            preferences
        )
    }
}
