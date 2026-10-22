import XCTest
@testable import Seuly

final class FinanceAnalyticsBalanceTests: XCTestCase {
    func testTransfersDoNotChangeNetWorthOrCashFlow() throws {
        let workspace = TestData.workspace()
        let analytics = FinanceAnalytics(
            workspace: workspace,
            referenceDate: TestData.referenceDate,
            calendar: TestData.calendar
        )
        let opening = workspace.accounts
            .filter(\.includeInNetWorth)
            .reduce(Int64(0)) { $0 + $1.openingBalanceMinor }
        let expected = opening
            + analytics.postedTransactions
                .filter { $0.kind == .income }
                .reduce(0) { $0 + $1.amountMinor }
            - analytics.postedTransactions
                .filter { $0.kind == .expense }
                .reduce(0) { $0 + $1.amountMinor }

        XCTAssertEqual(analytics.netWorthMinor, expected)
        XCTAssertEqual(analytics.monthIncomeMinor, 400_000)
        XCTAssertEqual(analytics.monthExpenseMinor, 100_000)
        XCTAssertTrue(
            workspace.transactions
                .filter { $0.kind == .transfer }
                .allSatisfy { $0.legs.reduce(0) { $0 + $1.amountMinor } == 0 }
        )
    }

    func testBudgetSpendUsesPostedCategoryExpenses() throws {
        let workspace = TestData.workspace()
        let analytics = FinanceAnalytics(
            workspace: workspace,
            referenceDate: TestData.referenceDate,
            calendar: TestData.calendar
        )
        let progress = try XCTUnwrap(analytics.budgetProgress.first)

        XCTAssertEqual(progress.category.id, TestData.expenseCategoryID)
        XCTAssertEqual(progress.spentMinor, 100_000)
        XCTAssertEqual(progress.remainingMinor, 200_000)
    }

    func testMoneyPulseIsTightWithoutLiquidCash() {
        let analytics = FinanceAnalytics(
            workspace: .empty,
            referenceDate: TestData.referenceDate,
            calendar: TestData.calendar
        )

        guard case .tight = analytics.moneyPulse else {
            return XCTFail("Expected a tight pulse with no liquid cash.")
        }
    }

    func testBudgetBoundaryUsesLocalDatesAtStartOfMonth() throws {
        var workspace = TestData.workspace()
        let augustID = UUID()
        workspace.budgets.append(
            BudgetPeriod(
                id: augustID,
                userID: TestData.userID,
                name: "August",
                currencyCode: "SAR",
                periodStart: try LocalDate(databaseValue: "2026-08-01"),
                periodEnd: try LocalDate(databaseValue: "2026-09-01"),
                lines: []
            )
        )
        let earlyAugust = try XCTUnwrap(
            TestData.calendar.date(
                from: DateComponents(
                    year: 2026,
                    month: 8,
                    day: 1,
                    hour: 1
                )
            )
        )
        let analytics = FinanceAnalytics(
            workspace: workspace,
            referenceDate: earlyAugust,
            calendar: TestData.calendar
        )

        XCTAssertEqual(analytics.currentBudget?.id, augustID)
    }
}
