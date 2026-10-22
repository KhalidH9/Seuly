import SwiftUI

/// Label for an action that can be in flight. Swaps the title for the brand
/// activity mark and holds the button's width steady while it works.
struct SeulyButtonLabel: View {
    let title: String
    var isBusy: Bool
    var tint: Color?

    var body: some View {
        ZStack {
            Text(title).opacity(isBusy ? 0 : 1)
            if isBusy {
                SeulyActivityIndicator(size: 24, tint: tint ?? .white)
            }
        }
        .accessibilityLabel(title)
        .accessibilityAddTraits(isBusy ? .updatesFrequently : [])
    }
}
