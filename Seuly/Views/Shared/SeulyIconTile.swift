import SwiftUI

/// The rounded glyph tile that leads rows, cards, and section headers. One
/// component so the tile size, radius, and glyph weight never drift apart.
struct SeulyIconTile: View {
    let systemImage: String
    let tint: Color
    let background: Color
    var size: CGFloat = SeulyLayout.rowIcon

    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: size * 0.42, weight: .semibold))
            .foregroundStyle(tint)
            .frame(width: size, height: size)
            .background(
                background,
                in: RoundedRectangle(
                    cornerRadius: size * 0.3,
                    style: .continuous
                )
            )
            .accessibilityHidden(true)
    }
}
