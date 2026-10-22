import SwiftUI

/// Account entry point, kept in the navigation bar the way the platform's own
/// storefronts do, so it never scrolls out of reach.
struct DashboardProfileButton: View {
    let initials: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ProfileAvatarView(initials: initials, size: 30)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            L10n.text("settings.accessibility", table: .dashboard)
        )
    }
}
