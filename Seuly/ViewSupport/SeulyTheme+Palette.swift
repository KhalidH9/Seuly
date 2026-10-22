import SwiftUI

/// Money-direction hues: money in, money out, money moved. Each family has a
/// base tint, a pressed tone, a soft chip fill, and a label for that fill.
extension SeulyTheme {
    var income: Color {
        SeulyDynamicColor.make(light: "12945E", dark: "34D399")
    }
    var incomeDark: Color {
        SeulyDynamicColor.make(light: "0C7047", dark: "10B981")
    }
    var incomeLight: Color {
        SeulyDynamicColor.make(
            light: "DCF6E9",
            dark: "0F2C21",
            lightContrast: "BFEDD8",
            darkContrast: "154034"
        )
    }
    var incomeText: Color {
        SeulyDynamicColor.make(
            light: "0A5F3C",
            dark: "5BE0AC",
            lightContrast: "064129",
            darkContrast: "8AEDC6"
        )
    }
    var expense: Color {
        SeulyDynamicColor.make(light: "D93F3F", dark: "FF6B6B")
    }
    var expenseDark: Color {
        SeulyDynamicColor.make(light: "B02F2F", dark: "F04747")
    }
    var expenseLight: Color {
        SeulyDynamicColor.make(
            light: "FCE6E6",
            dark: "331819",
            lightContrast: "F8CFCF",
            darkContrast: "48201F"
        )
    }
    var expenseText: Color {
        SeulyDynamicColor.make(
            light: "9E2A2A",
            dark: "FF9494",
            lightContrast: "781E1E",
            darkContrast: "FFB4B4"
        )
    }
    var transfer: Color {
        SeulyDynamicColor.make(light: "3A7FC1", dark: "6FADE6")
    }
    var transferDark: Color {
        SeulyDynamicColor.make(light: "2C6299", dark: "4E93D4")
    }
    var transferLight: Color {
        SeulyDynamicColor.make(
            light: "E4EFFA",
            dark: "13253A",
            lightContrast: "CBE1F5",
            darkContrast: "1B3550"
        )
    }
    var transferText: Color {
        SeulyDynamicColor.make(
            light: "245782",
            dark: "94C4EE",
            lightContrast: "173D5D",
            darkContrast: "B6D8F5"
        )
    }
}
