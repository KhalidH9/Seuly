import SwiftUI

/// One figure in the profile snapshot. The value is supplied as content so
/// the tile serves money amounts and plain counts alike.
struct ProfileStatTile<Value: View>: View {
    @Environment(\.seulyTheme) private var theme
    let title: String
    let systemImage: String
    let tint: Color
    private let value: Value

    init(
        title: String,
        systemImage: String,
        tint: Color,
        @ViewBuilder value: () -> Value
    ) {
        self.title = title
        self.systemImage = systemImage
        self.tint = tint
        self.value = value()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingS) {
            SeulyIconTile(
                systemImage: systemImage,
                tint: tint,
                background: tint.opacity(0.14),
                size: SeulyLayout.compactIcon
            )
            value
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(title)
                .font(SeulyFont.caption)
                .foregroundStyle(theme.textSecondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(SeulyLayout.spacingM)
        .background(
            theme.surfaceSecondary,
            in: RoundedRectangle(
                cornerRadius: SeulyLayout.controlRadius,
                style: .continuous
            )
        )
        .accessibilityElement(children: .combine)
    }
}
