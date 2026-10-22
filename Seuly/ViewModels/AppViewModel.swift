import Foundation
import Observation

@MainActor
@Observable
final class AppViewModel {
    enum Route: Equatable {
        case configurationRequired
        case launching
        case authentication
        case loadingWorkspace
        case onboarding
        case passwordRecovery
        case main
        case unavailable(String)
    }

    let preferences: PreferencesModel
    let authViewModel: AuthViewModel?
    let passwordRecoveryViewModel: PasswordRecoveryViewModel?
    let onboardingViewModel: OnboardingViewModel?
    let mainTabViewModel: MainTabViewModel?
    let configurationMessage: String?
    let authModel: AuthModel?
    let financeModel: FinanceModel?
    var presentationUserID: UUID?
    var callbackErrorMessage: String?

    init(
        configuration: SupabaseConfiguration? = .load(),
        preferences suppliedPreferences: PreferencesModel? = nil
    ) {
        let preferences = suppliedPreferences ?? PreferencesModel()
        self.preferences = preferences
        guard let configuration else {
            configurationMessage = L10n.text(
                "error.configuration.missing",
                table: .errors
            )
            authModel = nil
            financeModel = nil
            authViewModel = nil
            passwordRecoveryViewModel = nil
            onboardingViewModel = nil
            mainTabViewModel = nil
            return
        }

        let client = configuration.makeClient()
        let auth = AuthModel(client: client)
        let finance = FinanceModel(client: client)
        configurationMessage = nil
        authModel = auth
        financeModel = finance
        authViewModel = AuthViewModel(model: auth)
        passwordRecoveryViewModel = PasswordRecoveryViewModel(model: auth)
        onboardingViewModel = OnboardingViewModel(model: finance)
        mainTabViewModel = MainTabViewModel(
            financeModel: finance,
            authModel: auth,
            preferences: preferences
        )
    }

    var appearance: AppearancePreference {
        preferences.appearance
    }

    var language: AppLanguage {
        preferences.language
    }
}
