# Seuly database migrations

This directory is the canonical fresh-deploy database baseline. Apply every
numbered SQL file once, in ascending lexical order. Do not skip or reorder
files: later tables, policies, functions, and grants depend on earlier files.

Each SQL file owns a complete transaction and is limited to 100 physical
lines. If one file fails, stop, fix the cause, and restart against a clean
database. This baseline is not intended to be replayed over a database that
already recorded the former monolithic migration.

The SQL filenames follow Supabase's `<timestamp>_<name>.sql` convention. The
CLI discovers migrations at `supabase/migrations`; the repository already
tracks that path as a symlink to this canonical directory. Verify it, then run:

```sh
test "$(readlink supabase/migrations)" = "../Migrations"
supabase db reset
```

Use `supabase db push` instead of `db reset` for a linked fresh project. Do not
commit copied SQL files under both locations; that creates two migration
histories. Append future changes with a new, unique 14-digit timestamp.

## Reconciling an existing deployment

Do not run `db push`, remote `db reset`, or `migration repair` against a project
that recorded the former monolithic migration. First create and verify a
restorable database backup. In an isolated checkout, expose this directory at
`supabase/migrations`, link the project, and inspect both histories and schemas:

```sh
supabase migration list
supabase db pull deployed_snapshot
supabase db diff --linked --schema public,private
```

Keep the pulled snapshot outside this canonical baseline and decline any
history repair prompt until the review is complete. Inspect the generated SQL,
RLS policies, grants, security-invoker views, private functions, and the auth
provisioning trigger; schema diff tools do not prove semantic equivalence.

Only when the deployed schema is independently verified as equivalent to the
entire split baseline may its versions be recorded without executing them:

```sh
for file in Migrations/[0-9]*_*.sql; do
  version="${file##*/}"; version="${version%%_*}"
  supabase migration repair "$version" --status applied || exit 1
done
supabase migration repair OLD_MONOLITH_VERSION --status reverted
supabase migration list
```

`migration repair` changes history only; it never applies SQL. If any schema
difference exists, generate a reviewed incremental upgrade migration instead,
test it against a restored copy, apply it under change control, and repeat the
pull/diff review. Repair history only after the upgraded schema is equivalent.
