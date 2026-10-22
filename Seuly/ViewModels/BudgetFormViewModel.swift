import Foundation
import Observation

@MainActor
@Observable
final class BudgetFormViewModel {
    private let model: FinanceModel
    private var requestContext = PersistenceRequestContext()
    var categoryID: UUID?
    var limitText = ""
    var isSaving = false
    var errorMessage: String?

    init(model: FinanceModel) {
        self.model = model
        categoryID = expenseCategories.first?.id
        synchronizeLimit()
    }

    var currency: CurrencyDefinition? { model.workspace.currency }
    var currentBudget: BudgetPeriod? {
        FinanceAnalytics(workspace: model.workspace).currentBudget
    }
    var expenseCategories: [FinanceCategory] {
        model.workspace.activeCategories(for: .expense)
    }
    var selectedCategory: FinanceCategory? {
        expenseCategories.first { $0.id == categoryID }
    }
    var existingLine: BudgetLine? {
        currentBudget?.lines.first { $0.categoryID == categoryID }
    }
    var currentSpendMinor: Int64 {
        guard let categoryID else { return 0 }
        return FinanceAnalytics(workspace: model.workspace)
            .budgetProgress
            .first { $0.category.id == categoryID }?
            .spentMinor ?? 0
    }
    var canSave: Bool {
        guard
            categoryID != nil,
            let amount = currency?.minorUnits(from: limitText)
        else { return false }
        return amount > 0 && !isSaving
    }

    func synchronizeLimit() {
        guard let existingLine else {
            limitText = ""
            return
        }
        limitText = MoneyFormatter.editableString(
            minorUnits: existingLine.limitMinor,
            currency: currency
        )
    }

    func save() async -> Bool {
        guard
            canSave,
            let categoryID,
            let limit = currency?.minorUnits(from: limitText)
        else {
            errorMessage = L10n.text(
                "validation.budget.incomplete",
                table: .errors
            )
            return false
        }
        isSaving = true
        defer { isSaving = false }
        let request = requestContext.begin()
        let succeeded = await model.saveBudgetLine(
            BudgetLineDraft(
                budgetID: currentBudget?.id,
                categoryID: categoryID,
                limitMinor: limit,
                localDate: request.localDate
            )
        )
        errorMessage = succeeded ? nil : model.errorMessage
        return succeeded
    }
}
