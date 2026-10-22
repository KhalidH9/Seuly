import SwiftUI

/// A real switch rather than a tappable row pretending to be one, so the
/// control announces its own state and honours system switch behaviour.
struct GoalTargetDateToggleView: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: GoalFormViewModel

    var body: some View {
        Toggle(isOn: targetDateBinding) {
            VStack(alignment: .leading, spacing: 2) {
                Text(L10n.text("goal.target.toggle", table: .planning))
                    .font(SeulyFont.bodyEmphasized)
                    .foregroundStyle(theme.textPrimary)
                Text(L10n.text("goal.target.help", table: .planning))
                    .font(SeulyFont.caption)
                    .foregroundStyle(theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .tint(theme.brandPrimary)
    }

    private var targetDateBinding: Binding<Bool> {
        Binding(
            get: { viewModel.hasTargetDate },
            set: { newValue in
                withAnimation(SeulyMotion.interactive) {
                    viewModel.hasTargetDate = newValue
                }
            }
        )
    }
}
