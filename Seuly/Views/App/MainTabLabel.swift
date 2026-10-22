import SwiftUI

/// Tab label. Home carries the brand mark instead of a system glyph, so the
/// app's own identity anchors the tab bar.
struct MainTabLabel: View {
    let tab: MainTab

    var body: some View {
        Label {
            Text(tab.title)
        } icon: {
            if tab == .overview {
                Image("SeulyMonogram").renderingMode(.template)
            } else {
                Image(systemName: tab.systemImage)
            }
        }
    }
}
