import Foundation
@testable import Seuly

extension TestData {
    static let goalID = UUID(
        uuidString: "40000000-0000-0000-0000-000000000001"
    )!
    static let recurringID = UUID(
        uuidString: "50000000-0000-0000-0000-000000000001"
    )!

    static func searchWorkspace() -> FinanceWorkspace {
        var value = workspace()
        value.transactions[0].merchant = "شركة النور"
        value.transactions[0].note = "راتب شهر يوليو"
        value.goals = [
            SavingsGoal(
                id: goalID,
                userID: userID,
                name: "رحلة اليابان",
                kind: .savings,
                currencyCode: "SAR",
                targetMinor: 800_000,
                targetOn: LocalDate(
                    date: date(year: 2027, month: 3, day: 1),
                    timeZone: calendar.timeZone
                ),
                status: .active,
                iconKey: "airplane",
                colorRole: .savings,
                progressMinor: 200_000
            )
        ]
        value.recurringRules = [recurringRule]
        return value
    }

    static var recurringRule: RecurringRule {
        RecurringRule(
            id: recurringID,
            userID: userID,
            kind: .expense,
            merchant: "اشتراك الإنترنت",
            note: "فاتورة المنزل",
            cadence: .monthly,
            nextRunOn: LocalDate(
                date: date(year: 2026, month: 8, day: 1),
                timeZone: calendar.timeZone
            ),
            status: .active,
            legs: [
                RecurringLeg(
                    id: UUID(),
                    accountID: accountID,
                    categoryID: expenseCategoryID,
                    amountMinor: -20_000
                )
            ]
        )
    }
}
