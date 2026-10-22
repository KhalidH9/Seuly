import SwiftUI

struct OnboardingIdentityStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingXL) {
            OnboardingStepIntroductionView(
                eyebrow: L10n.text("identity.eyebrow", table: .onboarding),
                title: L10n.text("identity.title", table: .onboarding),
                message: L10n.text("identity.message", table: .onboarding)
            )
            SeulyCard {
                VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
                    LabeledFormField(
                        L10n.text("identity.name.label", table: .onboarding)
                    ) {
                        TextField(
                            L10n.text(
                                "identity.name.placeholder",
                                table: .onboarding
                            ),
                            text: $viewModel.displayName
                        )
                        .textContentType(.name)
                        .submitLabel(.done)
                        .seulyField()
                    }
                    LabeledFormField(
                        L10n.text("identity.currency.label", table: .onboarding)
                    ) {
                        currencyPicker
                    }
                    InfoCalloutView(
                        message: L10n.text(
                            "identity.currency.help",
                            table: .onboarding
                        )
                    )
                }
            }
        }
    }

    private var currencyPicker: some View {
        SeulyPickerSurface {
            Picker(
                L10n.text("identity.currency.label", table: .onboarding),
                selection: $viewModel.currencyCode
            ) {
                ForEach(viewModel.availableCurrencies) { currency in
                    Text(
                        L10n.format(
                            "identity.currency.option",
                            table: .onboarding,
                            currency.code,
                            currency.localizedName
                        )
                    )
                    .tag(currency.code)
                }
            }
        }
    }
}
