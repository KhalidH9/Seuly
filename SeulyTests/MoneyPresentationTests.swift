import XCTest
@testable import Seuly

final class MoneyPresentationTests: XCTestCase {
    func testSaudiRiyalUsesOfficialSemanticSymbol() {
        let currency = TestData.currency
        let subject = MoneyFormatter.presentation(
            minorUnits: 12_345,
            currency: currency
        )

        XCTAssertTrue(currency.isSaudiRiyal)
        XCTAssertEqual(currency.semanticSymbol, "\u{20C1}")
        XCTAssertTrue(subject.usesSaudiRiyalSymbol)
        XCTAssertTrue(subject.plainText.contains("\u{20C1}"))
        XCTAssertFalse(subject.plainText.contains("ر.س"))
        XCTAssertFalse(subject.plainText.contains("ê"))
    }

    func testAccessibilityUsesLocalizedCurrencyName() {
        let subject = MoneyFormatter.presentation(
            minorUnits: -12_345,
            currency: TestData.currency,
            compact: true
        )

        XCTAssertFalse(subject.sign.isEmpty)
        XCTAssertTrue(
            subject.accessibilityText.contains(TestData.currency.localizedName)
        )
        XCTAssertFalse(subject.accessibilityText.contains("ر.س"))
        XCTAssertFalse(subject.accessibilityText.contains("\u{20C1}"))
    }

    func testPositiveSignAndCompactVisualTextArePreserved() {
        let subject = MoneyFormatter.presentation(
            minorUnits: 125_000,
            currency: TestData.currency,
            showSign: true,
            compact: true
        )

        XCTAssertFalse(subject.sign.isEmpty)
        XCTAssertTrue(subject.plainText.hasPrefix(subject.sign))
        XCTAssertTrue(
            subject.amountText.contains(
                L10n.text("number.compact.thousand", table: .data)
            )
        )
    }

    func testOtherCurrenciesKeepSystemCurrencyFormatting() {
        let currency = CurrencyDefinition(
            code: "USD",
            name: "US Dollar",
            symbol: "$",
            minorUnit: 2,
            isActive: true
        )
        let subject = MoneyFormatter.presentation(
            minorUnits: 12_345,
            currency: currency
        )

        XCTAssertFalse(subject.usesSaudiRiyalSymbol)
        XCTAssertEqual(currency.semanticSymbol, "$")
        XCTAssertFalse(subject.plainText.contains("\u{20C1}"))
        XCTAssertTrue(subject.accessibilityText.contains(currency.localizedName))
    }
}
