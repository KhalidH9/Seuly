import Foundation
import Observation

@MainActor
@Observable
final class GoalFormViewModel {
    private let model: FinanceModel
    private var requestContext = PersistenceRequestContext()
    var name = ""
    var kind: GoalKind = .savings
    var targetText = ""
    var hasTargetDate = true
    var targetDate = FinanceCalendar.current.date(
        byAdding: .month,
        value: 6,
        to: .now
    ) ?? .now
    var iconKey = "target"
    var colorRole: ColorRole = .savings
    var isSaving = false
    var errorMessage: String?

    init(model: FinanceModel) {
        self.model = model
    }

    var currency: CurrencyDefinition? { model.workspace.currency }
    var targetDateRange: ClosedRange<Date> {
        FinanceCalendar.futureDateRange()
    }
    var canSave: Bool {
        guard
            !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            let amount = currency?.minorUnits(from: targetText)
        else { return false }
        return amount > 0
            && (!hasTargetDate || targetDateRange.contains(targetDate))
            && !isSaving
    }

    func kindChanged() {
        iconKey = kind.systemImage
        colorRole = switch kind {
        case .savings: .savings
        case .debt: .debt
        case .investment: .investment
        case .other: .teal
        }
    }

    func save() async -> Bool {
        guard
            canSave,
            let target = currency?.minorUnits(from: targetText)
        else {
            errorMessage = L10n.text(
                "validation.goal.incomplete",
                table: .errors
            )
            return false
        }
        isSaving = true
        defer { isSaving = false }
        let request = requestContext.begin()
        let succeeded = await model.createGoal(
            GoalDraft(
                id: request.id,
                name: name,
                kind: kind,
                targetMinor: target,
                targetDate: hasTargetDate ? targetDate : nil,
                iconKey: iconKey,
                colorRole: colorRole,
                localDate: request.localDate
            )
        )
        errorMessage = succeeded ? nil : model.errorMessage
        return succeeded
    }
}
