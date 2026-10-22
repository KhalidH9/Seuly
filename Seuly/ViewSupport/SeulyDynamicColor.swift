import SwiftUI
import UIKit

/// Builds trait-reactive colors so every token answers to Dark Mode and to
/// the Increase Contrast accessibility setting instead of a fixed hex value.
enum SeulyDynamicColor {
    static func make(
        light: String,
        dark: String,
        lightContrast: String? = nil,
        darkContrast: String? = nil
    ) -> Color {
        Color(
            uiColor: UIColor { traits in
                let increased = traits.accessibilityContrast == .high
                if traits.userInterfaceStyle == .dark {
                    return UIColor(
                        hex: increased ? (darkContrast ?? dark) : dark
                    )
                }
                return UIColor(
                    hex: increased ? (lightContrast ?? light) : light
                )
            }
        )
    }

    static func system(_ color: UIColor) -> Color {
        Color(uiColor: color)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let cleaned = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )
        let value = UInt64(cleaned, radix: 16) ?? 0
        self.init(
            red: CGFloat((value >> 16) & 0xFF) / 255,
            green: CGFloat((value >> 8) & 0xFF) / 255,
            blue: CGFloat(value & 0xFF) / 255,
            alpha: 1
        )
    }
}
