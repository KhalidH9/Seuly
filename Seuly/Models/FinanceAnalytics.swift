import Foundation

struct FinanceAnalytics {
    let workspace: FinanceWorkspace
    let referenceDate: Date
    let calendar: Calendar

    init(
        workspace: FinanceWorkspace,
        referenceDate: Date = .now,
        calendar: Calendar = FinanceCalendar.current
    ) {
        self.workspace = workspace
        self.referenceDate = referenceDate
        self.calendar = calendar
    }

    var postedTransactions: [FinancialTransaction] {
        workspace.transactions.filter { $0.status == .posted }
    }

    var monthTransactions: [FinancialTransaction] {
        postedTransactions.filter {
            calendar.isDate(
                $0.effectiveDate,
                equalTo: referenceDate,
                toGranularity: .month
            )
        }
    }

    func advancedDate(from date: Date, cadence: RecurringCadence) -> Date? {
        switch cadence {
        case .weekly:
            calendar.date(byAdding: .weekOfYear, value: 1, to: date)
        case .monthly:
            calendar.date(byAdding: .month, value: 1, to: date)
        case .yearly:
            calendar.date(byAdding: .year, value: 1, to: date)
        }
    }
}
