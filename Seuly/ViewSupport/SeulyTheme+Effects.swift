import SwiftUI

/// Gradients, elevation, and chart colour. Elevation is deliberately scarce:
/// only the hero surface casts a shadow, everything else groups.
extension SeulyTheme {
    var shadow: Color {
        SeulyDynamicColor.make(light: "0F1F1C", dark: "000000")
            .opacity(colorScheme == .dark ? 0.44 : 0.07)
    }
    var heroShadow: Color {
        SeulyDynamicColor.make(light: "05534B", dark: "000000")
            .opacity(colorScheme == .dark ? 0.5 : 0.22)
    }
    var skeletonBase: Color { fillTertiary }
    var skeletonHighlight: Color { fillQuaternary }

    var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [
                SeulyDynamicColor.make(light: "05635A", dark: "064F48"),
                SeulyDynamicColor.make(light: "0A7F73", dark: "0A7268"),
                SeulyDynamicColor.make(light: "18A99A", dark: "12907F")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// Quiet tinted wash behind unauthenticated screens. Dark Mode gets the
    /// flat page colour instead: a tint laid over near-black only muddies it.
    var softBackgroundGradient: LinearGradient {
        LinearGradient(
            colors: colorScheme == .dark
                ? [backgroundPrimary, backgroundPrimary]
                : [brandPrimarySubtle, backgroundPrimary],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// Single-hue fill for magnitude charts. Spending is a quantity, not an
    /// identity, so one hue is the correct encoding.
    var chartSequential: Color {
        SeulyDynamicColor.make(light: "12786C", dark: "57C3B4")
    }

    /// Ordinal teal ramp, ordered most prominent first, for ranked shares.
    /// Both columns were validated as ordinal ramps against their own surface
    /// (monotone lightness, visible step gaps, light end clears 2:1).
    var chartRamp: [Color] {
        [
            SeulyDynamicColor.make(light: "04413B", dark: "A6E8DE"),
            SeulyDynamicColor.make(light: "0A5C54", dark: "7FD8CB"),
            SeulyDynamicColor.make(light: "12786C", dark: "57C3B4"),
            SeulyDynamicColor.make(light: "1E9384", dark: "37A99B"),
            SeulyDynamicColor.make(light: "38AE9E", dark: "237F75"),
            SeulyDynamicColor.make(light: "5AC3B4", dark: "175F57")
        ]
    }

    func chartRampColor(rank: Int) -> Color {
        chartRamp[min(max(rank, 0), chartRamp.count - 1)]
    }
}
