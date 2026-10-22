import SwiftUI

/// Add anything, from anywhere on home. Ordered by how often each is used,
/// with the account entry separated because it creates structure, not money.
struct DashboardQuickAddMenu: View {
    let onPresent: (AppSheetRoute) -> Void

    var body: some View {
        Menu {
            Button {
                onPresent(.transaction(.expense, nil))
            } label: {
                Label(
                    L10n.text("quick.expense", table: .dashboard),
                    systemImage: "arrow.up.right"
                )
            }
            Button {
                onPresent(.transaction(.income, nil))
            } label: {
                Label(
                    L10n.text("quick.income", table: .dashboard),
                    systemImage: "arrow.down.left"
                )
            }
            Button {
                onPresent(.transaction(.transfer, nil))
            } label: {
                Label(
                    L10n.text("quick.transfer", table: .dashboard),
                    systemImage: "arrow.left.arrow.right"
                )
            }
            Divider()
            Button {
                onPresent(.recurring)
            } label: {
                Label(
                    L10n.text("quick.recurring", table: .dashboard),
                    systemImage: "repeat"
                )
            }
            Button {
                onPresent(.account(nil))
            } label: {
                Label(
                    L10n.text("quick.account", table: .dashboard),
                    systemImage: "building.columns"
                )
            }
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
        }
        .accessibilityLabel(
            L10n.text("quick.accessibility", table: .dashboard)
        )
    }
}
