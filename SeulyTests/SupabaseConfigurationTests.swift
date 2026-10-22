import Foundation
import XCTest
@testable import Seuly

final class SupabaseConfigurationTests: XCTestCase {
    func testAcceptsClientSafeKeyFormats() throws {
        let publishable = "sb_publishable_" + String(repeating: "p", count: 32)
        let anon = try legacyKey(role: "anon")

        XCTAssertEqual(
            SupabaseConfiguration.normalizedClientKey(" \(publishable)\n"),
            publishable
        )
        XCTAssertEqual(
            SupabaseConfiguration.normalizedClientKey(anon),
            anon
        )
    }

    func testRejectsPrivilegedAndUnknownKeys() throws {
        let secret = "sb_secret_" + String(repeating: "s", count: 32)
        let serviceRole = try legacyKey(role: "service_role")

        XCTAssertNil(SupabaseConfiguration.normalizedClientKey(secret))
        XCTAssertNil(SupabaseConfiguration.normalizedClientKey(serviceRole))
        XCTAssertNil(
            SupabaseConfiguration.normalizedClientKey(
                String(repeating: "x", count: 40)
            )
        )
    }

    func testAcceptsHostedAndDebugLoopbackURLs() {
        XCTAssertNotNil(
            SupabaseConfiguration.validURL("https://project.supabase.co")
        )
#if DEBUG
        XCTAssertNotNil(
            SupabaseConfiguration.validURL("http://127.0.0.1:54321")
        )
#endif
    }

    func testRejectsUnsafeSupabaseURLs() {
        XCTAssertNil(SupabaseConfiguration.validURL("http://project.supabase.co"))
        XCTAssertNil(SupabaseConfiguration.validURL("https://supabase.co"))
        XCTAssertNil(SupabaseConfiguration.validURL("https://project.supabase.co/path"))
        XCTAssertNil(SupabaseConfiguration.validURL("http://192.168.1.4:54321"))
    }

    private func legacyKey(role: String) throws -> String {
        let header = try segment(["alg": "HS256", "typ": "JWT"])
        let payload = try segment(["role": role, "iss": "supabase"])
        return "\(header).\(payload).fabricated_signature"
    }

    private func segment(_ value: [String: String]) throws -> String {
        try JSONSerialization.data(withJSONObject: value)
            .base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
