import Foundation
import Observation
import Supabase

@MainActor
@Observable
final class AuthModel {
    enum Phase: Equatable {
        case launching
        case signedOut
        case signedIn(AppUser)
    }

    var phase: Phase = .launching
    var errorMessage: String?
    var isPasswordRecovery: Bool
    let client: SupabaseClient
    let defaults: UserDefaults
    var observationTask: Task<Void, Never>?

    static let recoveryKey = "seuly.activePasswordRecovery"
    static let legacyRecoveryKey = "siyuli.pendingPasswordRecovery"
    static let legacyActiveRecoveryKey = "siyuli.activePasswordRecovery"

    init(client: SupabaseClient, defaults: UserDefaults = .standard) {
        self.client = client
        self.defaults = defaults
        let legacyRecovery = defaults.bool(
            forKey: Self.legacyActiveRecoveryKey
        )
        isPasswordRecovery = defaults.bool(forKey: Self.recoveryKey)
            || legacyRecovery
        if legacyRecovery {
            defaults.set(true, forKey: Self.recoveryKey)
        }
        defaults.removeObject(forKey: Self.legacyActiveRecoveryKey)
        defaults.removeObject(forKey: Self.legacyRecoveryKey)
        observeAuthentication()
    }

    var currentUser: AppUser? {
        guard case .signedIn(let user) = phase else { return nil }
        return user
    }

    func start() async {
        do {
            let session = try await client.auth.session
            guard !session.isExpired else {
                phase = .signedOut
                return
            }
            phase = .signedIn(
                AppUser(
                    id: session.user.id,
                    email: session.user.email ?? ""
                )
            )
        } catch {
            phase = .signedOut
        }
    }

    func beginPasswordRecovery() {
        isPasswordRecovery = true
        defaults.set(true, forKey: Self.recoveryKey)
    }

    func clearPasswordRecovery() {
        isPasswordRecovery = false
        defaults.removeObject(forKey: Self.recoveryKey)
    }
}
