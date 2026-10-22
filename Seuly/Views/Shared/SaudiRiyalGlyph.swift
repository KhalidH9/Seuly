import SwiftUI

struct SaudiRiyalGlyph: View {
    private static let aspectRatio: CGFloat = 1124.14 / 1256.39
    @ScaledMetric private var height: CGFloat

    init(scale: SaudiRiyalSymbolScale = .body) {
        _height = ScaledMetric(
            wrappedValue: scale.baseHeight,
            relativeTo: scale.relativeTextStyle
        )
    }

    var body: some View {
        Image("SaudiRiyalSymbol")
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(
                width: height * Self.aspectRatio,
                height: height
            )
            .accessibilityHidden(true)
    }
}
