import XCTest
@testable import Seuly

final class ArabicLocalizationTests: XCTestCase {
    func testEveryArabicTableIsBundledAndPopulated() throws {
        let bundle = try XCTUnwrap(arabicBundle)
        for table in L10nTable.allCases {
            let path = try XCTUnwrap(
                bundle.path(forResource: table.rawValue, ofType: "strings"),
                "Missing \(table.rawValue).strings"
            )
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let plist = try PropertyListSerialization.propertyList(
                from: data,
                format: nil
            )
            let values = try XCTUnwrap(plist as? [String: String])
            XCTAssertFalse(values.isEmpty, "Empty \(table.rawValue).strings")
            XCTAssertFalse(values.values.contains(where: \.isEmpty))
        }
    }

    func testArabicIsThePrimaryAppLocalization() {
        XCTAssertEqual(
            Bundle.main.object(
                forInfoDictionaryKey: "CFBundleDevelopmentRegion"
            ) as? String,
            AppLocale.languageCode
        )
        XCTAssertEqual(L10n.text("title", table: .settings), "الإعدادات")
    }

    func testSupabaseReferenceValuesUseArabicPresentation() {
        let category = FinanceCategory(
            id: UUID(), userID: UUID(), parentID: nil,
            kind: .expense, name: "Groceries", iconKey: "basket.fill",
            colorRole: .income, sortOrder: 0, archivedAt: nil
        )
        let custom = FinanceCategory(
            id: UUID(), userID: UUID(), parentID: nil,
            kind: .expense, name: "رحلات", iconKey: "airplane",
            colorRole: .teal, sortOrder: 1, archivedAt: nil
        )
        XCTAssertEqual(category.localizedName, "البقالة")
        XCTAssertEqual(custom.localizedName, "رحلات")
    }

    func testArabicPluralRouting() {
        XCTAssertEqual(ArabicPlural.suffix(for: 0), "zero")
        XCTAssertEqual(ArabicPlural.suffix(for: 1), "one")
        XCTAssertEqual(ArabicPlural.suffix(for: 2), "two")
        XCTAssertEqual(ArabicPlural.suffix(for: 7), "few")
        XCTAssertEqual(ArabicPlural.suffix(for: 15), "many")
        XCTAssertEqual(ArabicPlural.suffix(for: 102), "other")
    }

    private var arabicBundle: Bundle? {
        guard let path = Bundle.main.path(
            forResource: AppLocale.languageCode,
            ofType: "lproj"
        ) else { return nil }
        return Bundle(path: path)
    }
}
