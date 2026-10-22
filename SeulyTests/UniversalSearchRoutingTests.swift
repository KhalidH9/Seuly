import XCTest
@testable import Seuly

@MainActor
final class UniversalSearchRoutingTests: XCTestCase {
    func testTransactionAndCategoryOpenInActivity() throws {
        let context = try makeContext()
        let catalog = UniversalSearchCatalog(
            workspace: context.finance.workspace,
            referenceDate: TestData.referenceDate
        )
        let transaction = try XCTUnwrap(catalog.transactionResults.first)
        context.tabs.openSearchResult(transaction)
        XCTAssertEqual(context.tabs.selectedTab, .activity)
        XCTAssertNotNil(context.tabs.activityViewModel.selectedTransaction)

        let category = try XCTUnwrap(catalog.categoryResults.first)
        context.tabs.openSearchResult(category)
        XCTAssertEqual(context.tabs.activityViewModel.period, .recent)
        XCTAssertEqual(
            context.tabs.activityViewModel.selectedCategoryID,
            TestData.expenseCategoryID
        )
        XCTAssertTrue(context.tabs.activityViewModel.searchText.isEmpty)
    }

    func testAccountOpensEditSheet() throws {
        let context = try makeContext()
        let result = try XCTUnwrap(
            UniversalSearchCatalog(workspace: context.finance.workspace)
                .accountResults.first
        )
        context.tabs.openSearchResult(result)
        guard case .account(let account) = context.tabs.activeSheet else {
            return XCTFail("Expected account sheet")
        }
        XCTAssertEqual(account?.id, TestData.accountID)
    }

    func testPlanningResultsSelectTheirVisibleSection() throws {
        let context = try makeContext()
        for (kind, section) in [
            (UniversalSearchKind.budget, PlanningViewModel.Section.budgets),
            (.goal, .goals),
            (.recurring, .recurring)
        ] {
            let id = UUID()
            let result = UniversalSearchResult(
                id: .budget(id),
                kind: kind,
                title: "",
                subtitle: "",
                destination: .planning(kind: kind, entityID: id)
            )
            context.tabs.openSearchResult(result)
            XCTAssertEqual(context.tabs.selectedTab, .plan)
            XCTAssertEqual(context.tabs.planningViewModel.selectedSection, section)
            XCTAssertEqual(context.tabs.planningViewModel.focusedEntityID, id)
        }
        let goal = UniversalSearchResult(
            id: .goal(TestData.goalID),
            kind: .goal,
            title: "",
            subtitle: "",
            destination: .planning(kind: .goal, entityID: TestData.goalID)
        )
        context.tabs.openSearchResult(goal)
        XCTAssertEqual(context.tabs.planningViewModel.activeGoals.first?.id, TestData.goalID)
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
