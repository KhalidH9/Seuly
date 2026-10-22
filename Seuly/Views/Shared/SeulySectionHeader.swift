import SwiftUI

/// Section header for card stacks. Title carries the weight, the optional
/// subtitle explains, and the trailing action stays a plain text button.
struct SeulySectionHeader: View {
    @Environment(\.seulyTheme) private var theme
    let title: String
    var subtitle: String?
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: SeulyLayout.spacingM) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(SeulyFont.sectionTitle)
                    .foregroundStyle(theme.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(SeulyFont.footnote)
                        .foregroundStyle(theme.textSecondary)
                }
            }
            Spacer(minLength: SeulyLayout.spacingS)
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(SeulyTertiaryButtonStyle())
            }
        }
        .accessibilityElement(children: .combine)
    }
}
