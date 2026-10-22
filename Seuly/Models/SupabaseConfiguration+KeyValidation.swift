import Foundation

extension SupabaseConfiguration {
    static func normalizedClientKey(_ value: String) -> String? {
        let key = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard key.count > 20, !key.contains("YOUR_") else { return nil }
        let lowered = key.lowercased()
        guard !lowered.hasPrefix("sb_secret_") else { return nil }
        if lowered.hasPrefix("sb_publishable_") { return key }
        return legacyRole(in: key) == "anon" ? key : nil
    }

    private static func legacyRole(in key: String) -> String? {
        let segments = key.split(separator: ".", omittingEmptySubsequences: false)
        guard segments.count == 3 else { return nil }
        var payload = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let padding = (4 - payload.count % 4) % 4
        payload.append(String(repeating: "=", count: padding))
        guard
            let data = Data(base64Encoded: payload),
            let object = try? JSONSerialization.jsonObject(with: data),
            let claims = object as? [String: Any]
        else { return nil }
        return claims["role"] as? String
    }
}
