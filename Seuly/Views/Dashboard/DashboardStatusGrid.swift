import SwiftUI

/// The two "how am I doing" cards, side by side on a regular width and
/// stacked once the text size makes two columns unreadable.
struct DashboardStatusGrid: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let viewModel: DashboardViewModel

    var body: some View {
        layout {
            SafeToSpendCard(
                analytics: viewModel.analytics,
                currency: viewModel.currency,
                hidesAmount: viewModel.isPrivacyModeEnabled
            )
            MoneyPulseCard(pulse: viewModel.analytics.moneyPulse)
        }
    }

    private var layout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SeulyLayout.spacingM))
            : AnyLayout(HStackLayout(spacing: SeulyLayout.spacingM))
    }
}
