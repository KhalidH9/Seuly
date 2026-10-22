import SwiftUI

/// Tinted rather than filled: a destructive action should read as serious
/// without shouting louder than the screen's prominent button.
struct SeulyDestructiveButtonStyle: ButtonStyle {
    @Environment(\.seulyTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(SeulyFont.cardTitle)
            .foregroundStyle(theme.expenseText)
            .frame(maxWidth: .infinity, minHeight: SeulyLayout.controlHeight)
            .padding(.horizontal, SeulyLayout.spacingL)
            .background(theme.expenseLight, in: shape)
            .opacity(isEnabled ? 1 : 0.4)
            .brightness(configuration.isPressed ? -0.04 : 0)
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
