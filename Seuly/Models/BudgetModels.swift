import Foundation

struct BudgetPeriod: Identifiable, Equatable, Sendable {
    let id: UUID
    let userID: UUID
    var name: String
    var currencyCode: String
    var periodStart: LocalDate
    var periodEnd: LocalDate
    var lines: [BudgetLine]

    var startsOn: Date { periodStart.date() }
    var endsOn: Date { periodEnd.date() }
    var localizedName: String {
        L10n.databaseValue(name, prefix: "budget")
    }
}

struct BudgetLine: Identifiable, Equatable, Sendable {
    let id: UUID
    let budgetID: UUID
    let categoryID: UUID
    var limitMinor: Int64
}
