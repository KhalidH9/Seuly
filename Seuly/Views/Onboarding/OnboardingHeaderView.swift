import SwiftUI

/// Progress chrome: where you are, out of how many, plus a track that reads
/// at a glance and announces itself as one value to VoiceOver.
struct OnboardingHeaderView: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: OnboardingViewModel
    private let stepCount = 3

    var body: some View {
        VStack(spacing: SeulyLayout.spacingM) {
            HStack {
                SeulyLogo(size: 34, showsWordmark: true)
                Spacer()
                Text(progressText)
                    .font(SeulyFont.captionEmphasized)
                    .foregroundStyle(theme.textSecondary)
            }
            HStack(spacing: 5) {
                ForEach(0..<stepCount, id: \.self) { index in
                    Capsule(style: .continuous)
                        .fill(
                            index <= viewModel.step
                                ? theme.brandPrimary
                                : theme.fillTertiary
                        )
                        .frame(height: 5)
                }
            }
            .animation(SeulyMotion.content, value: viewModel.step)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(progressText)
        }
        .padding(.horizontal, SeulyLayout.screenPadding)
        .padding(.top, SeulyLayout.spacingM)
        .padding(.bottom, SeulyLayout.spacingL)
        .background(theme.backgroundSecondary)
    }

    private var progressText: String {
        L10n.format(
            "progress",
            table: .onboarding,
            viewModel.step + 1,
            stepCount
        )
    }
}
