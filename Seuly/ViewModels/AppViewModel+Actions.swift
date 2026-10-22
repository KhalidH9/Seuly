import Foundation

extension AppViewModel {
    func start() async {
        await authModel?.start()
    }

    func synchronizeWorkspace() async {
        let userID = currentUserID
        prepareForUserTransition(to: userID)
        guard let userID else {
            financeModel?.clear()
            return
        }
        await financeModel?.load(userID: userID)
        onboardingViewModel?.synchronizeProfile()
    }

    func retryWorkspace() async {
        guard await financeModel?.refresh() == true else { return }
        onboardingViewModel?.synchronizeProfile()
    }

    func prepareForUserTransition(to userID: UUID?) {
        guard presentationUserID != userID else { return }
        presentationUserID = userID
        authViewModel?.resetSession()
        passwordRecoveryViewModel?.resetSession()
        onboardingViewModel?.resetSession()
        mainTabViewModel?.resetSession()
    }

    func applicationDidBecomeActive() async {
        mainTabViewModel?.updateDates(referenceDate: .now)
        guard
            authModel?.currentUser != nil,
            financeModel?.loadState == .loaded
        else { return }
        await financeModel?.refresh()
    }

    func handle(url: URL) async {
        guard let authModel else { return }
        do {
            try await authModel.handle(url: url)
            callbackErrorMessage = nil
        } catch {
            callbackErrorMessage = ErrorPresenter.message(
                for: error,
                context: .authenticationLink
            )
        }
    }

    func dismissCallbackError() {
        callbackErrorMessage = nil
    }
}
