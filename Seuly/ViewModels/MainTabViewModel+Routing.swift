import Foundation

extension MainTabViewModel {
    func present(_ route: AppSheetRoute) {
        activeSheet = route
    }

    func replaceSheet(with route: AppSheetRoute) {
        pendingSheet = route
        activeSheet = nil
    }

    func openSearchResult(_ result: UniversalSearchResult) {
        switch result.destination {
        case .transaction(let id):
            guard let transaction = workspace.transactions.first(
                where: { $0.id == id }
            ) else { return }
            selectedTab = .activity
            activityViewModel.selectedTransaction = transaction
        case .account(let id):
            guard let account = workspace.account(id: id) else { return }
            present(.account(account))
        case .category(let id):
            guard let category = workspace.category(id: id) else { return }
            activityViewModel.period = .recent
            activityViewModel.selectedKind = category.kind == .income
                ? .income : .expense
            activityViewModel.selectedCategoryID = category.id
            activityViewModel.searchText = ""
            selectedTab = .activity
        case .planning(let kind, let entityID):
            planningViewModel.selectedSection = planningSection(for: kind)
            planningViewModel.focusedEntityID = entityID
            selectedTab = .plan
        }
    }

    private func planningSection(
        for kind: UniversalSearchKind
    ) -> PlanningViewModel.Section {
        switch kind {
        case .goal: .goals
        case .recurring: .recurring
        default: .budgets
        }
    }
}
