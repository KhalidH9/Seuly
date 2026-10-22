import Foundation

extension FinanceModel {
    func performMutation(
        refreshing scope: FinanceMutationRefresh,
        _ operation: @MainActor () async throws -> Void
    ) async -> Bool {
        guard let userID = currentUserID else {
            errorMessage = AppError.unauthenticated.localizedDescription
            return false
        }
        guard !isMutating else {
            errorMessage = L10n.text(
                "error.data.save_in_progress",
                table: .errors
            )
            return false
        }

        stateGeneration &+= 1
        let generation = stateGeneration
        let mutationID = UUID()
        activeMutationID = mutationID
        isMutating = true
        defer {
            if activeMutationID == mutationID {
                activeMutationID = nil
                isMutating = false
            }
        }

        do {
            try await operation()
        } catch {
            if Task.isCancelled || error is CancellationError {
                reconcileCancelledMutation(
                    userID: userID,
                    generation: generation,
                    scope: scope
                )
                return false
            }
            guard isCurrent(userID: userID, generation: generation) else {
                return false
            }
            errorMessage = ErrorPresenter.message(
                for: error,
                context: .mutation
            )
            if hasLoadedContent { loadState = .loaded }
            return false
        }
        guard isCurrent(userID: userID, generation: generation) else {
            return false
        }
        do {
            try await refreshAfterMutation(
                scope,
                userID: userID,
                generation: generation
            )
            guard isCurrent(userID: userID, generation: generation) else {
                return false
            }
            errorMessage = nil
            loadState = .loaded
        } catch {
            guard isCurrent(userID: userID, generation: generation) else {
                return false
            }
            errorMessage = L10n.text(
                "error.data.saved_refresh_failed",
                table: .errors
            )
            loadState = .loaded
        }
        return true
    }
}
