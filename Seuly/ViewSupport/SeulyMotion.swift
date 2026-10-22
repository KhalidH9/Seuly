import SwiftUI

/// Motion tokens. Durations sit inside the 0.2-0.4s band the platform uses
/// for in-place changes, and callers pair them with `reduceMotion`.
enum SeulyMotion {
    /// Selection, expansion, and other direct responses to a tap.
    static let interactive = Animation.snappy(duration: 0.26)
    /// Content arriving or leaving.
    static let content = Animation.smooth(duration: 0.32)
    /// Larger route-level changes.
    static let route = Animation.smooth(duration: 0.42)
    /// Springy emphasis for the splash mark and success moments.
    static let emphasis = Animation.spring(
        response: 0.5,
        dampingFraction: 0.72
    )

    static func respectful(
        _ animation: Animation,
        reduceMotion: Bool
    ) -> Animation? {
        reduceMotion ? nil : animation
    }
}

extension View {
    /// Crossfades instead of moving when Reduce Motion is on.
    func seulyTransition(_ reduceMotion: Bool) -> some View {
        transition(
            reduceMotion
                ? .opacity
                : .asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .opacity
                )
        )
    }
}
