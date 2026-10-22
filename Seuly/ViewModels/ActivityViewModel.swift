import Foundation
import Observation

@MainActor
@Observable
final class ActivityViewModel {
    enum DetailDismissalAction {
        case edit(FinancialTransaction)
        case delete(FinancialTransaction)
    }

    enum Period: String, CaseIterable, Identifiable {
        case thisMonth
        case recent
        var id: String { rawValue }
        var displayName: String { L10n.text("activity.period.\(rawValue)", table: .data) }
    }

    private let model: FinanceModel
    private let preferences: PreferencesModel
    var searchText = ""
    var selectedKind: TransactionKind?
    var selectedCategoryID: UUID?
    var period: Period = .thisMonth
    var selectedTransaction: FinancialTransaction?
    var deletionCandidate: FinancialTransaction?
    var detailDismissalAction: DetailDismissalAction?

    init(model: FinanceModel, preferences: PreferencesModel) {
        self.model = model
        self.preferences = preferences
    }

    var workspace: FinanceWorkspace { model.workspace }
    var currency: CurrencyDefinition? { workspace.currency }
    var errorMessage: String? { model.errorMessage }
    var isPrivacyModeEnabled: Bool {
        preferences.isPrivacyModeEnabled
    }

    func category(
        for transaction: FinancialTransaction
    ) -> FinanceCategory? {
        workspace.category(id: transaction.categoryID)
    }

    func account(
        for transaction: FinancialTransaction
    ) -> FinancialAccount? {
        workspace.account(id: transaction.displayAccountID)
    }

    func clearFilters() {
        searchText = ""
        selectedKind = nil
        selectedCategoryID = nil
        period = .thisMonth
    }

    func delete(_ transaction: FinancialTransaction) async {
        guard await model.voidTransaction(id: transaction.id) else { return }
        selectedTransaction = nil
        deletionCandidate = nil
    }
}
