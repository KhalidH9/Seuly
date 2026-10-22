import SwiftUI

/// The languages the interface ships in. Arabic is the product's own language
/// and stays the default; English is opt-in.
enum AppLanguage: String, CaseIterable, Identifiable, Sendable {
    case arabic = "ar"
    case english = "en"

    /// Used when no preference is stored and when a key is missing from the
    /// selected language.
    static let fallback = AppLanguage.arabic

    var id: String { rawValue }

    var localeIdentifier: String {
        switch self {
        case .arabic: "ar_SA"
        case .english: "en_US"
        }
    }

    var locale: Locale { Locale(identifier: localeIdentifier) }

    var layoutDirection: LayoutDirection {
        switch self {
        case .arabic: .rightToLeft
        case .english: .leftToRight
        }
    }

    /// Listed in its own language, the way system language pickers do, so it
    /// is readable whichever language is active.
    var nativeName: String {
        switch self {
        case .arabic: "العربية"
        case .english: "English"
        }
    }
}
