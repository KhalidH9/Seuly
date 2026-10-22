import Foundation

extension MainTabViewModel {
    func presentPendingSheet() {
        guard let pendingSheet else { return }
        self.pendingSheet = nil
        activeSheet = pendingSheet
    }

    func resetSession() {
        selectedTab = .overview
        activeSheet = nil
        pendingSheet = nil
        dashboardViewModel.resetSession()
        activityViewModel.resetSession()
        planningViewModel.resetSession()
        insightsViewModel.resetSession()
        searchViewModel.resetSession()
    }
}
