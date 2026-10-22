import SwiftUI

/// Wraps a menu picker in the same well as a text field so a form reads as
/// one set of controls rather than a mix of styles.
struct SeulyPickerSurface<Content: View>: View {
    @Environment(\.seulyTheme) private var theme
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .pickerStyle(.menu)
            .tint(theme.brandPrimary)
            .frame(
                maxWidth: .infinity,
                minHeight: SeulyLayout.fieldHeight,
                alignment: .leading
            )
            .padding(.horizontal, SeulyLayout.spacingS)
            .background(
                theme.inputBackground,
                in: RoundedRectangle(
                    cornerRadius: SeulyLayout.controlRadius,
                    style: .continuous
                )
            )
    }
}
