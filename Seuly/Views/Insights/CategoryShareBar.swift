import SwiftUI

/// Horizontal part-to-whole bar. Chosen over a pie because the categories are
/// long Arabic names that need to be read, and because segments this close in
/// size are far easier to compare along one axis.
struct CategoryShareBar: View {
    @Environment(\.seulyTheme) private var theme
    let shares: [InsightsViewModel.CategoryShare]

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 2) {
                ForEach(shares) { share in
                    Capsule(style: .continuous)
                        .fill(theme.chartRampColor(rank: share.rank))
                        .frame(width: width(for: share, in: proxy.size.width))
                }
            }
        }
        .frame(height: 14)
        .animation(SeulyMotion.content, value: shares.map(\.fraction))
        .accessibilityHidden(true)
    }

    /// Segments keep a visible minimum so a one-percent slice does not vanish,
    /// and the 2pt gutters are removed from the pool before dividing.
    private func width(
        for share: InsightsViewModel.CategoryShare,
        in total: CGFloat
    ) -> CGFloat {
        let gutters = CGFloat(max(shares.count - 1, 0)) * 2
        let available = max(total - gutters, 0)
        return max(available * share.fraction, 3)
    }
}
