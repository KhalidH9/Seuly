import Foundation
import Observation

@MainActor
@Observable
final class PlanningViewModel {
    enum Section: String, CaseIterable, Identifiable {
        case budgets
        case goals
        case recurring
        var id: String { rawValue }
        var displayName: String {
            L10n.text("planning.section.\(rawValue)", table: .data)
        }
    }

    private let model: FinanceModel
    private let preferences: PreferencesModel
    var selectedSection: Section = .budgets
    var focusedEntityID: UUID?

    init(model: FinanceModel, preferences: PreferencesModel) {
        self.model = model
        self.preferences = preferences
    }

    var workspace: FinanceWorkspace { model.workspace }
    var analytics: FinanceAnalytics {
        FinanceAnalytics(workspace: workspace)
    }
    var currency: CurrencyDefinition? { workspace.currency }
    var errorMessage: String? { model.errorMessage }
    var isPrivacyModeEnabled: Bool {
        preferences.isPrivacyModeEnabled
    }

    var budgetOverview: BudgetOverview? {
        let progress = analytics.budgetProgress
        guard !progress.isEmpty else { return nil }
        let limit = progress.lazy.map { $0.line.limitMinor }.sumClamped()
        let spent = progress.lazy.map(\.spentMinor).sumClamped()
        return BudgetOverview(
            progress: progress,
            limitMinor: limit,
            utilization: limit > 0 ? Double(spent) / Double(limit) : 0
        )
    }

    var resetChecklist: [(title: String, isComplete: Bool)] {
        [
            (
                L10n.text("planning.checklist.budgets", table: .data),
                analytics.budgetProgress.allSatisfy { $0.fraction < 1 }
            ),
            (
                L10n.text("planning.checklist.bills", table: .data),
                activeRecurring.isEmpty
                    || analytics.upcomingRecurringOccurrences.count <= 3
            ),
            (
                L10n.text("planning.checklist.goal", table: .data),
                !activeGoals.isEmpty
            )
        ]
    }

    func refresh() async {
        await model.refresh()
    }

    func resetSession() {
        selectedSection = .budgets
        focusedEntityID = nil
    }
}
