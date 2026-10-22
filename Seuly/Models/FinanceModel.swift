import Foundation
import Observation
import Supabase

@MainActor
@Observable
final class FinanceModel {
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    var workspace: FinanceWorkspace = .empty {
        didSet { workspaceRevision &+= 1 }
    }
    private(set) var workspaceRevision: UInt = 0
    var loadState: LoadState = .idle
    var isMutating = false
    var errorMessage: String?

    let client: SupabaseClient
    var currentUserID: UUID?
    var stateGeneration: UInt = 0
    var activeMutationID: UUID?

    init(client: SupabaseClient) {
        self.client = client
    }

    var hasLoadedContent: Bool { workspace.profile != nil }
}
