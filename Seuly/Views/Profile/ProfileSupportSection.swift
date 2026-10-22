import SwiftUI

/// Routes into the reference material: how the data is protected, and what
/// build is installed.
struct ProfileSupportSection: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: SettingsViewModel

    var body: some View {
        Section {
            NavigationLink {
                ProfileSecurityScreen(viewModel: viewModel)
            } label: {
                ProfileNavigationRow(
                    systemImage: "lock.shield.fill",
                    tint: theme.income,
                    title: L10n.text("data.title", table: .settings),
                    subtitle: L10n.text("data.subtitle", table: .settings)
                )
            }
            NavigationLink {
                ProfileAboutScreen(viewModel: viewModel)
            } label: {
                ProfileNavigationRow(
                    systemImage: "info.circle.fill",
                    tint: theme.transfer,
                    title: L10n.text("about.title", table: .settings),
                    value: viewModel.appVersionText
                )
            }
        } header: {
            Text(L10n.text("support.title", table: .settings))
        }
    }
}
