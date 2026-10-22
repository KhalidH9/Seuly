import SwiftUI

/// Appearance choice. A checkmark list rather than a segmented row: the
/// options are named, not compared, and the list scales with type size.
struct ProfileAppearanceScreen: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        List {
            Section {
                ForEach(AppearancePreference.allCases) { appearance in
                    Button {
                        withAnimation(SeulyMotion.interactive) {
                            viewModel.appearance = appearance
                        }
                    } label: {
                        row(for: appearance)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(
                        viewModel.appearance == appearance ? .isSelected : []
                    )
                }
            } header: {
                Text(L10n.text("appearance.title", table: .settings))
            } footer: {
                Text(L10n.text("appearance.subtitle", table: .settings))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(L10n.text("appearance.title", table: .settings))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(for appearance: AppearancePreference) -> some View {
        HStack(spacing: SeulyLayout.spacingM) {
            SeulyIconTile(
                systemImage: icon(for: appearance),
                tint: theme.brandPrimary,
                background: theme.brandPrimarySoft,
                size: SeulyLayout.compactIcon
            )
            Text(appearance.displayName)
                .font(SeulyFont.body)
                .foregroundStyle(theme.textPrimary)
            Spacer()
            if viewModel.appearance == appearance {
                Image(systemName: "checkmark")
                    .font(SeulyFont.bodyEmphasized)
                    .foregroundStyle(theme.brandPrimary)
            }
        }
        .frame(minHeight: SeulyLayout.minimumTapTarget)
        .contentShape(Rectangle())
    }

    private func icon(for appearance: AppearancePreference) -> String {
        switch appearance {
        case .system: "circle.lefthalf.filled"
        case .light: "sun.max.fill"
        case .dark: "moon.stars.fill"
        }
    }
}
