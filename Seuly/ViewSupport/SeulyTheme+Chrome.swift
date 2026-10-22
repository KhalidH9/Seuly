import SwiftUI
import UIKit

/// Separators, control fills, field chrome, and chart furniture.
extension SeulyTheme {
    var borderPrimary: Color {
        SeulyDynamicColor.system(.separator)
    }
    var borderSecondary: Color {
        SeulyDynamicColor.system(.separator)
    }
    var borderStrong: Color {
        SeulyDynamicColor.system(.opaqueSeparator)
    }
    var divider: Color {
        SeulyDynamicColor.system(.separator)
    }
    var focusBorder: Color { brandPrimary }
    var interactive: Color { brandPrimary }
    /// Neutral fills for unselected segments, wells, and skeletons.
    var fillPrimary: Color {
        SeulyDynamicColor.system(.systemFill)
    }
    var fillSecondary: Color {
        SeulyDynamicColor.system(.secondarySystemFill)
    }
    var fillTertiary: Color {
        SeulyDynamicColor.system(.tertiarySystemFill)
    }
    var fillQuaternary: Color {
        SeulyDynamicColor.system(.quaternarySystemFill)
    }
    var inputBackground: Color {
        SeulyDynamicColor.system(.tertiarySystemGroupedBackground)
    }
    var inputPlaceholder: Color {
        SeulyDynamicColor.system(.placeholderText)
    }
    var tabBarBackground: Color {
        SeulyDynamicColor.system(.systemBackground)
    }
    var navigationBackground: Color {
        SeulyDynamicColor.system(.systemGroupedBackground)
    }
    var chartGrid: Color {
        SeulyDynamicColor.system(.separator)
    }
    var chartAxis: Color {
        SeulyDynamicColor.system(.tertiaryLabel)
    }
}
