import SwiftUI

struct InfoCalloutView: View {
    @Environment(\.seulyTheme) private var theme
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: SeulyLayout.spacingS) {
            Image(systemName: "info.circle.fill")
                .font(SeulyFont.footnoteEmphasized)
                .foregroundStyle(theme.information)
            Text(message)
                .font(SeulyFont.footnote)
                .foregroundStyle(theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }
}
