import Foundation

extension FinanceModel {
    func saveBudgetLine(_ draft: BudgetLineDraft) async -> Bool {
        await performMutation(refreshing: .budgets) {
            try await client.rpc(
                "save_budget_line",
                params: SaveBudgetLinePayload(
                    budgetID: draft.budgetID,
                    categoryID: draft.categoryID,
                    limitMinor: draft.limitMinor,
                    localDate: draft.localDate.databaseValue
                )
            ).execute()
        }
    }

    func createGoal(_ draft: GoalDraft) async -> Bool {
        await performMutation(refreshing: .goals) {
            try await client.rpc(
                "create_goal",
                params: CreateGoalPayload(
                    goalID: draft.id,
                    name: draft.name,
                    kind: draft.kind.rawValue,
                    targetMinor: draft.targetMinor,
                    targetOn: draft.targetDate.map(DatabaseDate.string),
                    iconKey: draft.iconKey,
                    colorRole: draft.colorRole.rawValue,
                    localDate: draft.localDate.databaseValue
                )
            ).execute()
        }
    }

    func contribute(_ draft: GoalContributionDraft) async -> Bool {
        await performMutation(refreshing: .goals) {
            try await client.rpc(
                "record_goal_contribution",
                params: GoalContributionPayload(
                    eventID: draft.id,
                    goalID: draft.goalID,
                    amountMinor: draft.amountMinor,
                    note: draft.note,
                    localDate: draft.localDate.databaseValue
                )
            ).execute()
        }
    }

    func createRecurringRule(_ draft: RecurringRuleDraft) async -> Bool {
        await performMutation(refreshing: .recurringRules) {
            try await client.rpc(
                "create_recurring_rule",
                params: CreateRecurringPayload(
                    ruleID: draft.id,
                    kind: draft.kind.rawValue,
                    amountMinor: draft.amountMinor,
                    sourceAccountID: draft.sourceAccountID,
                    destinationAccountID: draft.destinationAccountID,
                    categoryID: draft.categoryID,
                    merchant: draft.merchant,
                    memo: draft.note,
                    cadence: draft.cadence.rawValue,
                    nextRunOn: DatabaseDate.string(from: draft.nextRunDate),
                    localDate: draft.localDate.databaseValue
                )
            ).execute()
        }
    }
}
