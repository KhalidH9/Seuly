import SwiftUI

/// Grouped content container. Carries no border or shadow: sitting a
/// secondary-grouped fill on a grouped page is exactly how the platform
/// separates an inset list section, and it survives Increase Contrast.
struct SeulyCard<Content: View>: View {
    @Environment(\.seulyTheme) private var theme
    private let padding: CGFloat
    private let content: Content

    init(
        padding: CGFloat = SeulyLayout.cardPadding,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                theme.surfacePrimary,
                in: RoundedRectangle(
                    cornerRadius: SeulyLayout.cardRadius,
                    style: .continuous
                )
            )
    }
}
