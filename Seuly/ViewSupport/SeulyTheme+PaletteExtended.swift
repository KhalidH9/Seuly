import SwiftUI

/// Account-flavour hues used by account, goal, and category color roles.
extension SeulyTheme {
    var savings: Color {
        SeulyDynamicColor.make(light: "27789F", dark: "5AB4DC")
    }
    var savingsDark: Color {
        SeulyDynamicColor.make(light: "1C5C7C", dark: "3E99C2")
    }
    var savingsLight: Color {
        SeulyDynamicColor.make(
            light: "E0F0F9",
            dark: "112733",
            lightContrast: "C6E4F3",
            darkContrast: "173849"
        )
    }
    var savingsText: Color {
        SeulyDynamicColor.make(
            light: "17526E",
            dark: "8CCCE8",
            lightContrast: "0E3A4F",
            darkContrast: "B2DDF1"
        )
    }
    var investment: Color {
        SeulyDynamicColor.make(light: "6B52BE", dark: "A794F5")
    }
    var investmentDark: Color {
        SeulyDynamicColor.make(light: "533D9C", dark: "8A73E8")
    }
    var investmentLight: Color {
        SeulyDynamicColor.make(
            light: "ECE8FD",
            dark: "211D3B",
            lightContrast: "DBD3FA",
            darkContrast: "2E2852"
        )
    }
    var investmentText: Color {
        SeulyDynamicColor.make(
            light: "48338C",
            dark: "C0B2F8",
            lightContrast: "32226A",
            darkContrast: "D5CBFB"
        )
    }
    var debt: Color {
        SeulyDynamicColor.make(light: "C4632F", dark: "F0925E")
    }
    var debtDark: Color {
        SeulyDynamicColor.make(light: "9E4A20", dark: "DB7642")
    }
    var debtLight: Color {
        SeulyDynamicColor.make(
            light: "FAEAE1",
            dark: "301E14",
            lightContrast: "F5D8C8",
            darkContrast: "442A1B"
        )
    }
    var debtText: Color {
        SeulyDynamicColor.make(
            light: "8B3E1B",
            dark: "F4AE85",
            lightContrast: "6A2D11",
            darkContrast: "F8C7A8"
        )
    }
}
