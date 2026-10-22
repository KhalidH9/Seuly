import SwiftUI

struct MainTabSheetView: View {
    @Bindable var viewModel: MainTabViewModel
    let route: AppSheetRoute

    @ViewBuilder
    var body: some View {
        switch route {
        case .transaction(let kind, let transaction):
            TransactionFormView(
                viewModel: viewModel.makeTransactionViewModel(
                    kind: kind,
                    transaction: transaction
                )
            )
        case .account(let account):
            AccountFormView(
                viewModel: viewModel.makeAccountViewModel(account: account)
            )
        case .budget:
            BudgetFormView(viewModel: viewModel.makeBudgetViewModel())
        case .goal:
            GoalFormView(viewModel: viewModel.makeGoalViewModel())
        case .goalContribution(let goal):
            GoalContributionView(
                viewModel: viewModel.makeContributionViewModel(goal: goal)
            )
        case .recurring:
            RecurringFormView(viewModel: viewModel.makeRecurringViewModel())
        case .settings:
            ProfileView(
                viewModel: viewModel.makeSettingsViewModel(),
                onPresentAccount: presentAccount
            )
        }
    }

    private func presentAccount(_ account: FinancialAccount?) {
        viewModel.replaceSheet(with: .account(account))
    }
}
