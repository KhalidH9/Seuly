import SwiftUI

/// Weekly review prompt. Sits below the plan itself because it is a nudge
/// about the plan, not part of it.
struct WeeklyResetCard: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: PlanningViewModel

    var body: some View {
        SeulyCard {
            VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
                HStack(alignment: .top, spacing: SeulyLayout.spacingM) {
                    SeulyIconTile(
                        systemImage: "checklist",
                        tint: theme.brandPrimary,
                        background: theme.brandPrimarySoft
                    )
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.text("reset.eyebrow", table: .planning))
                            .seulyEyebrow()
                            .foregroundStyle(theme.brandPrimary)
                        Text(L10n.text("reset.title", table: .planning))
                            .font(SeulyFont.cardTitle)
                            .foregroundStyle(theme.textPrimary)
                    }
                    Spacer(minLength: 0)
                }
                VStack(alignment: .leading, spacing: SeulyLayout.spacingS) {
                    ForEach(viewModel.resetChecklist, id: \.title) { item in
                        checklistRow(
                            title: item.title,
                            isComplete: item.isComplete
                        )
                    }
                }
            }
        }
    }

    private func checklistRow(
        title: String,
        isComplete: Bool
    ) -> some View {
        HStack(spacing: SeulyLayout.spacingS) {
            Image(
                systemName: isComplete
                    ? "checkmark.circle.fill"
                    : "circle.dashed"
            )
            .font(SeulyFont.bodyEmphasized)
            .foregroundStyle(isComplete ? theme.success : theme.warning)
            Text(title)
                .font(SeulyFont.subheadline)
                .foregroundStyle(theme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
        .accessibilityValue(
            L10n.text(
                isComplete ? "reset.state.done" : "reset.state.pending",
                table: .planning
            )
        )
    }
}
