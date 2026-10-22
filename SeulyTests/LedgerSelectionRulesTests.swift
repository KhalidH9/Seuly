import XCTest
@testable import Seuly

final class LedgerSelectionRulesTests: XCTestCase {
    func testExpenseRequiresCategoryAndNoDestination() {
        let workspace = TestData.workspace()
        let source = workspace.activeAccounts.first?.id
        let category = LedgerSelectionRules.categoryID(
            for: .expense,
            workspace: workspace
        )
        let destination = LedgerSelectionRules.destinationID(
            for: .expense,
            sourceID: source,
            workspace: workspace
        )

        XCTAssertNotNil(category)
        XCTAssertNil(destination)
        XCTAssertTrue(
            LedgerSelectionRules.isValid(
                kind: .expense,
                sourceID: source,
                destinationID: destination,
                categoryID: category
            )
        )
    }

    func testTransferRequiresDifferentDestinationAndNoCategory() {
        let workspace = TestData.workspace()
        let source = workspace.activeAccounts.first?.id
        let destination = LedgerSelectionRules.destinationID(
            for: .transfer,
            sourceID: source,
            workspace: workspace
        )

        XCTAssertNotEqual(source, destination)
        XCTAssertNil(
            LedgerSelectionRules.categoryID(
                for: .transfer,
                workspace: workspace
            )
        )
        XCTAssertTrue(
            LedgerSelectionRules.isValid(
                kind: .transfer,
                sourceID: source,
                destinationID: destination,
                categoryID: nil
            )
        )
    }
}
