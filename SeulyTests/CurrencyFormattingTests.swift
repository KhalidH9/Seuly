import XCTest
@testable import Seuly

final class CurrencyFormattingTests: XCTestCase {
    func testCurrencyMinorUnitConversion() {
        XCTAssertEqual(
            definition(code: "SAR", minorUnit: 2).minorUnits(from: "123.45"),
            12_345
        )
        XCTAssertEqual(
            definition(code: "KWD", minorUnit: 3).minorUnits(from: "12.345"),
            12_345
        )
        XCTAssertEqual(
            definition(code: "JPY", minorUnit: 0).minorUnits(from: "500"),
            500
        )
    }

    func testLocalizedCurrencyEditing() {
        let locale = Locale(identifier: "de_DE")

        XCTAssertEqual(
            definition(code: "EUR", minorUnit: 2).minorUnits(
                from: "1.234,56",
                locale: locale
            ),
            123_456
        )
        XCTAssertEqual(
            MoneyFormatter.editableString(
                minorUnits: 12_345,
                currency: definition(code: "EUR", minorUnit: 2),
                locale: locale
            ),
            "123,45"
        )
    }

    func testArabicAmountEntryAndEditing() {
        let currency = definition(code: "SAR", minorUnit: 2)

        XCTAssertEqual(
            currency.minorUnits(
                from: "١٢٣٫٤٥",
                locale: AppLocale.locale
            ),
            12_345
        )
        XCTAssertEqual(
            MoneyFormatter.editableString(
                minorUnits: 12_345,
                currency: currency,
                locale: AppLocale.locale
            ),
            "١٢٣٫٤٥"
        )
    }

    func testChartAxisMajorUnitsConvertSafely() {
        let currency = definition(code: "SAR", minorUnit: 2)

        XCTAssertEqual(
            currency.minorUnits(fromMajorUnits: 123.45),
            12_345
        )
        XCTAssertNil(currency.minorUnits(fromMajorUnits: .nan))
        XCTAssertNil(currency.minorUnits(fromMajorUnits: .infinity))
        XCTAssertNil(currency.minorUnits(fromMajorUnits: 1e20))
    }

    private func definition(
        code: String,
        minorUnit: Int
    ) -> CurrencyDefinition {
        CurrencyDefinition(
            code: code,
            name: code,
            symbol: code,
            minorUnit: minorUnit,
            isActive: true
        )
    }
}
