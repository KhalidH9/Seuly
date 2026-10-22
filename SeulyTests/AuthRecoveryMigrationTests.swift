import Supabase
import XCTest
@testable import Seuly

@MainActor
final class AuthRecoveryMigrationTests: XCTestCase {
    func testLegacyActiveRecoveryMovesToCurrentKey() throws {
        let suiteName = "AuthRecoveryMigrationTests.\(UUID())"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }
        defaults.set(true, forKey: AuthModel.legacyActiveRecoveryKey)

        let model = AuthModel(
            client: SupabaseClient(
                supabaseURL: try XCTUnwrap(
                    URL(string: "https://example.supabase.co")
                ),
                supabaseKey: String(repeating: "a", count: 40)
            ),
            defaults: defaults
        )

        XCTAssertTrue(model.isPasswordRecovery)
        XCTAssertTrue(defaults.bool(forKey: AuthModel.recoveryKey))
        XCTAssertNil(
            defaults.object(forKey: AuthModel.legacyActiveRecoveryKey)
        )
    }
}
