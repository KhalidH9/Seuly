import SwiftUI

/// Colour choice. Swatches sit inside 44pt targets, and the selected one is
/// marked with a checkmark so the choice is never colour-only.
struct AccountColorPickerView: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: AccountFormViewModel

    var body: some View {
        LabeledFormField(
            L10n.text("account.field.color", table: .settings)
        ) {
            HStack(spacing: SeulyLayout.spacingXS) {
                ForEach(viewModel.colorRoles, id: \.self) { role in
                    Button {
                        withAnimation(SeulyMotion.interactive) {
                            viewModel.colorRole = role
                        }
                    } label: {
                        swatch(for: role)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(role.displayName)
                    .accessibilityAddTraits(
                        viewModel.colorRole == role ? .isSelected : []
                    )
                }
                Spacer(minLength: 0)
            }
        }
    }

    private func swatch(for role: ColorRole) -> some View {
        let isSelected = viewModel.colorRole == role
        return Circle()
            .fill(theme.color(for: role))
            .frame(width: 30, height: 30)
            .overlay {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(SeulyFont.caption.weight(.bold))
                        .foregroundStyle(.white)
                }
            }
            .overlay {
                Circle()
                    .strokeBorder(
                        theme.brandPrimary,
                        lineWidth: isSelected ? 2 : 0
                    )
                    .padding(-4)
            }
            .frame(
                width: SeulyLayout.minimumTapTarget,
                height: SeulyLayout.minimumTapTarget
            )
            .contentShape(Rectangle())
    }
}
