import Foundation
import Observation

@MainActor
@Observable
final class SettingsViewModel {
    private let financeModel: FinanceModel
    private let authModel: AuthModel
    private let preferences: PreferencesModel
    var showsSignOutConfirmation = false
    var isSigningOut = false

    init(
        financeModel: FinanceModel,
        authModel: AuthModel,
        preferences: PreferencesModel
    ) {
        self.financeModel = financeModel
        self.authModel = authModel
        self.preferences = preferences
    }

    var workspace: FinanceWorkspace { financeModel.workspace }
    var profile: FinanceProfile? { financeModel.workspace.profile }
    var currency: CurrencyDefinition? { financeModel.workspace.currency }
    var email: String { authModel.currentUser?.email ?? "" }
    var errorMessage: String? { authModel.errorMessage }
    func currency(for account: FinancialAccount) -> CurrencyDefinition? {
        financeModel.workspace.currency(for: account.currencyCode)
    }
    var balances: [AccountBalance] {
        FinanceAnalytics(
            workspace: financeModel.workspace
        ).accountBalances
    }

    var appearance: AppearancePreference {
        get { preferences.appearance }
        set { preferences.appearance = newValue }
    }

    var isPrivacyModeEnabled: Bool {
        get { preferences.isPrivacyModeEnabled }
        set { preferences.isPrivacyModeEnabled = newValue }
    }

    var language: AppLanguage {
        get { preferences.language }
        set { preferences.language = newValue }
    }

    func signOut() async -> Bool {
        isSigningOut = true
        defer { isSigningOut = false }
        let succeeded = await authModel.signOut()
        if succeeded { financeModel.clear() }
        return succeeded
    }
}
