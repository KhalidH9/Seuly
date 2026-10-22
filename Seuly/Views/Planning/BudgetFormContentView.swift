import SwiftUI

struct BudgetFormContentView: View {
    @Bindable var viewModel: BudgetFormViewModel

    var body: some View {
        VStack(spacing: SeulyLayout.spacingL) {
            if let category = viewModel.selectedCategory {
                EntityPreviewCard(
                    systemImage: category.iconKey,
                    colorRole: category.colorRole,
                    title: category.localizedName,
                    subtitle: viewModel.existingLine == nil
                        ? L10n.text("budget.preview.new", table: .planning)
                        : L10n.text("budget.preview.edit", table: .planning)
                )
            }
            AmountEntryField(
                text: $viewModel.limitText,
                currency: viewModel.currency,
                title: L10n.text("budget.field.limit", table: .planning)
            )
            SeulyCard {
                BudgetFieldsView(viewModel: viewModel)
            }
            if let error = viewModel.errorMessage {
                ErrorBanner(message: error)
            }
        }
    }
}
