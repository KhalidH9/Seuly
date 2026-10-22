import Foundation

extension SupabaseConfiguration {
    static func validURL(_ value: String) -> URL? {
        guard
            !value.contains("YOUR_PROJECT"),
            let components = URLComponents(string: value),
            let scheme = components.scheme?.lowercased(),
            let host = components.host?.lowercased(),
            components.user == nil,
            components.password == nil,
            components.query == nil,
            components.fragment == nil,
            components.path.isEmpty || components.path == "/",
            let url = components.url
        else { return nil }
        if scheme == "https",
           host.hasSuffix(".supabase.co"),
           components.port == nil || components.port == 443 {
            return url
        }
#if DEBUG
        let loopbackHosts = ["127.0.0.1", "localhost", "::1"]
        if scheme == "http", loopbackHosts.contains(host),
           components.port != nil {
            return url
        }
#endif
        return nil
    }
}
