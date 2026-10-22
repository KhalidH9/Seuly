import XCTest
@testable import Seuly

final class FinancialSafetyTests: XCTestCase {
    func testLocalDateSurvivesTimezoneChanges() throws {
        let value = try LocalDate(databaseValue: "2026-03-08")
        var riyadh = Calendar(identifier: .gregorian)
        riyadh.timeZone = TimeZone(identifier: "Asia/Riyadh")!
        var losAngeles = Calendar(identifier: .gregorian)
        losAngeles.timeZone = TimeZone(identifier: "America/Los_Angeles")!

        XCTAssertEqual(
            LocalDate(
                date: value.date(timeZone: riyadh.timeZone),
                timeZone: riyadh.timeZone
            ),
            value
        )
        XCTAssertEqual(
            LocalDate(
                date: value.date(timeZone: losAngeles.timeZone),
                timeZone: losAngeles.timeZone
            ),
            value
        )
        XCTAssertEqual(value.databaseValue, "2026-03-08")
    }

    func testInvalidLocalDateIsRejected() {
        XCTAssertThrowsError(
            try LocalDate(databaseValue: "2026-02-30")
        )
    }

    func testFutureDateRangeIncludesAllOfToday() throws {
        let timeZone = try XCTUnwrap(TimeZone(identifier: "Asia/Riyadh"))
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let reference = try XCTUnwrap(
            calendar.date(
                from: DateComponents(
                    year: 2026,
                    month: 8,
                    day: 1,
                    hour: 18
                )
            )
        )

        let range = FinanceCalendar.futureDateRange(
            referenceDate: reference,
            calendar: calendar
        )
        XCTAssertTrue(range.contains(calendar.startOfDay(for: reference)))
    }

    func testMoneyArithmeticClampsInsteadOfOverflowing() {
        XCTAssertEqual(Int64.max.addingClamped(1), .max)
        XCTAssertEqual(Int64.min.subtractingClamped(1), .min)
        XCTAssertEqual(Int64.min.magnitudeClamped, .max)
        XCTAssertEqual([Int64.max, 1].sumClamped(), .max)
    }

    func testCurrencyRejectsAmountsBeyondStoragePolicy() {
        XCTAssertNil(
            TestData.currency.minorUnits(
                from: "90000000000001.00"
            )
        )
    }
}
