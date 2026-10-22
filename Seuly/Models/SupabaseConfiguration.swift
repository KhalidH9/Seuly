import Foundation

struct SupabaseConfiguration: Equatable, Sendable {
    let url: URL
    let publishableKey: String

    static func load(bundle: Bundle = .main) -> SupabaseConfiguration? {
        let environment = ProcessInfo.processInfo.environment
        if
            let rawURL = environment["SUPABASE_URL"],
            let rawKey = environment["SUPABASE_PUBLISHABLE_KEY"],
            let key = normalizedClientKey(rawKey),
            let url = validURL(rawURL)
        {
            return SupabaseConfiguration(url: url, publishableKey: key)
        }
        guard
            let fileURL = bundle.url(
                forResource: "SupabaseSecrets",
                withExtension: "plist"
            ),
            let data = try? Data(contentsOf: fileURL),
            let values = try? PropertyListSerialization.propertyList(
                from: data,
                format: nil
            ) as? [String: String],
            let rawURL = values["SUPABASE_URL"],
            let rawKey = values["SUPABASE_PUBLISHABLE_KEY"]
                ?? values["SUPABASE_ANON_KEY"],
            let key = normalizedClientKey(rawKey),
            let url = validURL(rawURL)
        else { return nil }
        return SupabaseConfiguration(url: url, publishableKey: key)
    }

}

enum AppConfiguration {
    enum AuthCallback: Equatable {
        case authentication
        case passwordRecovery
    }

    static let authCallbackScheme = "seuly"
    static let authCallbackURL = URL(string: "seuly://auth-callback")
    static let passwordRecoveryCallbackURL = URL(
        string: "seuly://auth-recovery"
    )

    static func isPasswordRecoveryCallback(_ url: URL) -> Bool {
        authCallback(for: url) == .passwordRecovery
    }

    static func authCallback(for url: URL) -> AuthCallback? {
        if matches(url, expected: authCallbackURL) {
            return .authentication
        }
        if matches(url, expected: passwordRecoveryCallbackURL) {
            return .passwordRecovery
        }
        return nil
    }

    private static func matches(_ url: URL, expected: URL?) -> Bool {
        guard let expected else { return false }
        return url.scheme == expected.scheme
            && url.host == expected.host
            && url.path == expected.path
            && url.user == nil
            && url.password == nil
            && url.port == nil
    }
}
