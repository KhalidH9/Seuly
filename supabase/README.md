# Supabase project configuration

The canonical SQL baseline is the root [Migrations](../Migrations) directory.
No migration copy is stored inside this package.

Supabase CLI discovers the committed `supabase/migrations` symlink to the
canonical directory. For a fresh project, verify the link, then link and push:

```sh
test "$(readlink supabase/migrations)" = "../Migrations"
supabase login
supabase link --project-ref YOUR_PROJECT_REF
supabase db push
supabase migration list
```

The ordered baseline creates 14 RLS-protected tables, three security-invoker
views, and eight authenticated write RPCs:

- `complete_onboarding`
- `save_account`
- `save_financial_transaction`
- `void_financial_transaction`
- `save_budget_line`
- `create_goal`
- `record_goal_contribution`
- `create_recurring_rule`

Authenticated clients receive table/view reads and exactly those RPC execute
grants. They receive no direct table write grants. RPCs derive the owner from
`auth.uid()` and bind retried creates to stable IDs and normalized payloads.

Configure Email Auth with **Confirm email** disabled, then allow both
`seuly://auth-callback` and `seuly://auth-recovery`. New registrations return
an active session immediately without proving email ownership. Before public
sign-up, configure CAPTCHA, rate limits, reliable SMTP, and monitoring. The
recovery redirect keeps password reset handling isolated. The client uses PKCE
and a publishable/legacy anon key. Never place database credentials or a
`service_role` key in the app.

This split baseline is intended for a clean database. Do not push, replay, or
blindly repair migration history on a project that recorded the former
monolithic migration. Back up, pull, diff, and reconcile it using the guarded
workflow in [Migrations/README.md](../Migrations/README.md). Append a new
timestamped file for every later schema change.
