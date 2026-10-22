import SwiftUI

/// Strips a list row back to bare canvas so the content can supply its own
/// card surface. Used wherever a card is placed inside a `List`, instead of
/// repeating three row modifiers at every site.
extension View {
    func seulyPlainListRow(
        horizontalInset: CGFloat = 0
    ) -> some View {
        listRowBackground(Color.clear)
            .listRowInsets(
                EdgeInsets(
                    top: 0,
                    leading: horizontalInset,
                    bottom: 0,
                    trailing: horizontalInset
                )
            )
            .listRowSeparator(.hidden)
    }
}
