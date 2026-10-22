import Foundation
@testable import Seuly

extension TestData {
    static let expenseCategory = FinanceCategory(
        id: expenseCategoryID,
        userID: userID,
        parentID: nil,
        kind: .expense,
        name: "Dining",
        iconKey: "fork.knife",
        colorRole: .expense,
        sortOrder: 0,
        archivedAt: nil
    )

    static let incomeCategory = FinanceCategory(
        id: incomeCategoryID,
        userID: userID,
        parentID: nil,
        kind: .income,
        name: "Salary",
        iconKey: "banknote",
        colorRole: .income,
        sortOrder: 1,
        archivedAt: nil
    )

    static func workspace() -> FinanceWorkspace {
        let budgetID = UUID()
        let transactions = [
            transaction(
                kind: .income,
                amount: 400_000,
                category: incomeCategoryID,
                day: 2
            ),
            transaction(kind: .expense, amount: 100_000, day: 4),
            transaction(
                kind: .transfer,
                amount: 50_000,
                destination: savingsID,
                day: 6
            )
        ]
        let budget = BudgetPeriod(
            id: budgetID,
            userID: userID,
            name: "July",
            currencyCode: "SAR",
            periodStart: LocalDate(
                date: date(year: 2026, month: 7, day: 1),
                timeZone: calendar.timeZone
            ),
            periodEnd: LocalDate(
                date: date(year: 2026, month: 8, day: 1),
                timeZone: calendar.timeZone
            ),
            lines: [
                BudgetLine(
                    id: UUID(),
                    budgetID: budgetID,
                    categoryID: expenseCategoryID,
                    limitMinor: 300_000
                )
            ]
        )
        return FinanceWorkspace(
            profile: profile,
            currencies: [currency],
            accounts: [checking, savings],
            categories: [expenseCategory, incomeCategory],
            transactions: transactions,
            budgets: [budget],
            goals: [],
            recurringRules: []
        )
    }
}
