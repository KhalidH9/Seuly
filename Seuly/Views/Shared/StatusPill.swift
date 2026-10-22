import SwiftUI

struct StatusPill: View {
    enum Kind {
        case success
        case warning
        case error
        case information
        case neutral
    }

    @Environment(\.seulyTheme) private var theme
    let title: String
    let kind: Kind
    var systemImage: String?

    var body: some View {
        HStack(spacing: SeulyLayout.spacingXS) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(SeulyFont.caption2.weight(.bold))
            }
            Text(title)
                .font(SeulyFont.captionEmphasized)
        }
        .foregroundStyle(colors.foreground)
        .padding(.horizontal, SeulyLayout.spacingS)
        .padding(.vertical, 5)
        .background(colors.background, in: Capsule())
        .accessibilityElement(children: .combine)
    }

    private var colors: (foreground: Color, background: Color) {
        switch kind {
        case .success: (theme.successText, theme.successBackground)
        case .warning: (theme.warningText, theme.warningBackground)
        case .error: (theme.errorText, theme.errorBackground)
        case .information:
            (theme.informationText, theme.informationBackground)
        case .neutral: (theme.neutralText, theme.neutralBackground)
        }
    }
}
