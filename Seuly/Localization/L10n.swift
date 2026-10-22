import Foundation

enum L10nTable: String, CaseIterable {
    case app = "App"
    case auth = "Auth"
    case onboarding = "Onboarding"
    case dashboard = "Dashboard"
    case activity = "Activity"
    case transactions = "Transactions"
    case planning = "Planning"
    case insights = "Insights"
    case settings = "Settings"
    case shared = "Shared"
    case errors = "Errors"
    case data = "Data"
}

enum L10n {
    /// Resolves against the active language, then against Arabic. A key
    /// missing from both is a bug, so it trips an assertion in debug builds
    /// rather than shipping a raw key to the screen.
    static func text(_ key: String, table: L10nTable) -> String {
        let language = AppLocale.language
        if let value = lookup(key, table: table, language: language) {
            return value
        }
        if
            language != .fallback,
            let value = lookup(key, table: table, language: .fallback)
        {
            return value
        }
        assertionFailure(
            "Missing \(language.rawValue) localization: \(table.rawValue).\(key)"
        )
        return key
    }

    static func format(
        _ key: String,
        table: L10nTable,
        _ arguments: CVarArg...
    ) -> String {
        String(
            format: text(key, table: table),
            locale: AppLocale.locale,
            arguments: arguments
        )
    }

    /// Server-supplied values fall back to the stored string, which is already
    /// human readable for user-authored names.
    static func databaseValue(_ value: String, prefix: String) -> String {
        let key = "\(prefix).\(value)"
        return lookup(key, table: .data, language: AppLocale.language)
            ?? lookup(key, table: .data, language: .fallback)
            ?? value
    }

    private static func lookup(
        _ key: String,
        table: L10nTable,
        language: AppLanguage
    ) -> String? {
        let value = LocalizationStore.shared
            .bundle(for: language)
            .localizedString(forKey: key, value: key, table: table.rawValue)
        return value == key ? nil : value
    }
}
