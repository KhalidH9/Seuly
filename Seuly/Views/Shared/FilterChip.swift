import SwiftUI

/// Scope and filter chip. Selection is carried by a filled brand capsule so
/// the state survives grayscale and Increase Contrast, not by tint alone.
struct FilterChip: View {
    @Environment(\.seulyTheme) private var theme
    let title: String
    var systemImage: String?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(SeulyFont.caption.weight(.semibold))
                }
                Text(title)
                    .font(SeulyFont.subheadlineEmphasized)
            }
            .foregroundStyle(
                isSelected ? theme.textInverse : theme.textSecondary
            )
            .padding(.horizontal, SeulyLayout.spacingM)
            .frame(minHeight: SeulyLayout.minimumTapTarget)
            .background(
                isSelected ? theme.brandPrimary : theme.fillTertiary,
                in: Capsule()
            )
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(SeulyMotion.interactive, value: isSelected)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
