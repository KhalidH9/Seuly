import SwiftUI

struct TransactionCategoryPickerView: View {
    @Bindable var viewModel: TransactionFormViewModel

    var body: some View {
        CategoryPickerField(
            title: L10n.text("field.category", table: .transactions),
            selection: $viewModel.entry.categoryID,
            categories: viewModel.entry.availableCategories
        )
    }
}
