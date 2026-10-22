import SwiftUI

struct WorkspaceUnavailableView: View {
    @Environment(\.seulyTheme) private var theme
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: SeulyLayout.sectionSpacing) {
            SeulyLogo(size: 64, showsWordmark: true)
            EmptyStateView(
                systemImage: "wifi.exclamationmark",
                title: L10n.text("workspace.title", table: .app),
                message: message,
                actionTitle: L10n.text("workspace.retry", table: .app),
                action: retry
            )
        }
        .padding(SeulyLayout.screenPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.backgroundPrimary.ignoresSafeArea())
    }
}
