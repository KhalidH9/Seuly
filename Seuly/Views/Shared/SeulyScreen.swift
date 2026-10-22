import SwiftUI

/// Standard page frame: grouped background, consistent gutters, and a
/// scroll view that yields the keyboard back on drag.
struct SeulyScreen<Content: View>: View {
    @Environment(\.seulyTheme) private var theme
    private let scrollable: Bool
    private let content: Content

    init(scrollable: Bool = true, @ViewBuilder content: () -> Content) {
        self.scrollable = scrollable
        self.content = content()
    }

    var body: some View {
        Group {
            if scrollable {
                ScrollView {
                    content
                        .padding(.horizontal, SeulyLayout.screenPadding)
                        .padding(.bottom, 36)
                }
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.interactively)
            } else {
                content.padding(.horizontal, SeulyLayout.screenPadding)
            }
        }
        .background(theme.backgroundPrimary.ignoresSafeArea())
    }
}
