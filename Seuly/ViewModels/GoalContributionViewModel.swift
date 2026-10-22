import Foundation
import Observation

@MainActor
@Observable
final class GoalContributionViewModel {
    private let model: FinanceModel
    private var requestContext = PersistenceRequestContext()
    let goal: SavingsGoal
    var amountText = ""
    var note = ""
    var isSaving = false
    var errorMessage: String?

    init(model: FinanceModel, goal: SavingsGoal) {
        self.model = model
        self.goal = goal
    }

    var canSave: Bool {
        guard
            let amount = currency?.minorUnits(from: amountText)
        else { return false }
        return amount > 0 && !isSaving
    }

    func save() async -> Bool {
        guard
            canSave,
            let amount = currency?.minorUnits(from: amountText)
        else {
            errorMessage = L10n.text(
                "validation.goal.contribution",
                table: .errors
            )
            return false
        }
        isSaving = true
        defer { isSaving = false }
        let request = requestContext.begin()
        let succeeded = await model.contribute(
            GoalContributionDraft(
                id: request.id,
                goalID: goal.id,
                amountMinor: amount,
                note: note,
                localDate: request.localDate
            )
        )
        errorMessage = succeeded ? nil : model.errorMessage
        return succeeded
    }

    var currency: CurrencyDefinition? {
        model.workspace.currencies.first { $0.code == goal.currencyCode }
    }
}
