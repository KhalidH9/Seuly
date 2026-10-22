import SwiftUI

struct ConfigurationRequiredView: View {
    @Environment(\.seulyTheme) private var theme
    let message: String

    var body: some View {
        VStack(spacing: SeulyLayout.sectionSpacing) {
            SeulyLogo(size: 64, showsWordmark: true)
            EmptyStateView(
                systemImage: "key.horizontal.fill",
                title: L10n.text("configuration.title", table: .app),
                message: message
            )
        }
        .padding(SeulyLayout.screenPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.backgroundPrimary.ignoresSafeArea())
    }
}
