import Supabase
import XCTest
@testable import Seuly

@MainActor
final class AuthRecoveryStateTests: XCTestCase {
    func testActiveRecoveryResumesWithoutLegacyPendingState() throws {
        let suiteName = "AuthRecoveryStateTests.\(UUID())"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }
        defaults.set(true, forKey: AuthModel.legacyRecoveryKey)

        let model = try makeModel(defaults: defaults)
        XCTAssertFalse(model.isPasswordRecovery)
        XCTAssertNil(defaults.object(forKey: AuthModel.legacyRecoveryKey))

        model.beginPasswordRecovery()
        XCTAssertTrue(defaults.bool(forKey: AuthModel.recoveryKey))
        let resumedModel = try makeModel(defaults: defaults)
        XCTAssertTrue(resumedModel.isPasswordRecovery)

        resumedModel.clearPasswordRecovery()
        XCTAssertFalse(defaults.bool(forKey: AuthModel.recoveryKey))
    }

    func testOnlyDedicatedURLMatchesPasswordRecovery() throws {
        let recovery = try XCTUnwrap(
            URL(string: "seuly://auth-recovery?code=example")
        )
        let ordinary = try XCTUnwrap(
            URL(string: "seuly://auth-callback?code=example")
        )

        XCTAssertTrue(AppConfiguration.isPasswordRecoveryCallback(recovery))
        XCTAssertFalse(AppConfiguration.isPasswordRecoveryCallback(ordinary))
    }

    func testCallbackRouteMustMatchExactly() throws {
        let invalidURLs = [
            "SEULY://AUTH-RECOVERY?code=example",
            "seuly://user@auth-recovery?code=example",
            "seuly://auth-recovery:443?code=example",
            "seuly://auth-recovery/extra?code=example",
            "seuly://auth-recovery.example?code=example"
        ]

        for value in invalidURLs {
            let url = try XCTUnwrap(URL(string: value))
            XCTAssertNil(AppConfiguration.authCallback(for: url))
        }
    }

    func testInvalidCallbackNeverStartsRecovery() async throws {
        let defaults = try XCTUnwrap(
            UserDefaults(suiteName: "InvalidCallback.\(UUID())")
        )
        let model = try makeModel(defaults: defaults)
        let url = try XCTUnwrap(
            URL(string: "seuly://auth-recovery/invalid?code=example")
        )

        do {
            try await model.handle(url: url)
            XCTFail("Expected an invalid callback error.")
        } catch {
            XCTAssertFalse(model.isPasswordRecovery)
            XCTAssertNotNil(model.errorMessage)
        }
    }

    func testRejectedSupabaseCallbackNeverStartsRecovery() async throws {
        let defaults = try XCTUnwrap(
            UserDefaults(suiteName: "RejectedCallback.\(UUID())")
        )
        let model = try makeModel(defaults: defaults)
        let url = try XCTUnwrap(URL(
            string: "seuly://auth-recovery?error=access_denied"
        ))

        do {
            try await model.handle(url: url)
            XCTFail("Expected Supabase to reject the callback.")
        } catch {
            XCTAssertFalse(model.isPasswordRecovery)
        }
    }

    private func makeModel(defaults: UserDefaults) throws -> AuthModel {
        let client = SupabaseClient(
            supabaseURL: try XCTUnwrap(
                URL(string: "https://example.supabase.co")
            ),
            supabaseKey: String(repeating: "a", count: 40)
        )
        return AuthModel(client: client, defaults: defaults)
    }
}
