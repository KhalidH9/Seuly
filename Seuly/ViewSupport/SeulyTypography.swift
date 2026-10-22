import SwiftUI

/// The single type scale. Built from the platform text styles so every label
/// scales with Dynamic Type, and left in the default design because SF Arabic
/// ships no rounded face -- asking for one only restyled Latin runs.
enum SeulyFont {
    static let screenTitle = Font.largeTitle.weight(.bold)
    static let heroTitle = Font.title.weight(.bold)
    static let sectionTitle = Font.title3.weight(.semibold)
    static let cardTitle = Font.headline
    static let body = Font.body
    static let bodyEmphasized = Font.body.weight(.semibold)
    static let subheadline = Font.subheadline
    static let subheadlineEmphasized = Font.subheadline.weight(.semibold)
    static let footnote = Font.footnote
    static let footnoteEmphasized = Font.footnote.weight(.semibold)
    static let caption = Font.caption
    static let captionEmphasized = Font.caption.weight(.semibold)
    static let caption2 = Font.caption2
    static let eyebrow = Font.caption2.weight(.bold)

    /// Money uses tabular figures so stacked amounts align on the decimal.
    static let moneyHero = Font.largeTitle.weight(.bold).monospacedDigit()
    static let moneyTitle = Font.title2.weight(.bold).monospacedDigit()
    static let moneySection = Font.title3.weight(.bold).monospacedDigit()
    static let moneyRow = Font.body.weight(.semibold).monospacedDigit()
    static let moneyCaption =
        Font.caption.weight(.semibold).monospacedDigit()
    static let moneyMetric = Font.headline.weight(.bold).monospacedDigit()
}

extension Text {
    /// Eyebrow labels get the loosened tracking that all-caps-style
    /// section kickers need to stay readable at caption size.
    func seulyEyebrow() -> Text {
        font(SeulyFont.eyebrow).tracking(0.6)
    }
}
