import CoreGraphics

/// Spacing, radii, and control metrics on a 4pt grid. Radii step with the
/// size of the thing they wrap so nesting never produces mismatched curves.
enum SeulyLayout {
    static let screenPadding: CGFloat = 20
    static let cardPadding: CGFloat = 16
    static let cardRadius: CGFloat = 20
    static let heroRadius: CGFloat = 26
    static let controlRadius: CGFloat = 12
    static let compactRadius: CGFloat = 10
    static let iconTileRadius: CGFloat = 11
    static let minimumTapTarget: CGFloat = 44

    /// Vertical rhythm.
    static let spacingXS: CGFloat = 4
    static let spacingS: CGFloat = 8
    static let spacingM: CGFloat = 12
    static let spacingL: CGFloat = 16
    static let spacingXL: CGFloat = 20
    static let sectionSpacing: CGFloat = 24

    /// Leading icon tiles. `rowIcon` is the list-row standard.
    static let rowIcon: CGFloat = 38
    static let compactIcon: CGFloat = 30
    static let prominentIcon: CGFloat = 52

    /// Row heights matching the platform list metrics.
    static let rowHeight: CGFloat = 52
    static let fieldHeight: CGFloat = 48
    static let controlHeight: CGFloat = 50
}
