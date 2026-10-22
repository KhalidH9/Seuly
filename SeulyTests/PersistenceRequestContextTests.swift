import XCTest
@testable import Seuly

final class PersistenceRequestContextTests: XCTestCase {
    func testBeginFreezesIdentifierAndLocalDateAcrossRetries() {
        let identifier = UUID()
        let timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        var context = PersistenceRequestContext(id: identifier)

        let first = context.begin(
            referenceDate: TestData.date(year: 2026, month: 7, day: 31),
            timeZone: timeZone
        )
        let retry = context.begin(
            referenceDate: TestData.date(year: 2026, month: 8, day: 1),
            timeZone: timeZone
        )

        XCTAssertEqual(first.id, identifier)
        XCTAssertEqual(retry.id, identifier)
        XCTAssertEqual(first.localDate.databaseValue, "2026-07-31")
        XCTAssertEqual(retry.localDate, first.localDate)
    }
}
