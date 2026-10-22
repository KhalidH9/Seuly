import SwiftUI

struct ErrorBanner: View {
    @Environment(\.seulyTheme) private var theme
    let message: String
    var retry: (() -> Void)?

    var body: some View {
        HStack(alignment: .top, spacing: SeulyLayout.spacingM) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(SeulyFont.subheadlineEmphasized)
                .foregroundStyle(theme.error)
            Text(message)
                .font(SeulyFont.subheadline)
                .foregroundStyle(theme.errorText)
                .frame(maxWidth: .infinity, alignment: .leading)
            if let retry {
                Button(L10n.text("retry", table: .shared), action: retry)
                    .font(SeulyFont.subheadlineEmphasized)
                    .foregroundStyle(theme.errorText)
            }
        }
        .padding(SeulyLayout.spacingM)
        .background(
            theme.errorBackground,
            in: RoundedRectangle(
                cornerRadius: SeulyLayout.controlRadius,
                style: .continuous
            )
        )
        .accessibilityElement(children: .combine)
    }
}
