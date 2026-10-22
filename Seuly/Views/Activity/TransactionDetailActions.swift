import SwiftUI

struct TransactionDetailActions: View {
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: SeulyLayout.spacingM) {
            Button(
                L10n.text("action.edit", table: .activity),
                action: onEdit
            )
            .buttonStyle(SeulyPrimaryButtonStyle())
            Button(role: .destructive, action: onDelete) {
                Label(
                    L10n.text("action.remove", table: .activity),
                    systemImage: "trash"
                )
            }
            .buttonStyle(SeulyDestructiveButtonStyle())
        }
    }
}
