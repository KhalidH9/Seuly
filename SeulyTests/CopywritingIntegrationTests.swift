import XCTest
@testable import Seuly

final class CopywritingIntegrationTests: XCTestCase {
    func testInlineAmountTemplatesContainOnePlaceholder() {
        let templates = [
            L10n.text("safe.per_day", table: .dashboard),
            L10n.text("budget.of_limit", table: .shared)
        ]

        for template in templates {
            XCTAssertEqual(
                template.components(separatedBy: "%@").count,
                2
            )
        }
    }

    func testCurrencyOptionUsesLocalizedNameBeforeCode() {
        let result = L10n.format(
            "identity.currency.option",
            table: .onboarding,
            "SAR",
            "الريال السعودي"
        )
        let visibleText = result.filter {
            $0 != "\u{2068}" && $0 != "\u{2069}"
        }

        XCTAssertEqual(
            visibleText,
            "الريال السعودي (SAR)"
        )
    }
}
