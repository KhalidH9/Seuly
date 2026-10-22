import XCTest
@testable import Seuly

final class FinancialTransactionTests: XCTestCase {
    func testTransferExposesBalancedLedgerAndAccounts() {
        let transaction = TestData.transaction(
            kind: .transfer,
            amount: 25_000,
            destination: TestData.savingsID,
            day: 10
        )

        XCTAssertEqual(transaction.amountMinor, 25_000)
        XCTAssertEqual(transaction.legs.count, 2)
        XCTAssertEqual(transaction.legs.reduce(0) { $0 + $1.amountMinor }, 0)
        XCTAssertEqual(transaction.sourceAccountID, TestData.accountID)
        XCTAssertEqual(transaction.destinationAccountID, TestData.savingsID)
        XCTAssertNil(transaction.categoryID)
    }

    func testExpenseDerivesAmountAndCategoryFromNegativeLeg() {
        let transaction = TestData.transaction(
            kind: .expense,
            amount: 10_000,
            day: 10
        )

        XCTAssertEqual(transaction.amountMinor, 10_000)
        XCTAssertEqual(transaction.sourceAccountID, TestData.accountID)
        XCTAssertEqual(transaction.categoryID, TestData.expenseCategoryID)
        XCTAssertNil(transaction.destinationAccountID)
    }

    func testIncomeDerivesAmountAndDestinationFromPositiveLeg() {
        let transaction = TestData.transaction(
            kind: .income,
            amount: 90_000,
            category: TestData.incomeCategoryID,
            day: 10
        )

        XCTAssertEqual(transaction.amountMinor, 90_000)
        XCTAssertNil(transaction.sourceAccountID)
        XCTAssertEqual(transaction.destinationAccountID, TestData.accountID)
        XCTAssertEqual(transaction.categoryID, TestData.incomeCategoryID)
    }
}
