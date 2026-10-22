import SwiftUI

/// Feedback hues for banners, pills, and pulse states.
extension SeulyTheme {
    var success: Color { income }
    var successBackground: Color { incomeLight }
    var successText: Color { incomeText }
    var error: Color { expense }
    var errorBackground: Color { expenseLight }
    var errorText: Color { expenseText }
    var warning: Color {
        SeulyDynamicColor.make(light: "C07C10", dark: "F5B84C")
    }
    var warningBackground: Color {
        SeulyDynamicColor.make(
            light: "FDF2DC",
            dark: "31250F",
            lightContrast: "FAE5BC",
            darkContrast: "463418"
        )
    }
    var warningText: Color {
        SeulyDynamicColor.make(
            light: "8A5709",
            dark: "F8CD7E",
            lightContrast: "693F04",
            darkContrast: "FADEA8"
        )
    }
    var information: Color {
        SeulyDynamicColor.make(light: "2F6FC0", dark: "6BA6EE")
    }
    var informationBackground: Color {
        SeulyDynamicColor.make(
            light: "E6EFFB",
            dark: "122239",
            lightContrast: "CEE0F7",
            darkContrast: "1A314F"
        )
    }
    var informationText: Color {
        SeulyDynamicColor.make(
            light: "1F4E8C",
            dark: "97C1F3",
            lightContrast: "143664",
            darkContrast: "BAD6F8"
        )
    }
    var neutral: Color {
        SeulyDynamicColor.system(.secondaryLabel)
    }
    var neutralBackground: Color {
        SeulyDynamicColor.system(.tertiarySystemFill)
    }
    var neutralText: Color {
        SeulyDynamicColor.system(.secondaryLabel)
    }
}
