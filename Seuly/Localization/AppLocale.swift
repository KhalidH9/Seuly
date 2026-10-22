import Foundation

/// Locale facts for the active language. Formatters read these, so switching
/// language also switches numerals, dates, and currency presentation.
enum AppLocale {
    static var language: AppLanguage {
        LocalizationStore.shared.language
    }

    static var identifier: String { language.localeIdentifier }

    static var languageCode: String { language.rawValue }

    static var locale: Locale { language.locale }

    static func activate(_ language: AppLanguage) {
        LocalizationStore.shared.activate(language)
    }
}
