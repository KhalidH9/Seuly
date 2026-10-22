import Foundation
import Observation

@MainActor
@Observable
final class PreferencesModel {
    private enum Key {
        static let privacyMode = "seuly.privacyMode"
        static let appearance = "seuly.appearance"
        static let language = "seuly.language"
    }

    private enum LegacyKey {
        static let privacyMode = "siyuli.privacyMode"
        static let appearance = "siyuli.appearance"
        static let language = "siyuli.language"
    }

    var isPrivacyModeEnabled: Bool {
        didSet {
            defaults.set(isPrivacyModeEnabled, forKey: Key.privacyMode)
        }
    }

    var appearance: AppearancePreference {
        didSet {
            defaults.set(appearance.rawValue, forKey: Key.appearance)
        }
    }

    /// Writing this also activates the language in the localization store, so
    /// every subsequent string lookup and formatter resolves in it.
    var language: AppLanguage {
        didSet {
            defaults.set(language.rawValue, forKey: Key.language)
            AppLocale.activate(language)
        }
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        Self.migrateLegacyKeys(in: defaults)
        isPrivacyModeEnabled = defaults.bool(forKey: Key.privacyMode)
        appearance = AppearancePreference(
            rawValue: defaults.string(forKey: Key.appearance) ?? ""
        ) ?? .system
        let stored = AppLanguage(
            rawValue: defaults.string(forKey: Key.language) ?? ""
        )
        language = stored ?? .fallback
        AppLocale.activate(language)
    }

    private static func migrateLegacyKeys(in defaults: UserDefaults) {
        let pairs = [
            (LegacyKey.privacyMode, Key.privacyMode),
            (LegacyKey.appearance, Key.appearance),
            (LegacyKey.language, Key.language)
        ]
        for (legacy, current) in pairs {
            if defaults.object(forKey: current) == nil,
               let value = defaults.object(forKey: legacy) {
                defaults.set(value, forKey: current)
            }
            defaults.removeObject(forKey: legacy)
        }
    }
}
