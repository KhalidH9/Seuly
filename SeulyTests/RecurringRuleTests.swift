import XCTest
@testable import Seuly

final class RecurringRuleTests: XCTestCase {
    func testTransferDerivesBalancedAmount() {
        let rule = makeRule(
            kind: .transfer,
            amount: 75_000,
            destination: TestData.savingsID,
            category: nil
        )

        XCTAssertEqual(rule.amountMinor, 75_000)
        XCTAssertEqual(rule.legs.count, 2)
        XCTAssertEqual(rule.legs.reduce(0) { $0 + $1.amountMinor }, 0)
        XCTAssertNil(rule.categoryID)
        XCTAssertEqual(rule.status, .active)
    }

    func testExpenseDerivesAmountAndCategory() {
        let rule = makeRule(
            kind: .expense,
            amount: 12_000,
            destination: nil,
            category: TestData.expenseCategoryID
        )

        XCTAssertEqual(rule.amountMinor, 12_000)
        XCTAssertEqual(rule.categoryID, TestData.expenseCategoryID)
        XCTAssertEqual(rule.legs.first?.amountMinor, -12_000)
    }

    private func makeRule(
        kind: TransactionKind,
        amount: Int64,
        destination: UUID?,
        category: UUID?
    ) -> RecurringRule {
        var legs = [
            RecurringLeg(
                id: UUID(),
                accountID: TestData.accountID,
                categoryID: category,
                amountMinor: kind == .income ? amount : -amount
            )
        ]
        if let destination {
            legs.append(
                RecurringLeg(
                    id: UUID(),
                    accountID: destination,
                    categoryID: nil,
                    amountMinor: amount
                )
            )
        }
        return RecurringRule(
            id: UUID(),
            userID: TestData.userID,
            kind: kind,
            merchant: "Rule",
            note: "",
            cadence: .monthly,
            nextRunOn: LocalDate(
                date: TestData.referenceDate,
                timeZone: TestData.calendar.timeZone
            ),
            status: .active,
            legs: legs
        )
    }
}
