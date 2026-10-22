import Foundation
import Observation

@MainActor
@Observable
final class AccountFormViewModel {
    let model: FinanceModel
    let existingAccount: FinancialAccount?
    let persistenceID: UUID
    var name = ""
    var institutionName = ""
    var kind: AccountKind = .checking
    var balanceText = ""
    var iconKey = "building.columns.fill"
    var colorRole: ColorRole = .teal
    var isSaving = false
    var errorMessage: String?

    let iconOptions = [
        "building.columns.fill", "creditcard.fill", "banknote.fill",
        "sparkles", "chart.line.uptrend.xyaxis", "briefcase.fill"
    ]
    let colorRoles: [ColorRole] = [
        .teal, .savings, .investment, .transfer, .income, .debt
    ]

    init(model: FinanceModel, account: FinancialAccount?) {
        self.model = model
        existingAccount = account
        persistenceID = account?.id ?? UUID()
        guard let account else { return }
        name = account.name
        institutionName = account.institutionName ?? ""
        kind = account.kind
        balanceText = MoneyFormatter.editableString(
            minorUnits: displayedBalance(for: account),
            currency: currency(for: account.currencyCode)
        )
        iconKey = account.iconKey
        colorRole = account.colorRole
    }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && parsedBalance != nil
            && !isSaving
    }

    func kindChanged() {
        iconKey = kind.systemImage
        if kind.isLiability {
            colorRole = .debt
        } else if kind == .savings {
            colorRole = .savings
        } else if kind == .investment {
            colorRole = .investment
        }
    }

    func save() async -> Bool {
        guard canSave, let balance = parsedBalance else {
            errorMessage = L10n.text(
                "validation.account.incomplete",
                table: .errors
            )
            return false
        }
        isSaving = true
        defer { isSaving = false }
        let succeeded = await model.saveAccount(
            AccountDraft(
                id: persistenceID,
                name: name,
                kind: kind,
                openingBalanceMinor: normalizedBalance(balance),
                institutionName: institutionName,
                iconKey: iconKey,
                colorRole: colorRole
            )
        )
        errorMessage = succeeded ? nil : model.errorMessage
        return succeeded
    }

}
