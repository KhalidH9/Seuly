import SwiftUI

/// Injects the theme, the global tint, and the language environment.
///
/// Locale and layout direction are applied here rather than at the scene, so
/// switching language re-renders the whole tree with the new direction instead
/// of requiring a relaunch.
struct ThemeHostView: View {
    @Environment(\.colorScheme) private var colorScheme
    let viewModel: AppViewModel

    var body: some View {
        RootView(viewModel: viewModel)
            .environment(\.seulyTheme, theme)
            .environment(\.locale, language.locale)
            .environment(\.layoutDirection, language.layoutDirection)
            .preferredColorScheme(viewModel.appearance.colorScheme)
            .tint(theme.brandPrimary)
            .id(language)
    }

    private var language: AppLanguage { viewModel.language }

    private var theme: SeulyTheme {
        SeulyTheme(colorScheme: colorScheme)
    }
}
