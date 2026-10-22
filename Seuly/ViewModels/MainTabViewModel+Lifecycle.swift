import Foundation

extension MainTabViewModel {
    func updateDates(referenceDate: Date) {
        dashboardViewModel.updateReferenceDate(referenceDate)
        insightsViewModel.updateReferenceDate(referenceDate)
    }
}
