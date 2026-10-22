import Foundation
@testable import Seuly

enum TestData {
    static let userID = UUID(uuidString: "10000000-0000-0000-0000-000000000001")!
    static let accountID = UUID(uuidString: "20000000-0000-0000-0000-000000000001")!
    static let savingsID = UUID(uuidString: "20000000-0000-0000-0000-000000000002")!
    static let expenseCategoryID = UUID(
        uuidString: "30000000-0000-0000-0000-000000000001"
    )!
    static let incomeCategoryID = UUID(
        uuidString: "30000000-0000-0000-0000-000000000002"
    )!

    static var calendar: Calendar {
        var value = Calendar(identifier: .gregorian)
        value.timeZone = TimeZone(secondsFromGMT: 0)!
        return value
    }

    static let referenceDate = date(year: 2026, month: 7, day: 10)

    static let currency = CurrencyDefinition(
        code: "SAR",
        name: "Saudi Riyal",
        symbol: "ر.س",
        minorUnit: 2,
        isActive: true
    )

    static func date(year: Int, month: Int, day: Int) -> Date {
        calendar.date(
            from: DateComponents(
                year: year,
                month: month,
                day: day,
                hour: 12
            )
        )!
    }

    static let profile = FinanceProfile(
        id: userID,
        displayName: "Test User",
        currencyCode: "SAR",
        onboardingCompleted: true,
        createdAt: referenceDate
    )

    static let checking = FinancialAccount(
        id: accountID,
        userID: userID,
        name: "Checking",
        kind: .checking,
        currencyCode: "SAR",
        openingBalanceMinor: 1_000_000,
        balanceMinor: 1_250_000,
        institutionName: nil,
        iconKey: "building.columns",
        colorRole: .teal,
        includeInNetWorth: true,
        sortOrder: 0,
        archivedAt: nil
    )

    static let savings = FinancialAccount(
        id: savingsID,
        userID: userID,
        name: "Savings",
        kind: .savings,
        currencyCode: "SAR",
        openingBalanceMinor: 200_000,
        balanceMinor: 250_000,
        institutionName: nil,
        iconKey: "banknote",
        colorRole: .savings,
        includeInNetWorth: true,
        sortOrder: 1,
        archivedAt: nil
    )
}
