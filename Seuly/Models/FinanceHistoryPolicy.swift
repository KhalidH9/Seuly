import Foundation

enum FinanceHistoryPolicy {
    static let visibleMonthCount = 24

    static func earliestVisibleDate(referenceDate: Date = .now) -> Date {
        let calendar = FinanceCalendar.current
        let currentMonth = referenceDate.startOfMonth(using: calendar)
        return calendar.date(
            byAdding: .month,
            value: -(visibleMonthCount - 1),
            to: currentMonth
        ) ?? currentMonth
    }
}
