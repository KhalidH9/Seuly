import SwiftUI

struct AuthNoticeBanner: View {
    @Environment(\.seulyTheme) private var theme
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: SeulyLayout.spacingM) {
            Image(systemName: "checkmark.circle.fill")
                .font(SeulyFont.subheadlineEmphasized)
                .foregroundStyle(theme.success)
            Text(message)
                .font(SeulyFont.subheadline)
                .foregroundStyle(theme.successText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(SeulyLayout.spacingM)
        .background(
            theme.successBackground,
            in: RoundedRectangle(
                cornerRadius: SeulyLayout.controlRadius,
                style: .continuous
            )
        )
        .accessibilityElement(children: .combine)
    }
}
