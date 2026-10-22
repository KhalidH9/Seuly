import SwiftUI

struct SafeToSpendExplanationView: View {
    @Environment(\.seulyTheme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingM) {
            Text(L10n.text("safe.explanation.title", table: .dashboard))
                .font(SeulyFont.cardTitle)
                .foregroundStyle(theme.textPrimary)
            Text(L10n.text("safe.explanation.message", table: .dashboard))
                .font(SeulyFont.subheadline)
                .foregroundStyle(theme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(SeulyLayout.spacingXL)
        .frame(maxWidth: 320)
        .presentationCompactAdaptation(.popover)
    }
}
