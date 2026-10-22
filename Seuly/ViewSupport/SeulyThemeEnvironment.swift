import SwiftUI

private struct SeulyThemeKey: EnvironmentKey {
    static let defaultValue = SeulyTheme(colorScheme: .light)
}

extension EnvironmentValues {
    var seulyTheme: SeulyTheme {
        get { self[SeulyThemeKey.self] }
        set { self[SeulyThemeKey.self] = newValue }
    }
}

extension Color {
    init(hex: String) {
        self.init(uiColor: UIColor(hex: hex))
    }
}
