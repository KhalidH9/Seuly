import SwiftUI

struct PasswordRecoveryView: View {
    @Environment(\.seulyTheme) private var theme
    @State private var viewModel: PasswordRecoveryViewModel

    init(viewModel: PasswordRecoveryViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: SeulyLayout.sectionSpacing) {
                Spacer(minLength: SeulyLayout.sectionSpacing)
                PasswordRecoveryHeaderView()
                SeulyCard {
                    PasswordRecoveryFormView(viewModel: viewModel)
                }
                PasswordRecoveryActionsView(viewModel: viewModel)
                    .padding(.bottom, SeulyLayout.sectionSpacing)
            }
            .padding(.horizontal, SeulyLayout.screenPadding)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .background(theme.softBackgroundGradient.ignoresSafeArea())
    }
}
