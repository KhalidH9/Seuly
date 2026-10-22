import Foundation

enum LocalizedTextFormatter {
    static func dotSeparated(_ values: [String]) -> String {
        let separator = L10n.text("separator.dot", table: .shared)
        return values
            .filter { !$0.isEmpty }
            .joined(separator: " \(separator) ")
    }

    static func dateRange(from start: Date, through end: Date) -> String {
        L10n.format(
            "search.date_range",
            table: .shared,
            AppFormatters.dayMonth(start),
            AppFormatters.dayMonth(end)
        )
    }
}
