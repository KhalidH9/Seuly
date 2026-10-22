import SwiftUI

/// Prominent action. One per screen, always the thing the screen is for.
struct SeulyPrimaryButtonStyle: ButtonStyle {
    @Environment(\.seulyTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(SeulyFont.cardTitle)
            .foregroundStyle(isEnabled ? theme.onBrandFill : theme.textDisabled)
            .frame(maxWidth: .infinity, minHeight: SeulyLayout.controlHeight)
            .padding(.horizontal, SeulyLayout.spacingL)
            .background(
                isEnabled ? theme.brandFill : theme.fillTertiary,
                in: shape
            )
            .brightness(configuration.isPressed ? -0.06 : 0)
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
