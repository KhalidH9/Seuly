import SwiftUI

/// The month in words. Numbered so the reader knows how many observations
/// there are before starting to read them.
struct InsightsMonthStoryCard: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: InsightsViewModel

    var body: some View {
        SeulyCard {
            VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
                HStack(alignment: .top, spacing: SeulyLayout.spacingM) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.text("story.eyebrow", table: .insights))
                            .seulyEyebrow()
                            .foregroundStyle(theme.brandPrimary)
                        Text(viewModel.storyHeadline)
                            .font(SeulyFont.sectionTitle)
                            .foregroundStyle(theme.textPrimary)
                    }
                    Spacer(minLength: 0)
                    SeulyIconTile(
                        systemImage: "text.bubble.fill",
                        tint: theme.brandPrimary,
                        background: theme.brandPrimarySoft
                    )
                }
                VStack(alignment: .leading, spacing: SeulyLayout.spacingM) {
                    ForEach(
                        Array(viewModel.analytics.insights.enumerated()),
                        id: \.offset
                    ) { index, insight in
                        insightRow(index: index, text: insight)
                    }
                }
            }
        }
    }

    private func insightRow(index: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: SeulyLayout.spacingM) {
            Text(AppFormatters.integer(index + 1))
                .font(SeulyFont.captionEmphasized)
                .monospacedDigit()
                .foregroundStyle(theme.brandPrimary)
                .frame(width: 22, height: 22)
                .background(theme.brandPrimarySoft, in: Circle())
                .accessibilityHidden(true)
            Text(text)
                .font(SeulyFont.subheadline)
                .foregroundStyle(theme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
