import XCTest
@testable import Seuly

final class FinanceAnalyticsRecurringTests: XCTestCase {
    func testUpcomingExpensesIncludeEveryRemainingOccurrence() throws {
        var workspace = TestData.workspace()
        workspace.recurringRules = [
            expenseRule(
                amount: 10_000,
                nextRun: TestData.date(year: 2026, month: 7, day: 1)
            )
        ]
        let analytics = makeAnalytics(workspace)

        XCTAssertEqual(analytics.upcomingRecurringOccurrences.count, 3)
        XCTAssertEqual(analytics.upcomingExpenseMinor, 30_000)
        XCTAssertEqual(
            Set(analytics.upcomingRecurringOccurrences.map(\.id)).count,
            3
        )
    }

    func testSafeToSpendDoesNotDoubleReserveBudgetedExpense() throws {
        var workspace = TestData.workspace()
        workspace.recurringRules = [
            expenseRule(
                amount: 50_000,
                nextRun: TestData.date(year: 2026, month: 7, day: 12)
            )
        ]
        let analytics = makeAnalytics(workspace)
        let remaining = try XCTUnwrap(analytics.budgetProgress.first)
            .remainingMinor

        XCTAssertGreaterThanOrEqual(remaining, 50_000)
        XCTAssertEqual(analytics.upcomingExpenseMinor, 150_000)
        XCTAssertEqual(analytics.uncoveredUpcomingExpenseMinor, 0)
        XCTAssertEqual(
            analytics.safeToSpendMinor,
            max(analytics.liquidBalanceMinor - analytics.remainingBudgetMinor, 0)
        )
    }

    private func expenseRule(
        amount: Int64,
        nextRun: Date
    ) -> RecurringRule {
        RecurringRule(
            id: UUID(),
            userID: TestData.userID,
            kind: .expense,
            merchant: "Planned expense",
            note: "",
            cadence: .weekly,
            nextRunOn: LocalDate(
                date: nextRun,
                timeZone: TestData.calendar.timeZone
            ),
            status: .active,
            legs: [
                RecurringLeg(
                    id: UUID(),
                    accountID: TestData.accountID,
                    categoryID: TestData.expenseCategoryID,
                    amountMinor: -amount
                )
            ]
        )
    }

    private func makeAnalytics(
        _ workspace: FinanceWorkspace
    ) -> FinanceAnalytics {
        FinanceAnalytics(
            workspace: workspace,
            referenceDate: TestData.referenceDate,
            calendar: TestData.calendar
        )
    }
}
