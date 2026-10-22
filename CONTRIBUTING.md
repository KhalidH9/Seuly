# Contributing to Seuly

Thank you for improving Seuly. Small, focused pull requests are easiest to
review. For substantial product or schema changes, open a feature request first.

## Before you begin

- Do not include credentials, personal financial data, or production exports.
- Use a disposable Supabase project for database testing.
- Report vulnerabilities privately as described in [SECURITY.md](SECURITY.md).

## Workflow

1. Fork the repository and branch from `main`.
2. Use `feature/`, `fix/`, `docs/`, or `chore/` plus a short name.
3. Follow the setup in [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md).
4. Add or update tests and both localizations where behavior changes.
5. Run the checks below and complete the pull-request template.

Use a Conventional Commit subject, such as `fix: preserve transfer balance`.
Maintainers squash-merge accepted pull requests into a linear history.

## Engineering rules

- Use strict MVVM only: Views → ViewModels → Models → Supabase.
- Views render and forward intent; they do not call APIs or own business rules.
- ViewModels are `@MainActor`, presentation-focused, and dependency-injected.
- Models own domain rules, DTO mapping, authentication, and async networking.
- Use `async`/`await`, cancellation checks, and structured `Task` lifetimes.
- Reuse existing types and helpers instead of duplicating behavior.
- Keep every authored Swift, SQL, and localization file at 100 lines or fewer.
- Keep exactly one SwiftUI `View` struct in every file under `Seuly/Views`.
- Store monetary values as `Int64` minor units; never use floating-point money.
- Never add demo or fallback financial records to the production runtime.

## Database changes

Append one timestamped migration to `Migrations/`; never edit an applied file.
Keep `Migrations/` canonical and expose it through `supabase/migrations` with a
symlink. Preserve forced RLS, tenant isolation, least privilege, idempotent
request identifiers, and journal balance. Read [docs/DATABASE.md](docs/DATABASE.md).

## Localization and accessibility

Arabic is the default and English is fully supported. Every user-facing string
belongs in matching `.strings` tables. Preserve placeholders, RTL layout,
Dynamic Type, VoiceOver labels, contrast, and 44-point interaction targets.
See [docs/LOCALIZATION.md](docs/LOCALIZATION.md).

## Required checks

```sh
xcodebuild -project Seuly.xcodeproj -scheme Seuly \
  -destination 'generic/platform=iOS Simulator' build
xcodebuild -project Seuly.xcodeproj -scheme Seuly \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' test
xcodebuild -project Seuly.xcodeproj -scheme Seuly -configuration Release \
  -destination 'generic/platform=iOS' build CODE_SIGNING_ALLOWED=NO
```

A pull request should explain the user impact, test evidence, schema/security
impact, and screenshots for visible changes. By contributing, you confirm that
you have the right to submit the work under the Apache License 2.0.
