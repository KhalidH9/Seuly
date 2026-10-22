import SwiftUI

/// Direction switch for money forms. Reads as a segmented control, but the
/// selected segment carries the kind's own colour because direction is the
/// single most consequential choice on the screen.
struct TransactionKindSelector: View {
    @Environment(\.seulyTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var indicator
    let selection: TransactionKind
    var isDisabled = false
    let onSelect: (TransactionKind) -> Void

    var body: some View {
        HStack(spacing: 2) {
            ForEach(TransactionKind.allCases) { kind in
                Button {
                    withAnimation(
                        SeulyMotion.respectful(
                            SeulyMotion.interactive,
                            reduceMotion: reduceMotion
                        )
                    ) { onSelect(kind) }
                } label: {
                    segment(for: kind)
                }
                .buttonStyle(.plain)
                .disabled(isDisabled)
                .accessibilityAddTraits(
                    selection == kind ? .isSelected : []
                )
            }
        }
        .padding(3)
        .background(
            theme.fillTertiary,
            in: RoundedRectangle(
                cornerRadius: SeulyLayout.controlRadius + 3,
                style: .continuous
            )
        )
        .opacity(isDisabled ? 0.55 : 1)
    }

    private func segment(for kind: TransactionKind) -> some View {
        HStack(spacing: 5) {
            Image(systemName: kind.systemImage)
                .font(SeulyFont.caption.weight(.bold))
            Text(kind.displayName)
                .font(SeulyFont.subheadlineEmphasized)
        }
        .foregroundStyle(
            selection == kind
                ? theme.textColorOnSoftBackground(for: kind)
                : theme.textSecondary
        )
        .frame(maxWidth: .infinity, minHeight: 42)
        .background {
            if selection == kind {
                RoundedRectangle(
                    cornerRadius: SeulyLayout.controlRadius,
                    style: .continuous
                )
                .fill(theme.softColor(for: kind))
                .matchedGeometryEffect(id: "kind", in: indicator)
            }
        }
        .contentShape(Rectangle())
    }
}
