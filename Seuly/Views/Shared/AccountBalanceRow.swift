import SwiftUI

struct AccountBalanceRow: View {
    @Environment(\.seulyTheme) private var theme
    let balance: AccountBalance
    let currency: CurrencyDefinition?
    let hidesAmount: Bool
    var showsInstitution = true

    var body: some View {
        HStack(spacing: SeulyLayout.spacingM) {
            SeulyIconTile(
                systemImage: balance.account.iconKey,
                tint: theme.color(for: balance.account.colorRole),
                background: theme.softColor(for: balance.account.colorRole)
            )
            VStack(alignment: .leading, spacing: 2) {
                Text(balance.account.name)
                    .font(SeulyFont.bodyEmphasized)
                    .foregroundStyle(theme.textPrimary)
                    .lineLimit(1)
                Text(subtitle)
                    .font(SeulyFont.caption)
                    .foregroundStyle(theme.textSecondary)
                    .lineLimit(1)
            }
            Spacer(minLength: SeulyLayout.spacingS)
            PrivacySensitiveAmount(
                minorUnits: balance.balanceMinor,
                currency: currency,
                isHidden: hidesAmount,
                style: SeulyFont.moneyRow,
                symbolScale: .body
            )
            .lineLimit(1)
        }
        .frame(minHeight: SeulyLayout.rowHeight)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }

    private var subtitle: String {
        let kind = balance.account.kind.displayName
        guard
            showsInstitution,
            let institution = balance.account.institutionName,
            !institution.isEmpty
        else { return kind }
        let dot = L10n.text("separator.dot", table: .shared)
        return "\(kind) \(dot) \(institution)"
    }
}
