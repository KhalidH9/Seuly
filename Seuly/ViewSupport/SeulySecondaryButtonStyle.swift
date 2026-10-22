import SwiftUI

/// Tinted action for in-card affordances that should not outrank the
/// screen's prominent button.
struct SeulySecondaryButtonStyle: ButtonStyle {
    @Environment(\.seulyTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(SeulyFont.subheadlineEmphasized)
            .foregroundStyle(theme.brandPrimary)
            .frame(minHeight: SeulyLayout.minimumTapTarget)
            .padding(.horizontal, SeulyLayout.spacingL)
            .background(theme.brandPrimarySoft, in: shape)
            .opacity(isEnabled ? 1 : 0.4)
            .brightness(configuration.isPressed ? -0.04 : 0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(SeulyMotion.interactive, value: configuration.isPressed)
            .contentShape(shape)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(
            cornerRadius: SeulyLayout.controlRadius,
            style: .continuous
        )
    }
}
