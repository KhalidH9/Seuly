import SwiftUI

/// Pinned action bar. Continue is the prominent button on every step, and
/// its label becomes the finishing phrase on the last one.
struct OnboardingFooterView: View {
    @Environment(\.seulyTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        HStack(spacing: SeulyLayout.spacingM) {
            if viewModel.canGoBack {
                Button(L10n.text("action.back", table: .onboarding)) {
                    withAnimation(
                        SeulyMotion.respectful(
                            SeulyMotion.content,
                            reduceMotion: reduceMotion
                        )
                    ) { viewModel.goBack() }
                }
                .buttonStyle(SeulySecondaryButtonStyle())
                .disabled(viewModel.isSaving)
            }
            Button {
                Task { await viewModel.continueFlow() }
            } label: {
                SeulyButtonLabel(
                    title: continueTitle,
                    isBusy: viewModel.isSaving
                )
            }
            .buttonStyle(SeulyPrimaryButtonStyle())
            .disabled(!viewModel.canContinue || viewModel.isSaving)
        }
        .padding(.horizontal, SeulyLayout.screenPadding)
        .padding(.vertical, SeulyLayout.spacingM)
        .background(theme.backgroundSecondary)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(theme.divider)
                .frame(height: 0.5)
        }
    }

    private var continueTitle: String {
        L10n.text(
            viewModel.isLastStep ? "action.finish" : "action.continue",
            table: .onboarding
        )
    }
}
