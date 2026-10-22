import Foundation

extension AuthModel {
    func observeAuthentication() {
        observationTask?.cancel()
        observationTask = Task { [weak self, client] in
            for await (event, session) in client.auth.authStateChanges {
                guard !Task.isCancelled else { break }
                guard let self else { break }
                if AuthSessionPolicy.shouldIgnore(
                    event: event,
                    sessionIsExpired: session?.isExpired == true
                ) {
                    continue
                }
                let user = AuthSessionPolicy.user(
                    for: event,
                    session: session
                )
                if event == .passwordRecovery, let user {
                    phase = .signedIn(user)
                    beginPasswordRecovery()
                } else if let user {
                    phase = .signedIn(user)
                } else {
                    phase = .signedOut
                }
            }
        }
    }
}
