import SwiftUI

struct OnboardingAccountStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingXL) {
            OnboardingStepIntroductionView(
                eyebrow: L10n.text("account.eyebrow", table: .onboarding),
                title: L10n.text("account.title", table: .onboarding),
                message: L10n.text("account.message", table: .onboarding)
            )
            AmountEntryField(
                text: $viewModel.openingBalanceText,
                currency: viewModel.selectedCurrency,
                title: balanceTitle
            )
            SeulyCard {
                VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
                    LabeledFormField(
                        L10n.text("account.name.label", table: .onboarding)
                    ) {
                        TextField(
                            L10n.text(
                                "account.name.placeholder",
                                table: .onboarding
                            ),
                            text: $viewModel.accountName
                        )
                        .submitLabel(.done)
                        .seulyField()
                    }
                    LabeledFormField(
                        L10n.text("account.type.label", table: .onboarding)
                    ) {
                        kindPicker
                    }
                    InfoCalloutView(message: balanceHelp)
                }
            }
        }
    }

    private var kindPicker: some View {
        SeulyPickerSurface {
            Picker(
                L10n.text("account.type.label", table: .onboarding),
                selection: $viewModel.accountKind
            ) {
                ForEach(AccountKind.allCases) { kind in
                    Label(
                        L10n.databaseValue(
                            kind.rawValue,
                            prefix: "account.kind"
                        ),
                        systemImage: kind.systemImage
                    )
                    .tag(kind)
                }
            }
        }
    }

    private var balanceTitle: String {
        L10n.text(
            viewModel.accountKind.isLiability
                ? "account.balance.owed"
                : "account.balance.current",
            table: .onboarding
        )
    }

    private var balanceHelp: String {
        L10n.text(
            viewModel.accountKind.isLiability
                ? "account.balance.owed_help"
                : "account.balance.current_help",
            table: .onboarding
        )
    }
}
