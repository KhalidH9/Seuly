import SwiftUI

/// Detail fields for a transaction, ordered how people describe a purchase:
/// who, from where, what for, when, and anything worth remembering.
struct TransactionDetailsFieldsView: View {
    @Bindable var viewModel: TransactionFormViewModel
    @FocusState private var isMerchantFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
            LabeledFormField(
                L10n.text("field.merchant", table: .transactions)
            ) {
                TextField(
                    merchantPlaceholder,
                    text: $viewModel.entry.merchant
                )
                .textContentType(.organizationName)
                .submitLabel(.done)
                .focused($isMerchantFocused)
                .seulyField(isFocused: isMerchantFocused)
            }
            TransactionAccountPickerView(viewModel: viewModel)
            if viewModel.entry.kind == .transfer {
                TransactionDestinationPickerView(viewModel: viewModel)
            } else {
                TransactionCategoryPickerView(viewModel: viewModel)
            }
            BoundedDatePickerField(
                title: L10n.text("field.date", table: .transactions),
                date: $viewModel.effectiveDate,
                range: viewModel.allowedDateRange
            )
            LabeledFormField(
                L10n.text("field.note", table: .transactions)
            ) {
                TextField(
                    L10n.text("field.note_placeholder", table: .transactions),
                    text: $viewModel.entry.note,
                    axis: .vertical
                )
                .lineLimit(2...5)
                .seulyField()
            }
        }
    }

    private var merchantPlaceholder: String {
        viewModel.entry.kind == .transfer
            ? L10n.text("field.transfer_placeholder", table: .transactions)
            : L10n.text("field.merchant_placeholder", table: .transactions)
    }
}
