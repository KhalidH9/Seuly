import XCTest
@testable import Seuly

@MainActor
final class PreferencesMigrationTests: XCTestCase {
    func testLegacyPreferencesMoveToSeulyKeys() throws {
        let suiteName = "PreferencesMigrationTests.\(UUID())"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }
        defaults.set(true, forKey: "siyuli.privacyMode")
        defaults.set("dark", forKey: "siyuli.appearance")
        defaults.set("en", forKey: "siyuli.language")

        let model = PreferencesModel(defaults: defaults)

        XCTAssertTrue(model.isPrivacyModeEnabled)
        XCTAssertEqual(model.appearance, .dark)
        XCTAssertEqual(model.language, .english)
        XCTAssertTrue(defaults.bool(forKey: "seuly.privacyMode"))
        XCTAssertNil(defaults.object(forKey: "siyuli.privacyMode"))
        XCTAssertNil(defaults.object(forKey: "siyuli.appearance"))
        XCTAssertNil(defaults.object(forKey: "siyuli.language"))
    }
}
