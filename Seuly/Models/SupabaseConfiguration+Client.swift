import Supabase

extension SupabaseConfiguration {
    static var authOptions: SupabaseClientOptions.AuthOptions {
        .init(
            redirectToURL: AppConfiguration.authCallbackURL,
            flowType: .pkce,
            emitLocalSessionAsInitialSession: true
        )
    }

    func makeClient() -> SupabaseClient {
        SupabaseClient(
            supabaseURL: url,
            supabaseKey: publishableKey,
            options: SupabaseClientOptions(auth: Self.authOptions)
        )
    }
}
