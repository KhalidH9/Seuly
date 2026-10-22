import SwiftUI

/// The app's loading indicator: the brand mark breathing, in place of a system
/// spinner. Every wait in the app uses this so progress always looks like
/// Seuly rather than like a generic control.
struct SeulyActivityIndicator: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    var size: CGFloat = 28
    var tint: Color?
    @State private var isBreathing = false

    var body: some View {
        SeulyMark(size: size, tint: tint)
            .scaleEffect(scale)
            .opacity(opacity)
            .animation(breath, value: isBreathing)
            .onAppear { isBreathing = true }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(L10n.text("loading", table: .shared))
            .accessibilityAddTraits(.updatesFrequently)
    }

    private var scale: CGFloat {
        guard !reduceMotion else { return 1 }
        return isBreathing ? 1 : 0.82
    }

    private var opacity: Double {
        guard !reduceMotion else { return 1 }
        return isBreathing ? 1 : 0.45
    }

    /// Reduce Motion keeps the mark still rather than swapping in a different
    /// indicator, so the visual language stays the same.
    private var breath: Animation? {
        guard !reduceMotion else { return nil }
        return .easeInOut(duration: 0.75).repeatForever(autoreverses: true)
    }
}
