import Foundation

enum DatabaseDate {
    static func string(from date: Date) -> String {
        LocalDate(date: date).databaseValue
    }

    static func timestamp(from value: String) throws -> Date {
        let fractional = ISO8601DateFormatter()
        fractional.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        if let date = fractional.date(from: value) { return date }
        if let date = ISO8601DateFormatter().date(from: value) { return date }
        throw SupabaseMappingError.invalidDate(
            field: "timestamp",
            value: value
        )
    }
}

enum SupabaseMappingError: LocalizedError {
    case invalidDate(field: String, value: String)
    case unsupportedValue(field: String, value: String)

    var errorDescription: String? {
        switch self {
        case .invalidDate, .unsupportedValue:
            L10n.text("error.data.mapping_failed", table: .errors)
        }
    }
}
