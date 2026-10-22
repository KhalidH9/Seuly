import SwiftUI

struct TransactionDetailRow: View {
    @Environment(\.seulyTheme) private var theme
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: SeulyLayout.spacingM) {
            Text(title)
                .font(SeulyFont.body)
                .foregroundStyle(theme.textSecondary)
            Spacer(minLength: SeulyLayout.spacingS)
            Text(value)
                .font(SeulyFont.bodyEmphasized)
                .foregroundStyle(theme.textPrimary)
                .multilineTextAlignment(.trailing)
        }
        .frame(minHeight: SeulyLayout.minimumTapTarget)
        .accessibilityElement(children: .combine)
    }
}
