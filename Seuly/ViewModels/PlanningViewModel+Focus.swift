import Foundation

extension PlanningViewModel {
    var isCurrentBudgetFocused: Bool {
        guard let id = analytics.currentBudget?.id else { return false }
        return isFocused(id)
    }

    var currentBudgetFocusAccessibilityHint: String {
        guard let id = analytics.currentBudget?.id else { return "" }
        return focusAccessibilityHint(for: id)
    }

    var activeGoals: [SavingsGoal] {
        prioritize(
            workspace.goals.filter { $0.status == .active },
            id: \.id
        )
    }

    var activeRecurring: [RecurringRule] {
        let sorted = workspace.recurringRules
            .filter { $0.status == .active }
            .sorted { $0.nextRunDate < $1.nextRunDate }
        return prioritize(sorted, id: \.id)
    }

    func isFocused(_ id: UUID) -> Bool {
        focusedEntityID == id
    }

    func focusAccessibilityHint(for id: UUID) -> String {
        isFocused(id)
            ? L10n.text("search.focused.accessibility", table: .shared)
            : ""
    }

    private func prioritize<Value>(
        _ values: [Value],
        id: KeyPath<Value, UUID>
    ) -> [Value] {
        guard
            let focusedEntityID,
            let index = values.firstIndex(where: {
                $0[keyPath: id] == focusedEntityID
            })
        else { return values }
        var result = values
        result.insert(result.remove(at: index), at: 0)
        return result
    }
}
