import Foundation
import Observation

@MainActor
@Observable
final class DashboardViewModel {
    private let model: FinanceModel
    private let preferences: PreferencesModel
    private(set) var referenceDate = Date.now

    init(model: FinanceModel, preferences: PreferencesModel) {
        self.model = model
        self.preferences = preferences
    }

    var workspace: FinanceWorkspace { model.workspace }
    var analytics: FinanceAnalytics {
        FinanceAnalytics(
            workspace: workspace,
            referenceDate: referenceDate
        )
    }
    var currency: CurrencyDefinition? { workspace.currency }
    var isPrivacyModeEnabled: Bool {
        preferences.isPrivacyModeEnabled
    }
    var errorMessage: String? { model.errorMessage }

    var greeting: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12:
            L10n.text("dashboard.greeting.morning", table: .data)
        case 12..<17:
            L10n.text("dashboard.greeting.afternoon", table: .data)
        default:
            L10n.text("dashboard.greeting.evening", table: .data)
        }
    }

    var firstName: String {
        workspace.profile?.localizedDisplayName
            .split(separator: " ")
            .first
            .map(String.init)
            ?? L10n.text("dashboard.greeting.fallback_name", table: .data)
    }

    var monthTitle: String {
        AppFormatters.monthYear(referenceDate)
    }

    var recentTransactions: [FinancialTransaction] {
        Array(
            workspace.transactions
                .filter { $0.status != .void }
                .sorted { $0.effectiveDate > $1.effectiveDate }
                .prefix(5)
        )
    }

    var featuredGoal: SavingsGoal? {
        workspace.goals
            .filter { $0.status == .active }
            .max { $0.progress < $1.progress }
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

    func refresh() async {
        await model.refresh()
        referenceDate = .now
    }

    func updateReferenceDate(_ date: Date) {
        referenceDate = date
    }

    func resetSession() {
        referenceDate = .now
    }

    func setPrivacyMode(_ enabled: Bool) {
        preferences.isPrivacyModeEnabled = enabled
    }
}
