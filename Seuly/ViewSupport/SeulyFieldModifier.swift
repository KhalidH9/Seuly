import SwiftUI

/// Filled field well.
///
/// The frame is applied to the control itself, not to a wrapper, so the whole
/// well is the control's hit region and one tap lands focus. Nothing here
/// animates: the modified view is a text field whose content changes on every
/// keystroke, and animating that made typing feel laggy.
struct SeulyFieldModifier: ViewModifier {
    @Environment(\.seulyTheme) private var theme
    let isFocused: Bool
    let hasError: Bool

    func body(content: Content) -> some View {
        content
            .font(SeulyFont.body)
            .foregroundStyle(theme.textPrimary)
            .frame(maxWidth: .infinity, minHeight: SeulyLayout.fieldHeight)
            .padding(.horizontal, SeulyLayout.spacingM)
            .background(theme.inputBackground, in: shape)
            .overlay {
                shape
                    .strokeBorder(borderColor, lineWidth: borderWidth)
                    .allowsHitTesting(false)
            }
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(
            cornerRadius: SeulyLayout.controlRadius,
            style: .continuous
        )
    }

    private var borderColor: Color {
        if hasError { return theme.error }
        return isFocused ? theme.focusBorder : .clear
    }

    private var borderWidth: CGFloat {
        isFocused || hasError ? 1.5 : 0
    }
}

extension View {
    func seulyField(
        isFocused: Bool = false,
        hasError: Bool = false
    ) -> some View {
        modifier(
            SeulyFieldModifier(
                isFocused: isFocused,
                hasError: hasError
            )
        )
    }
}
