import SwiftUI

/// Track-and-fill progress indicator. Draws in layout direction so the fill
/// grows from the leading edge in right-to-left as well.
struct SeulyProgressBar: View {
    @Environment(\.seulyTheme) private var theme
    let progress: Double
    var tint: Color?
    var height: CGFloat = 8

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule(style: .continuous)
                    .fill(theme.fillTertiary)
                Capsule(style: .continuous)
                    .fill(tint ?? theme.brandPrimary)
                    .frame(width: max(proxy.size.width * boundedProgress, 0))
            }
        }
        .frame(height: height)
        .animation(SeulyMotion.content, value: boundedProgress)
        .accessibilityValue(
            L10n.format(
                "progress.accessibility",
                table: .shared,
                AppFormatters.integer(Int(boundedProgress * 100))
            )
        )
    }

    private var boundedProgress: Double {
        min(max(progress, 0), 1)
    }
}
