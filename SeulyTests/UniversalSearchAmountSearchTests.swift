import XCTest
@testable import Seuly

final class UniversalSearchAmountSearchTests: XCTestCase {
    func testArabicAndWesternMajorAmountsMatchExactly() {
        let subject = catalog(amountMinor: 400_000)

        XCTAssertFalse(subject.search(
            query: "٤٠٠٠",
            scope: .transaction
        ).isEmpty)
        XCTAssertFalse(subject.search(
            query: "4000",
            scope: .transaction
        ).isEmpty)
    }

    func testMajorAmountDoesNotMatchLongerAmount() {
        let subject = catalog(amountMinor: 400_000)
        XCTAssertTrue(subject.search(
            query: "40000",
            scope: .transaction
        ).isEmpty)
    }

    func testNumericPrefixDoesNotMatchLargerDisplayedAmount() {
        let subject = catalog(amountMinor: 4_000_000)
        XCTAssertTrue(subject.search(
            query: "4000",
            scope: .transaction
        ).isEmpty)
    }

    func testAmountTermsNeverContainRawMinorUnits() {
        let terms = UniversalSearchAmountTerms.make(
            minorUnits: 400_000,
            currency: TestData.currency
        )
        XCTAssertFalse(terms.split(separator: " ").contains("400000"))
    }

    func testSaudiRiyalAliasesAreSensitiveSearchTerms() {
        let subject = catalog(amountMinor: 400_000)

        for query in [
            "SAR", "Saudi Riyal", "الريال السعودي", "\u{20C1}"
        ] {
            XCTAssertFalse(subject.search(
                query: query,
                scope: .transaction
            ).isEmpty)
            XCTAssertTrue(subject.search(
                query: query,
                scope: .transaction,
                includesAmounts: false
            ).isEmpty)
        }
    }

    private func catalog(amountMinor: Int64) -> UniversalSearchCatalog {
        var workspace = TestData.searchWorkspace()
        workspace.transactions = [TestData.transaction(
            kind: .expense,
            amount: amountMinor,
            day: 8
        )]
        return UniversalSearchCatalog(
            workspace: workspace,
            referenceDate: TestData.referenceDate
        )
    }
}
