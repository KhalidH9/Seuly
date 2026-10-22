import Supabase

enum AuthSessionPolicy {
    static func shouldIgnore(
        event: AuthChangeEvent,
        sessionIsExpired: Bool
    ) -> Bool {
        event == .initialSession && sessionIsExpired
    }

    static func user(
        for event: AuthChangeEvent,
        session: Session?
    ) -> AppUser? {
        guard let session else { return nil }
        guard allowsAuthentication(
            for: event,
            sessionIsExpired: session.isExpired
        ) else { return nil }
        return AppUser(
            id: session.user.id,
            email: session.user.email ?? ""
        )
    }

    static func allowsAuthentication(
        for event: AuthChangeEvent,
        sessionIsExpired: Bool
    ) -> Bool {
        guard !sessionIsExpired else { return false }
        return event != .signedOut && event != .userDeleted
    }
}
