import XCTest
@testable import Seuly

final class PercentageFormatterTests: XCTestCase {
    func testWholeMagnitudeRoundsNormalRatios() {
        XCTAssertEqual(
            PercentageFormatter.wholeMagnitude(from: -0.126),
            13
        )
        XCTAssertEqual(
            PercentageFormatter.wholeMagnitudeText(from: 0.126),
            "13"
        )
    }

    func testWholeMagnitudeClampsExtremeRatios() {
        XCTAssertEqual(
            PercentageFormatter.wholeMagnitude(from: .greatestFiniteMagnitude),
            PercentageFormatter.maximumWholePercentage
        )
        XCTAssertEqual(
            PercentageFormatter.wholeMagnitudeText(from: .infinity),
            "999999+"
        )
        XCTAssertEqual(
            PercentageFormatter.wholeMagnitude(from: .nan),
            0
        )
    }
}
