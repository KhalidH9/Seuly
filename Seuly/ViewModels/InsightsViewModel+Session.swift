import Foundation

extension InsightsViewModel {
    func resetSession() {
        followsCurrentMonth = true
        selectedMonth = Date.now.startOfMonth()
    }
}
