import Foundation

/// Holds the active language and the bundles resolved for it.
///
/// Localized text is read from model types that are not confined to the main
/// actor, so access is guarded by a lock rather than by an actor hop.
final class LocalizationStore: @unchecked Sendable {
    static let shared = LocalizationStore()

    private let lock = NSLock()
    private var activeLanguage = AppLanguage.fallback
    private var bundles: [AppLanguage: Bundle] = [:]

    var language: AppLanguage {
        lock.withLock { activeLanguage }
    }

    func activate(_ language: AppLanguage) {
        lock.withLock { activeLanguage = language }
    }

    func bundle(for language: AppLanguage) -> Bundle {
        lock.withLock {
            if let cached = bundles[language] { return cached }
            let resolved = Self.load(language) ?? .main
            bundles[language] = resolved
            return resolved
        }
    }

    private static func load(_ language: AppLanguage) -> Bundle? {
        guard
            let path = Bundle.main.path(
                forResource: language.rawValue,
                ofType: "lproj"
            )
        else { return nil }
        return Bundle(path: path)
    }
}
