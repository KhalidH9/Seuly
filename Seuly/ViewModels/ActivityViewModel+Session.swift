import Foundation

extension ActivityViewModel {
    func resetSession() {
        clearFilters()
        selectedTransaction = nil
        deletionCandidate = nil
        detailDismissalAction = nil
    }
}
