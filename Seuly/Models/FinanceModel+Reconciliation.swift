import Foundation

extension FinanceModel {
    func reconcileCancelledMutation(
        userID: UUID,
        generation: UInt,
        scope: FinanceMutationRefresh
    ) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                try await refreshAfterMutation(
                    scope,
                    userID: userID,
                    generation: generation
                )
                guard isCurrent(
                    userID: userID,
                    generation: generation
                ) else { return }
                loadState = .loaded
                errorMessage = L10n.text(
                    "error.data.cancelled_refreshed",
                    table: .errors
                )
            } catch {
                guard
                    currentUserID == userID,
                    stateGeneration == generation
                else { return }
                errorMessage = L10n.text(
                    "error.data.cancelled_uncertain",
                    table: .errors
                )
            }
        }
    }
}
