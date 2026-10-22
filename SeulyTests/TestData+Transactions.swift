import Foundation
@testable import Seuly

extension TestData {
    static func transaction(
        kind: TransactionKind,
        amount: Int64,
        source: UUID = accountID,
        destination: UUID? = nil,
        category: UUID? = expenseCategoryID,
        day: Int
    ) -> FinancialTransaction {
        let transactionID = UUID()
        var legs = [
            TransactionLeg(
                id: UUID(),
                transactionID: transactionID,
                accountID: source,
                categoryID: kind == .transfer ? nil : category,
                amountMinor: kind == .income ? amount : -amount
            )
        ]
        if let destination, kind == .transfer {
            legs.append(
                TransactionLeg(
                    id: UUID(),
                    transactionID: transactionID,
                    accountID: destination,
                    categoryID: nil,
                    amountMinor: amount
                )
            )
        }
        let effectiveDate = date(year: 2026, month: 7, day: day)
        return FinancialTransaction(
            id: transactionID,
            userID: userID,
            kind: kind,
            status: .posted,
            effectiveOn: LocalDate(
                date: effectiveDate,
                timeZone: calendar.timeZone
            ),
            occurredAt: effectiveDate,
            merchant: "Fixture",
            note: "",
            legs: legs,
            createdAt: effectiveDate
        )
    }
}
