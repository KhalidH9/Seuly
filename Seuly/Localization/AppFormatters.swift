import Foundation

enum AppFormatters {
    static func dayMonth(_ date: Date) -> String {
        date.formatted(
            Date.FormatStyle()
                .day()
                .month(.wide)
                .locale(AppLocale.locale)
        )
    }

    static func fullDate(_ date: Date) -> String {
        date.formatted(
            Date.FormatStyle(date: .long, time: .omitted)
                .locale(AppLocale.locale)
        )
    }

    static func monthYear(_ date: Date) -> String {
        date.formatted(
            Date.FormatStyle()
                .month(.wide)
                .year()
                .locale(AppLocale.locale)
        )
    }

    static func integer(_ value: Int) -> String {
        value.formatted(.number.locale(AppLocale.locale))
    }

    static func decimal(_ value: Double, digits: Int = 0) -> String {
        value.formatted(
            .number
                .precision(.fractionLength(digits))
                .locale(AppLocale.locale)
        )
    }
}
