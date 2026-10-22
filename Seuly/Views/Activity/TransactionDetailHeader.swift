import SwiftUI

struct TransactionDetailHeader: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: ActivityViewModel
    let transaction: FinancialTransaction

    var body: some View {
        VStack(spacing: SeulyLayout.spacingM) {
            SeulyIconTile(
                systemImage: viewModel.category(for: transaction)?.iconKey
                    ?? transaction.kind.systemImage,
                tint: theme.textColorOnSoftBackground(for: transaction.kind),
                background: theme.softColor(for: transaction.kind),
                size: 62
            )
            PrivacySensitiveAmount(
                minorUnits: viewModel.signedAmount(for: transaction),
                currency: viewModel.currency,
                isHidden: viewModel.isPrivacyModeEnabled,
                style: SeulyFont.moneyHero,
                color: theme.textColor(for: transaction.kind),
                showSign: transaction.kind == .income,
                symbolScale: .largeTitle
            )
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            Text(title)
                .font(SeulyFont.sectionTitle)
                .foregroundStyle(theme.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, SeulyLayout.spacingL)
        .accessibilityElement(children: .combine)
    }

    private var title: String {
        transaction.merchant.isEmpty
            ? transaction.kind.displayName
            : transaction.merchant
    }
}
