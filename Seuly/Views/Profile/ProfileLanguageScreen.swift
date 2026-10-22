import SwiftUI

/// Language choice. Each option is written in its own language so it stays
/// readable whichever one is currently active.
struct ProfileLanguageScreen: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        List {
            Section {
                ForEach(AppLanguage.allCases) { language in
                    Button {
                        viewModel.language = language
                    } label: {
                        row(for: language)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(
                        viewModel.language == language ? .isSelected : []
                    )
                }
            } header: {
                Text(L10n.text("language.title", table: .settings))
            } footer: {
                Text(L10n.text("language.footer", table: .settings))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(L10n.text("language.title", table: .settings))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(for language: AppLanguage) -> some View {
        HStack(spacing: SeulyLayout.spacingM) {
            SeulyIconTile(
                systemImage: "character.bubble",
                tint: theme.brandPrimary,
                background: theme.brandPrimarySoft,
                size: SeulyLayout.compactIcon
            )
            Text(language.nativeName)
                .font(SeulyFont.body)
                .foregroundStyle(theme.textPrimary)
            Spacer(minLength: SeulyLayout.spacingS)
            if viewModel.language == language {
                Image(systemName: "checkmark")
                    .font(SeulyFont.bodyEmphasized)
                    .foregroundStyle(theme.brandPrimary)
            }
        }
        .frame(minHeight: SeulyLayout.minimumTapTarget)
        .contentShape(Rectangle())
    }
}
