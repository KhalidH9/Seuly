import Foundation

extension AppViewModel {
    var currentUserID: UUID? { authModel?.currentUser?.id }

    var route: Route {
        guard let authModel, let financeModel else {
            return .configurationRequired
        }
        switch authModel.phase {
        case .launching:
            return .launching
        case .signedOut:
            return .authentication
        case .signedIn(let user):
            if authModel.isPasswordRecovery {
                return .passwordRecovery
            }
            guard financeModel.currentUserID == user.id else {
                return .loadingWorkspace
            }
            switch financeModel.loadState {
            case .idle, .loading:
                return .loadingWorkspace
            case .failed(let message):
                return .unavailable(message)
            case .loaded:
                return financeModel.workspace.profile?.onboardingCompleted == true
                    ? .main
                    : .onboarding
            }
        }
    }
}
