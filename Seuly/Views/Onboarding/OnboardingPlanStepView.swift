import SwiftUI

struct OnboardingPlanStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingXL) {
            OnboardingStepIntroductionView(
                eyebrow: L10n.text("plan.eyebrow", table: .onboarding),
                title: L10n.text("plan.title", table: .onboarding),
                message: L10n.text("plan.message", table: .onboarding)
            )
            AmountEntryField(
                text: $viewModel.monthlyBudgetText,
                currency: viewModel.selectedCurrency,
                title: L10n.text("plan.limit.label", table: .onboarding)
            )
            SeulyCard {
                VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
                    LabeledFormField(
                        L10n.text("plan.category.label", table: .onboarding)
                    ) {
                        categoryPicker
                    }
                    InfoCalloutView(
                        message: L10n.text(
                            "plan.optional_budget.help",
                            table: .onboarding
                        )
                    )
                }
            }
        }
    }

    private var categoryPicker: some View {
        SeulyPickerSurface {
            Picker(
                L10n.text("plan.category.label", table: .onboarding),
                selection: $viewModel.monthlyBudgetCategoryID
            ) {
                ForEach(viewModel.expenseCategories) { category in
                    Label(
                        L10n.databaseValue(
                            category.name,
                            prefix: "category"
                        ),
                        systemImage: category.iconKey
                    )
                    .tag(Optional(category.id))
                }
            }
        }
    }
}
