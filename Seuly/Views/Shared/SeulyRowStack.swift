import SwiftUI

/// Rows separated by hairlines, with no trailing rule after the last one.
/// Replaces the hand-indexed `enumerated()` and divider arithmetic that every
/// card-with-rows section used to repeat.
struct SeulyRowStack<Data: RandomAccessCollection, Row: View>: View
where Data.Element: Identifiable {
    @Environment(\.seulyTheme) private var theme
    let data: Data
    var spacing: CGFloat = SeulyLayout.spacingS
    @ViewBuilder let row: (Data.Element) -> Row

    var body: some View {
        VStack(spacing: 0) {
            ForEach(data) { element in
                row(element)
                if element.id != data.last?.id {
                    Divider()
                        .overlay(theme.divider)
                        .padding(.vertical, spacing)
                }
            }
        }
    }
}
