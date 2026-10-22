import SwiftUI

/// Ring drawn around the card a search result opened, so the destination is
/// obvious after the jump.
struct SearchFocusBorder: View {
    @Environment(\.seulyTheme) private var theme
    let isVisible: Bool

    var body: some View {
        RoundedRectangle(
            cornerRadius: SeulyLayout.cardRadius,
            style: .continuous
        )
        .strokeBorder(theme.brandPrimary, lineWidth: isVisible ? 2 : 0)
        .animation(SeulyMotion.content, value: isVisible)
        .allowsHitTesting(false)
    }
}
