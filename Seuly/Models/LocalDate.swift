import Foundation

struct LocalDate: Hashable, Comparable, Sendable {
    let year: Int
    let month: Int
    let day: Int

    init(date: Date, timeZone: TimeZone = .current) {
        let components = Self.gregorian(timeZone: timeZone).dateComponents(
            [.year, .month, .day],
            from: date
        )
        year = components.year ?? 1
        month = components.month ?? 1
        day = components.day ?? 1
    }

    init(databaseValue: String) throws {
        let parts = databaseValue.split(separator: "-", omittingEmptySubsequences: false)
        guard
            parts.count == 3,
            let year = Int(parts[0]),
            let month = Int(parts[1]),
            let day = Int(parts[2]),
            Self.isValid(year: year, month: month, day: day)
        else {
            throw SupabaseMappingError.invalidDate(
                field: "date",
                value: databaseValue
            )
        }
        self.year = year
        self.month = month
        self.day = day
    }

    var databaseValue: String {
        String(format: "%04d-%02d-%02d", year, month, day)
    }

    func date(timeZone: TimeZone = .current) -> Date {
        Self.gregorian(timeZone: timeZone).date(
            from: DateComponents(
                year: year,
                month: month,
                day: day,
                hour: 12
            )
        ) ?? .distantPast
    }

    static func < (lhs: LocalDate, rhs: LocalDate) -> Bool {
        (lhs.year, lhs.month, lhs.day) < (rhs.year, rhs.month, rhs.day)
    }

    private static func isValid(year: Int, month: Int, day: Int) -> Bool {
        let utc = TimeZone(secondsFromGMT: 0) ?? .current
        let calendar = gregorian(timeZone: utc)
        let components = DateComponents(
            timeZone: calendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: 12
        )
        guard let date = calendar.date(from: components) else { return false }
        let result = calendar.dateComponents([.year, .month, .day], from: date)
        return result.year == year && result.month == month && result.day == day
    }

    private static func gregorian(timeZone: TimeZone) -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = timeZone
        return calendar
    }
}
