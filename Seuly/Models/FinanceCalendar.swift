import Foundation

enum FinanceCalendar {
    static var current: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = .current
        return calendar
    }

    static func futureDateRange(
        referenceDate: Date = .now,
        calendar: Calendar = current
    ) -> ClosedRange<Date> {
        calendar.startOfDay(for: referenceDate)...Date.distantFuture
    }
}
