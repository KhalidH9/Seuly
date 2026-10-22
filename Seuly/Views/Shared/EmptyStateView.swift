import SwiftUI

/// Empty and no-result states. Built on the platform's own unavailable-content
/// layout so the glyph size, spacing, and text metrics match every other app.
struct EmptyStateView: View {
    @Environment(\.seulyTheme) private var theme
    let systemImage: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        ContentUnavailableView {
            Label {
                Text(title)
            } icon: {
                Image(systemName: systemImage)
                    .foregroundStyle(theme.brandPrimary)
            }
        } description: {
            Text(message)
        } actions: {
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(SeulySecondaryButtonStyle())
            }
        }
        .padding(.vertical, SeulyLayout.spacingS)
    }
}
