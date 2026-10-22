import XCTest
@testable import Seuly

final class UniversalSearchCatalogTests: XCTestCase {
    private var catalog: UniversalSearchCatalog {
        UniversalSearchCatalog(
            workspace: TestData.searchWorkspace(),
            referenceDate: TestData.referenceDate
        )
    }

    func testCatalogIndexesEverySupportedWorkspaceEntity() {
        let kinds = Set(catalog.allResults.map(\.kind))
        XCTAssertEqual(kinds, Set(UniversalSearchKind.allCases))
    }

    func testArabicSearchFindsGoalFromSupabaseWorkspace() throws {
        let result = try XCTUnwrap(
            catalog.search(query: "اليابان", scope: .all).first
        )
        XCTAssertEqual(result.id, .goal(TestData.goalID))
        XCTAssertEqual(result.destination, .planning(
            kind: .goal,
            entityID: TestData.goalID
        ))
    }

    func testScopeLimitsResultsWithoutChangingSourceData() {
        let values = catalog.search(query: "Fixture", scope: .transaction)
        XCTAssertFalse(values.isEmpty)
        XCTAssertTrue(values.allSatisfy { $0.kind == .transaction })
        XCTAssertEqual(TestData.searchWorkspace().transactions.count, 3)
    }

    func testNumericArabicQueryMatchesTransactionAmount() {
        let values = catalog.search(query: "٤٠٠٠", scope: .transaction)
        XCTAssertTrue(values.contains { result in
            result.amountMinor == 400_000
        })
    }

    func testPrivacySearchDoesNotIndexAmounts() {
        let values = catalog.search(
            query: "٤٠٠٠",
            scope: .transaction,
            includesAmounts: false
        )
        XCTAssertTrue(values.isEmpty)
    }

    func testEmptyQueryScopeStillShowsExistingAccounts() {
        let values = catalog.recentResults(scope: .account)
        XCTAssertFalse(values.isEmpty)
        XCTAssertTrue(values.allSatisfy { $0.kind == .account })
    }

    func testRecentSuggestionsOnlyContainIndexedWorkspaceRecords() {
        let subject = catalog
        let indexed = Set(subject.allResults.map(\.id))
        let recent = subject.recentResults()
        XCTAssertFalse(recent.isEmpty)
        XCTAssertTrue(recent.allSatisfy { indexed.contains($0.id) })
    }

    func testRecentFallbackSupportsBudgetAndCategoryOnlyWorkspace() {
        var workspace = TestData.searchWorkspace()
        workspace.accounts = []
        workspace.transactions = []
        workspace.goals = []
        workspace.recurringRules = []
        let values = UniversalSearchCatalog(
            workspace: workspace,
            referenceDate: TestData.referenceDate
        ).recentResults()
        XCTAssertFalse(values.isEmpty)
        XCTAssertTrue(values.allSatisfy {
            $0.kind == .budget || $0.kind == .category
        })
    }
}
