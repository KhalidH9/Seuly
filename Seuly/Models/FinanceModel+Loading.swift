import Foundation

extension FinanceModel {
    @discardableResult
    func load(userID: UUID, force: Bool = false) async -> Bool {
        if currentUserID != userID {
            resetForUser(userID)
        }
        currentUserID = userID
        let failed: Bool
        if case .failed = loadState { failed = true } else { failed = false }
        guard force || loadState == .idle || failed else { return false }
        guard !isMutating else { return false }

        if !hasLoadedContent { loadState = .loading }
        stateGeneration &+= 1
        let generation = stateGeneration
        do {
            let value = try await fetchWorkspace(userID: userID)
            if Task.isCancelled {
                restoreAfterCancellation(
                    userID: userID,
                    generation: generation
                )
                return false
            }
            guard isCurrent(userID: userID, generation: generation) else {
                return false
            }
            workspace = value
            loadState = .loaded
            errorMessage = nil
            return true
        } catch {
            if Task.isCancelled {
                restoreAfterCancellation(
                    userID: userID,
                    generation: generation
                )
                return false
            }
            guard isCurrent(userID: userID, generation: generation) else {
                return false
            }
            let message = ErrorPresenter.message(
                for: error,
                context: .workspaceLoad
            )
            if hasLoadedContent {
                errorMessage = message
                loadState = .loaded
            } else {
                loadState = .failed(message)
            }
            return false
        }
    }

    @discardableResult
    func refresh() async -> Bool {
        guard let currentUserID else { return false }
        return await load(userID: currentUserID, force: true)
    }

    func clear() {
        stateGeneration &+= 1
        currentUserID = nil
        activeMutationID = nil
        isMutating = false
        workspace = .empty
        loadState = .idle
        errorMessage = nil
    }

    func isCurrent(userID: UUID, generation: UInt) -> Bool {
        !Task.isCancelled
            && currentUserID == userID
            && stateGeneration == generation
    }

    private func resetForUser(_ userID: UUID) {
        stateGeneration &+= 1
        currentUserID = userID
        activeMutationID = nil
        isMutating = false
        workspace = .empty
        loadState = .idle
    }

    private func restoreAfterCancellation(
        userID: UUID,
        generation: UInt
    ) {
        guard currentUserID == userID, stateGeneration == generation else {
            return
        }
        loadState = hasLoadedContent ? .loaded : .idle
    }
}
