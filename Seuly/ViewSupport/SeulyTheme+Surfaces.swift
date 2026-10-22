import SwiftUI
import UIKit

/// Page and card surfaces plus the text hierarchy, mapped onto the platform
/// semantic colors so grouping, elevation, and legibility follow the system.
extension SeulyTheme {
    var backgroundPrimary: Color {
        SeulyDynamicColor.system(.systemGroupedBackground)
    }
    var backgroundSecondary: Color {
        SeulyDynamicColor.system(.secondarySystemGroupedBackground)
    }
    var backgroundTertiary: Color {
        SeulyDynamicColor.system(.tertiarySystemGroupedBackground)
    }
    /// Card surface. Reads as raised against `backgroundPrimary`.
    var surfacePrimary: Color {
        SeulyDynamicColor.system(.secondarySystemGroupedBackground)
    }
    /// Recessed surface for wells nested inside a card.
    var surfaceSecondary: Color {
        SeulyDynamicColor.system(.tertiarySystemGroupedBackground)
    }
    var surfaceElevated: Color {
        SeulyDynamicColor.system(.secondarySystemGroupedBackground)
    }
    var textPrimary: Color {
        SeulyDynamicColor.system(.label)
    }
    var textSecondary: Color {
        SeulyDynamicColor.system(.secondaryLabel)
    }
    var textTertiary: Color {
        SeulyDynamicColor.system(.tertiaryLabel)
    }
    var textDisabled: Color {
        SeulyDynamicColor.system(.quaternaryLabel)
    }
    /// Label drawn on a filled brand control. Dark in Dark Mode because the
    /// tint lightens there.
    var textInverse: Color {
        colorScheme == .dark
            ? SeulyDynamicColor.make(light: "111111", dark: "111111")
            : Color.white
    }
    var textLink: Color { brandPrimary }
}
