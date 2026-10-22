import XCTest
@testable import Seuly

final class UniversalSearchMatcherTests: XCTestCase {
    func testArabicVariantsAndDigitsNormalizeConsistently() {
        XCTAssertEqual(
            UniversalSearchMatcher.normalize("إشتراك ١٢٣"),
            UniversalSearchMatcher.normalize("اشتراك 123")
        )
        XCTAssertEqual(
            UniversalSearchMatcher.normalize("مَدْرَسَة"),
            UniversalSearchMatcher.normalize("مدرسه")
        )
    }

    func testSaudiRiyalSignNormalizesToCurrencyCode() {
        XCTAssertEqual(
            UniversalSearchMatcher.normalize("\u{20C1}"),
            UniversalSearchMatcher.normalize("SAR")
        )
    }

    func testTitleMatchRanksAboveSupportingTextMatch() throws {
        let titleMatch = result(title: "شركة النور", terms: "")
        let supportingMatch = result(title: "شركة أخرى", terms: "بنك النور")
        let firstScore = try XCTUnwrap(
            UniversalSearchMatcher.score(query: "النور", result: titleMatch)
        )
        let secondScore = try XCTUnwrap(
            UniversalSearchMatcher.score(query: "النور", result: supportingMatch)
        )
        XCTAssertGreaterThan(firstScore, secondScore)
    }

    func testEveryQueryTokenMustMatch() {
        let candidate = result(title: "اشتراك الإنترنت", terms: "شهري")
        XCTAssertNotNil(
            UniversalSearchMatcher.score(
                query: "اشتراك شهري",
                result: candidate
            )
        )
        XCTAssertNil(
            UniversalSearchMatcher.score(
                query: "اشتراك سنوي",
                result: candidate
            )
        )
    }

    private func result(
        title: String,
        terms: String
    ) -> UniversalSearchResult {
        let id = UUID()
        return UniversalSearchResult(
            id: .account(id),
            kind: .account,
            title: title,
            subtitle: "",
            destination: .account(id),
            searchTerms: terms
        )
    }
}
