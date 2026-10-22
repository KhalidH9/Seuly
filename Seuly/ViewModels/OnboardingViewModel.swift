import Foundation
import Observation

@MainActor
@Observable
final class OnboardingViewModel {
    private var requestContext = PersistenceRequestContext()
    var step = 0
    var displayName = ""
    var currencyCode = ""
    var accountName = ""
    var accountKind: AccountKind = .checking
    var openingBalanceText = ""
    var monthlyBudgetText = ""
    var monthlyBudgetCategoryID: UUID?
    var isSaving = false
    var errorMessage: String?
    let model: FinanceModel

    init(model: FinanceModel) {
        self.model = model
        synchronizeProfile()
    }

    var availableCurrencies: [CurrencyDefinition] {
        model.workspace.currencies.filter(\.isActive)
    }
    var selectedCurrency: CurrencyDefinition? {
        availableCurrencies.first { $0.code == currencyCode }
    }
    var expenseCategories: [FinanceCategory] {
        model.workspace.activeCategories(for: .expense)
    }
    var selectedBudgetCategory: FinanceCategory? {
        expenseCategories.first { $0.id == monthlyBudgetCategoryID }
    }
    var canGoBack: Bool { step > 0 }
    var isLastStep: Bool { step == 2 }
    var canContinue: Bool {
        switch step {
        case 0:
            return selectedCurrency != nil
                && !displayName
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .isEmpty
        case 1:
            return !accountName
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty && openingBalance != nil
        default:
            return monthlyBudgetText.isEmpty
                || (monthlyBudget != nil && selectedBudgetCategory != nil)
        }
    }
    var openingBalance: Int64? {
        selectedCurrency?.minorUnits(
            from: openingBalanceText.isEmpty ? "0" : openingBalanceText,
            allowsNegative: true
        )
    }
    var monthlyBudget: Int64? {
        selectedCurrency?.minorUnits(from: monthlyBudgetText)
    }

    var persistenceID: UUID { requestContext.id }

    func beginPersistenceRequest() -> (id: UUID, localDate: LocalDate) {
        requestContext.begin()
    }

    func renewPersistenceRequest() {
        requestContext = PersistenceRequestContext()
    }

    func synchronizeProfile() {
        guard let profile = model.workspace.profile else { return }
        if displayName.isEmpty { displayName = profile.displayName }
        currencyCode = profile.currencyCode
        if monthlyBudgetCategoryID == nil {
            monthlyBudgetCategoryID = expenseCategories.first?.id
        }
    }
}
