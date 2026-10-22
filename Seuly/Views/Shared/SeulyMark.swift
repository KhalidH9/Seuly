import SwiftUI

/// The bare monogram. No tile, no fill behind it: the glyph is a template
/// image so it takes the tint it is given and sits directly on the page.
struct SeulyMark: View {
    @Environment(\.seulyTheme) private var theme
    var size: CGFloat = 44
    var tint: Color?

    var body: some View {
        Image("SeulyMonogram")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundStyle(tint ?? theme.brandPrimary)
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}
