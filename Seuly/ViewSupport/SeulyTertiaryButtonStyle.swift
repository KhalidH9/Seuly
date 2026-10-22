import SwiftUI

/// Text-only action. Carries no fill but still reserves a full tap target.
struct SeulyTertiaryButtonStyle: ButtonStyle {
    @Environment(\.seulyTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(SeulyFont.subheadlineEmphasized)
            .foregroundStyle(theme.brandPrimary)
            .frame(minHeight: SeulyLayout.minimumTapTarget)
            .padding(.horizontal, SeulyLayout.spacingS)
            .opacity(opacity(isPressed: configuration.isPressed))
            .animation(SeulyMotion.interactive, value: configuration.isPressed)
            .contentShape(Rectangle())
    }

    private func opacity(isPressed: Bool) -> Double {
        if !isEnabled { return 0.4 }
        return isPressed ? 0.55 : 1
    }
}
