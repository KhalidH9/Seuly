import SwiftUI

/// Budget fields. When the category already has spending this month, that fact
/// is surfaced here rather than left for the user to discover after saving.
struct BudgetFieldsView: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: BudgetFormViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
            CategoryPickerField(
                title: L10n.text("budget.field.category", table: .planning),
                selection: $viewModel.categoryID,
                categories: viewModel.expenseCategories,
                onChange: viewModel.synchronizeLimit
            )
            if viewModel.currentSpendMinor > 0 {
                alreadySpentCallout
            } else {
                InfoCalloutView(
                    message: L10n.text(
                        "budget.field.limit_help",
                        table: .planning
                    )
                )
            }
        }
    }

    private var alreadySpentCallout: some View {
        HStack(spacing: SeulyLayout.spacingS) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(SeulyFont.footnoteEmphasized)
                .foregroundStyle(theme.warning)
            Text(L10n.text("budget.already_spent", table: .planning))
                .font(SeulyFont.footnote)
                .foregroundStyle(theme.warningText)
            Spacer(minLength: SeulyLayout.spacingS)
            MoneyAmountText(
                minorUnits: viewModel.currentSpendMinor,
                currency: viewModel.currency,
                symbolScale: .subheadline
            )
            .font(SeulyFont.moneyCaption)
            .foregroundStyle(theme.warningText)
        }
        .padding(SeulyLayout.spacingM)
        .background(
            theme.warningBackground,
            in: RoundedRectangle(
                cornerRadius: SeulyLayout.controlRadius,
                style: .continuous
            )
        )
        .accessibilityElement(children: .combine)
    }
}
