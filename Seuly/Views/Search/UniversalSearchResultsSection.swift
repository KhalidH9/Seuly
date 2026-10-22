import SwiftUI

struct UniversalSearchResultsSection: View {
    @Environment(\.seulyTheme) private var theme
    let section: UniversalSearchSection
    let hidesAmount: Bool
    let currency: (String?) -> CurrencyDefinition?
    let onSelect: (UniversalSearchResult) -> Void

    var body: some View {
        Section {
            ForEach(section.results) { result in
                UniversalSearchResultRow(
                    result: result,
                    currency: currency(result.currencyCode),
                    hidesAmount: hidesAmount
                ) {
                    onSelect(result)
                }
            }
        } header: {
            Text(section.title)
                .font(SeulyFont.footnoteEmphasized)
                .foregroundStyle(theme.textSecondary)
        }
    }
}
