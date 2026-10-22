import Foundation

extension Date {
    func startOfMonth(using calendar: Calendar = FinanceCalendar.current) -> Date {
        calendar.dateInterval(of: .month, for: self)?.start ?? self
    }

    func endOfMonth(using calendar: Calendar = FinanceCalendar.current) -> Date {
        calendar.dateInterval(of: .month, for: self)?.end ?? self
    }

    func isInSameMonth(
        as other: Date,
        using calendar: Calendar = FinanceCalendar.current
    ) -> Bool {
        calendar.isDate(self, equalTo: other, toGranularity: .month)
    }
}
