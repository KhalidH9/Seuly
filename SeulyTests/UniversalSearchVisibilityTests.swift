import XCTest
@testable import Seuly

final class UniversalSearchVisibilityTests: XCTestCase {
    func testPlanningSearchOnlyIndexesItemsVisibleAfterNavigation() {
        var workspace = TestData.searchWorkspace()
        workspace.budgets[0].periodEnd = LocalDate(
            date: TestData.date(year: 2026, month: 7, day: 1),
            timeZone: TestData.calendar.timeZone
        )
        workspace.goals[0].status = .paused
        workspace.recurringRules[0].status = .paused
        let results = catalog(for: workspace).allResults

        XCTAssertFalse(results.contains { $0.kind == .budget })
        XCTAssertFalse(results.contains { $0.kind == .goal })
        XCTAssertFalse(results.contains { $0.kind == .recurring })
    }

    func testInvalidDatabaseSymbolUsesSafeDomainFallback() throws {
        var workspace = TestData.searchWorkspace()
        workspace.accounts[0].iconKey = "not.a.real.symbol"
        let result = try XCTUnwrap(catalog(for: workspace).accountResults.first)
        XCTAssertEqual(result.systemImage, workspace.accounts[0].kind.systemImage)
    }

    func testRecurringCurrencyComesFromItsLedgerAccount() throws {
        var workspace = TestData.searchWorkspace()
        workspace.currencies.append(CurrencyDefinition(
            code: "AED",
            name: "UAE Dirham",
            symbol: "د.إ",
            minorUnit: 2,
            isActive: true
        ))
        workspace.accounts[0].currencyCode = "AED"
        let result = try XCTUnwrap(
            catalog(for: workspace).recurringResults.first
        )
        XCTAssertEqual(result.currencyCode, "AED")
    }

    func testBudgetRangeUsesInclusiveDisplayEnd() throws {
        let result = try XCTUnwrap(
            catalog(for: TestData.searchWorkspace()).budgetResults.first
        )
        let end = TestData.date(year: 2026, month: 7, day: 31)
        XCTAssertTrue(result.subtitle.contains(AppFormatters.dayMonth(end)))
    }

    func testBudgetAndRecurringAmountsRespectPrivacyIndexing() {
        let subject = catalog(for: TestData.searchWorkspace())
        XCTAssertFalse(subject.search(query: "٣٠٠٠", scope: .budget).isEmpty)
        XCTAssertTrue(subject.search(
            query: "٣٠٠٠",
            scope: .budget,
            includesAmounts: false
        ).isEmpty)
        XCTAssertFalse(subject.search(query: "٢٠٠", scope: .recurring).isEmpty)
        XCTAssertTrue(subject.search(
            query: "٢٠٠",
            scope: .recurring,
            includesAmounts: false
        ).isEmpty)
    }

    private func catalog(
        for workspace: FinanceWorkspace
    ) -> UniversalSearchCatalog {
        UniversalSearchCatalog(
            workspace: workspace,
            referenceDate: TestData.referenceDate
        )
    }
}
