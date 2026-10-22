import Foundation
import Observation

@MainActor
@Observable
final class MainTabViewModel {
    var selectedTab: MainTab = .overview
    var activeSheet: AppSheetRoute?
    var pendingSheet: AppSheetRoute?
    let dashboardViewModel: DashboardViewModel
    let activityViewModel: ActivityViewModel
    let planningViewModel: PlanningViewModel
    let insightsViewModel: InsightsViewModel
    let searchViewModel: UniversalSearchViewModel

    private let financeModel: FinanceModel
    private let authModel: AuthModel
    private let preferences: PreferencesModel

    var workspace: FinanceWorkspace { financeModel.workspace }

    init(
        financeModel: FinanceModel,
        authModel: AuthModel,
        preferences: PreferencesModel
    ) {
        self.financeModel = financeModel
        self.authModel = authModel
        self.preferences = preferences
        dashboardViewModel = DashboardViewModel(
            model: financeModel,
            preferences: preferences
        )
        activityViewModel = ActivityViewModel(
            model: financeModel,
            preferences: preferences
        )
        planningViewModel = PlanningViewModel(
            model: financeModel,
            preferences: preferences
        )
        insightsViewModel = InsightsViewModel(
            model: financeModel,
            preferences: preferences
        )
        searchViewModel = UniversalSearchViewModel(
            model: financeModel,
            preferences: preferences
        )
    }

    func makeTransactionViewModel(
        kind: TransactionKind,
        transaction: FinancialTransaction?
    ) -> TransactionFormViewModel {
        TransactionFormViewModel(
            model: financeModel,
            kind: kind,
            transaction: transaction
        )
    }

    func makeAccountViewModel(
        account: FinancialAccount?
    ) -> AccountFormViewModel {
        AccountFormViewModel(model: financeModel, account: account)
    }

    func makeBudgetViewModel() -> BudgetFormViewModel {
        BudgetFormViewModel(model: financeModel)
    }

    func makeGoalViewModel() -> GoalFormViewModel {
        GoalFormViewModel(model: financeModel)
    }

    func makeContributionViewModel(
        goal: SavingsGoal
    ) -> GoalContributionViewModel {
        GoalContributionViewModel(model: financeModel, goal: goal)
    }

    func makeRecurringViewModel() -> RecurringFormViewModel {
        RecurringFormViewModel(model: financeModel)
    }

    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel(
            financeModel: financeModel,
            authModel: authModel,
            preferences: preferences
        )
    }
}
