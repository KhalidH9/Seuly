import SwiftUI

/// Month stepper. Sits above the cards it governs, with the arrows at the
/// edges and the month itself as the label between them.
struct InsightsMonthPicker: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: InsightsViewModel

    var body: some View {
        HStack(spacing: SeulyLayout.spacingM) {
            stepButton(
                systemImage: "chevron.backward",
                label: L10n.text("month.previous", table: .insights),
                isEnabled: viewModel.canMoveBackward,
                offset: -1
            )
            VStack(spacing: 1) {
                Text(viewModel.monthTitle)
                    .font(SeulyFont.cardTitle)
                    .foregroundStyle(theme.textPrimary)
                Text(L10n.text("month.summary", table: .insights))
                    .font(SeulyFont.caption)
                    .foregroundStyle(theme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .accessibilityElement(children: .combine)
            stepButton(
                systemImage: "chevron.forward",
                label: L10n.text("month.next", table: .insights),
                isEnabled: viewModel.canMoveForward,
                offset: 1
            )
        }
        .padding(SeulyLayout.spacingS)
        .background(
            theme.surfacePrimary,
            in: RoundedRectangle(
                cornerRadius: SeulyLayout.cardRadius,
                style: .continuous
            )
        )
    }

    private func stepButton(
        systemImage: String,
        label: String,
        isEnabled: Bool,
        offset: Int
    ) -> some View {
        Button {
            withAnimation(SeulyMotion.interactive) {
                viewModel.moveMonth(by: offset)
            }
        } label: {
            Image(systemName: systemImage)
                .font(SeulyFont.bodyEmphasized)
                .foregroundStyle(theme.brandPrimary)
                .frame(
                    width: SeulyLayout.minimumTapTarget,
                    height: SeulyLayout.minimumTapTarget
                )
                .background(theme.fillTertiary, in: Circle())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.35)
        .accessibilityLabel(label)
    }
}
