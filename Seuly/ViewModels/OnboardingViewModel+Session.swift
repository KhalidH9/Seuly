import Foundation

extension OnboardingViewModel {
    func resetSession() {
        renewPersistenceRequest()
        step = 0
        displayName = ""
        currencyCode = ""
        accountName = ""
        accountKind = .checking
        openingBalanceText = ""
        monthlyBudgetText = ""
        monthlyBudgetCategoryID = nil
        isSaving = false
        errorMessage = nil
    }
}
