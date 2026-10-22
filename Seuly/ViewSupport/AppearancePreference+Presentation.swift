import SwiftUI

extension AppearancePreference {
    var displayName: String {
        L10n.text("appearance.\(rawValue)", table: .settings)
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}
