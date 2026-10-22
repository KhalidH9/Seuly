import SwiftUI

/// Brand layer of the design system. Surfaces, text, and separators come from
/// the platform semantic colors; only these brand tokens are authored.
struct SeulyTheme {
    let colorScheme: ColorScheme

    /// Solid teal used behind white labels. Held at one value across both
    /// appearances so the 4.9:1 white-on-teal contrast never regresses.
    var brandFill: Color {
        SeulyDynamicColor.make(
            light: "0A7F73",
            dark: "0A7F73",
            lightContrast: "05655B",
            darkContrast: "05655B"
        )
    }
    /// Teal for labels, glyphs, and control tints drawn on a page surface.
    var brandPrimary: Color {
        SeulyDynamicColor.make(
            light: "07675D",
            dark: "3FD0BF",
            lightContrast: "044A43",
            darkContrast: "6BE3D5"
        )
    }
    var brandPrimaryDark: Color {
        SeulyDynamicColor.make(light: "05534B", dark: "2AB7A7")
    }
    var brandPrimaryLight: Color {
        SeulyDynamicColor.make(light: "27C7B8", dark: "6BE3D5")
    }
    /// Tinted chip and badge background.
    var brandPrimarySoft: Color {
        SeulyDynamicColor.make(
            light: "D9F3EF",
            dark: "10322E",
            lightContrast: "BEE9E2",
            darkContrast: "16463F"
        )
    }
    var brandPrimarySubtle: Color {
        SeulyDynamicColor.make(light: "EDF9F7", dark: "0C2521")
    }
    var accent: Color { brandPrimary }
    var accentDark: Color { brandPrimaryDark }
    var accentLight: Color { brandPrimaryLight }
    var accentSoft: Color { brandPrimarySubtle }
    var secondary: Color {
        SeulyDynamicColor.make(light: "173B57", dark: "AFC8DA")
    }
    var secondaryDark: Color {
        SeulyDynamicColor.make(light: "102C42", dark: "8DAFC7")
    }
    var secondaryLight: Color {
        SeulyDynamicColor.make(light: "DCEAF2", dark: "16283A")
    }
    /// Always-white label for use on `brandFill` and other saturated fills.
    var onBrandFill: Color { Color.white }
}
