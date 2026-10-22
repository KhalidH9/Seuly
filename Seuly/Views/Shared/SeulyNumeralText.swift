import SwiftUI

/// Pins its content to left-to-right run order. Latin-script values such as
/// email addresses, currency codes, and version numbers keep their own
/// direction inside an otherwise right-to-left layout.
struct SeulyNumeralText<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content.environment(\.layoutDirection, .leftToRight)
    }
}
