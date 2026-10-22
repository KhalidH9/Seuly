import SwiftUI

/// Preferences that change how the app presents itself: hiding amounts and
/// choosing an appearance.
struct ProfilePreferencesSection: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        Section {
            Toggle(isOn: $viewModel.isPrivacyModeEnabled) {
                ProfileNavigationRow(
                    systemImage: viewModel.isPrivacyModeEnabled
                        ? "eye.slash.fill"
                        : "eye.fill",
                    tint: theme.brandPrimary,
                    title: L10n.text("privacy.mode", table: .settings),
                    subtitle: L10n.text("privacy.help", table: .settings)
                )
            }
            .tint(theme.brandPrimary)
            NavigationLink {
                ProfileLanguageScreen(viewModel: viewModel)
            } label: {
                ProfileNavigationRow(
                    systemImage: "character.bubble",
                    tint: theme.transfer,
                    title: L10n.text("language.title", table: .settings),
                    value: viewModel.language.nativeName
                )
            }
            NavigationLink {
                ProfileAppearanceScreen(viewModel: viewModel)
            } label: {
                ProfileNavigationRow(
                    systemImage: "circle.lefthalf.filled",
                    tint: theme.investment,
                    title: L10n.text("appearance.title", table: .settings),
                    value: viewModel.appearance.displayName
                )
            }
        } header: {
            Text(L10n.text("preferences.title", table: .settings))
        } footer: {
            Text(L10n.text("privacy.subtitle", table: .settings))
        }
    }
}
