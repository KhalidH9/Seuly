import Supabase
import XCTest
@testable import Seuly

final class AuthSessionPolicyTests: XCTestCase {
    func testClientOptsIntoImmediateLocalSessionEmission() {
        XCTAssertTrue(
            SupabaseConfiguration.authOptions
                .emitLocalSessionAsInitialSession
        )
    }

    func testExpiredInitialSessionCannotAuthenticate() {
        XCTAssertFalse(
            AuthSessionPolicy.allowsAuthentication(
                for: .initialSession,
                sessionIsExpired: true
            )
        )
    }

    func testExpiredInitialSessionWaitsForRefresh() {
        XCTAssertTrue(
            AuthSessionPolicy.shouldIgnore(
                event: .initialSession,
                sessionIsExpired: true
            )
        )
    }

    func testValidInitialSessionCanAuthenticate() {
        XCTAssertTrue(
            AuthSessionPolicy.allowsAuthentication(
                for: .initialSession,
                sessionIsExpired: false
            )
        )
    }

    func testTerminalEventsCannotAuthenticate() {
        for event in [AuthChangeEvent.signedOut, .userDeleted] {
            XCTAssertFalse(
                AuthSessionPolicy.allowsAuthentication(
                    for: event,
                    sessionIsExpired: false
                )
            )
        }
    }
}
