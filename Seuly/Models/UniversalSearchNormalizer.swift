import Foundation

enum UniversalSearchNormalizer {
    static func normalize(_ value: String) -> String {
        let folded = value.folding(
            options: [.caseInsensitive, .diacriticInsensitive, .widthInsensitive],
            locale: AppLocale.locale
        )
        var result = ""
        for scalar in folded.unicodeScalars {
            guard !isArabicMark(scalar.value) else { continue }
            result += replacement(for: scalar)
        }
        return result
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    private static func replacement(for scalar: Unicode.Scalar) -> String {
        switch scalar.value {
        case 0x20C1: "sar"
        case 0x0622, 0x0623, 0x0625: "\u{0627}"
        case 0x0649, 0x0626: "\u{064A}"
        case 0x0624: "\u{0648}"
        case 0x0629: "\u{0647}"
        case 0x0660, 0x06F0: "0"
        case 0x0661, 0x06F1: "1"
        case 0x0662, 0x06F2: "2"
        case 0x0663, 0x06F3: "3"
        case 0x0664, 0x06F4: "4"
        case 0x0665, 0x06F5: "5"
        case 0x0666, 0x06F6: "6"
        case 0x0667, 0x06F7: "7"
        case 0x0668, 0x06F8: "8"
        case 0x0669, 0x06F9: "9"
        default: String(scalar)
        }
    }

    private static func isArabicMark(_ value: UInt32) -> Bool {
        value == 0x0640
            || (0x0610...0x061A).contains(value)
            || (0x064B...0x065F).contains(value)
            || value == 0x0670
            || (0x06D6...0x06ED).contains(value)
    }
}
