import SwiftUI

/// Icon choice. Each option is a full tap target, and selection is carried by
/// a filled tile plus a ring rather than by tint alone.
struct AccountIconPickerView: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: AccountFormViewModel

    var body: some View {
        LabeledFormField(
            L10n.text("account.field.icon", table: .settings)
        ) {
            LazyVGrid(
                columns: [
                    GridItem(
                        .adaptive(minimum: SeulyLayout.minimumTapTarget),
                        spacing: SeulyLayout.spacingS
                    )
                ],
                spacing: SeulyLayout.spacingS
            ) {
                ForEach(
                    Array(viewModel.iconOptions.enumerated()),
                    id: \.element
                ) { index, icon in
                    Button {
                        withAnimation(SeulyMotion.interactive) {
                            viewModel.iconKey = icon
                        }
                    } label: {
                        tile(for: icon)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(
                        L10n.format(
                            "account.icon.accessibility",
                            table: .settings,
                            AppFormatters.integer(index + 1)
                        )
                    )
                    .accessibilityAddTraits(
                        viewModel.iconKey == icon ? .isSelected : []
                    )
                }
            }
        }
    }

    private func tile(for icon: String) -> some View {
        let isSelected = viewModel.iconKey == icon
        return Image(systemName: icon)
            .font(SeulyFont.bodyEmphasized)
            .foregroundStyle(isSelected ? theme.onBrandFill : theme.textSecondary)
            .frame(
                maxWidth: .infinity,
                minHeight: SeulyLayout.minimumTapTarget
            )
            .background(
                isSelected ? theme.brandFill : theme.fillTertiary,
                in: RoundedRectangle(
                    cornerRadius: SeulyLayout.compactRadius,
                    style: .continuous
                )
            )
            .contentShape(Rectangle())
    }
}
