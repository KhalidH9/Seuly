import SwiftUI

/// Account form: a live preview of the row being created, the opening balance
/// as the headline figure, then identity and appearance in separate cards.
struct AccountFormContentView: View {
    @Bindable var viewModel: AccountFormViewModel

    var body: some View {
        VStack(spacing: SeulyLayout.spacingL) {
            EntityPreviewCard(
                systemImage: viewModel.iconKey,
                colorRole: viewModel.colorRole,
                title: viewModel.name.isEmpty
                    ? L10n.text("account.preview.new", table: .settings)
                    : viewModel.name,
                subtitle: viewModel.kind.displayName
            )
            AmountEntryField(
                text: $viewModel.balanceText,
                currency: viewModel.currency,
                title: balanceTitle
            )
            SeulyCard {
                AccountDetailsFieldsView(viewModel: viewModel)
            }
            SeulyCard {
                VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
                    AccountIconPickerView(viewModel: viewModel)
                    AccountColorPickerView(viewModel: viewModel)
                }
            }
            if let error = viewModel.errorMessage {
                ErrorBanner(message: error)
            }
        }
    }

    private var balanceTitle: String {
        L10n.text(
            viewModel.kind.isLiability
                ? "account.field.opening_debt"
                : "account.field.opening_balance",
            table: .settings
        )
    }
}
