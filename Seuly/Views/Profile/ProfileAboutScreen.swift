import SwiftUI

/// About: the brand mark, what the app is for, and the exact build running.
struct ProfileAboutScreen: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: SettingsViewModel

    var body: some View {
        List {
            Section {
                brandCard.seulyPlainListRow()
            }
            Section {
                ProfileNavigationRow(
                    systemImage: "number",
                    tint: theme.brandPrimary,
                    title: L10n.text("about.version", table: .settings),
                    value: viewModel.appVersionText
                )
                ProfileNavigationRow(
                    systemImage: "hammer.fill",
                    tint: theme.transfer,
                    title: L10n.text("about.build", table: .settings),
                    value: viewModel.appBuildText,
                    forcesValueDirection: true
                )
            } header: {
                Text(L10n.text("about.title", table: .settings))
            } footer: {
                Text(L10n.text("about.footer", table: .settings))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(L10n.text("about.title", table: .settings))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var brandCard: some View {
        SeulyCard {
            VStack(spacing: SeulyLayout.spacingM) {
                SeulyMark(size: 64)
                Text(L10n.text("brand.name", table: .shared))
                    .font(SeulyFont.heroTitle)
                    .foregroundStyle(theme.textPrimary)
                Text(L10n.text("brand.tagline", table: .shared))
                    .font(SeulyFont.subheadline)
                    .foregroundStyle(theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, SeulyLayout.spacingS)
        }
        .accessibilityElement(children: .combine)
    }
}
