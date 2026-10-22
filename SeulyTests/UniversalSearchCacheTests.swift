import XCTest
@testable import Seuly

@MainActor
final class UniversalSearchCacheTests: XCTestCase {
    func testWorkspaceMutationInvalidatesCachedSearchIndex() throws {
        let context = try makeContext()
        let search = context.tabs.searchViewModel
        search.query = "Checking"
        XCTAssertFalse(search.displayedResults.isEmpty)

        context.finance.workspace.accounts[0].name = "حساب الرحلات"
        search.query = "الرحلات"

        XCTAssertFalse(search.displayedResults.isEmpty)
        search.query = "Checking"
        XCTAssertTrue(search.displayedResults.isEmpty)
    }

    func testSelectingKindClearsExactCategoryFilter() throws {
        let context = try makeContext()
        let activity = context.tabs.activityViewModel
        activity.selectedCategoryID = TestData.expenseCategoryID

        activity.selectKind(.income)

        XCTAssertNil(activity.selectedCategoryID)
        XCTAssertEqual(activity.selectedKind, .income)
    }

    private func makeContext() throws -> (
        finance: FinanceModel,
        tabs: MainTabViewModel
    ) {
        let app = AppViewModel(configuration: SupabaseConfiguration(
            url: URL(string: "https://example.supabase.co")!,
            publishableKey: String(repeating: "a", count: 40)
        ))
        let finance = try XCTUnwrap(app.financeModel)
        finance.workspace = TestData.searchWorkspace()
        return (finance, try XCTUnwrap(app.mainTabViewModel))
    }
}
