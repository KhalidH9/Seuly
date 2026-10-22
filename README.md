# Seuly

[![CI](https://github.com/KhalidH9/Seuly/actions/workflows/ci.yml/badge.svg)](https://github.com/KhalidH9/Seuly/actions/workflows/ci.yml) [![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-087F73.svg)](LICENSE)

Seuly is an Arabic-first, privacy-minded personal-finance app for iPhone and
iPad. It combines a native SwiftUI interface, strict MVVM, and a Supabase
backend to help people understand their money without fabricated demo data.

> Seuly is an early open-source preview. It is not financial advice, and no
> hosted production service is included with this repository.

## What it does

- Email/password authentication, session restoration, and password recovery
- Guided profile, currency, first-account, and starter-budget onboarding
- Asset, liability, income, expense, and balanced-transfer tracking
- Monthly budgets, savings goals, contributions, and recurring plans
- A searchable activity timeline and month-by-month insights
- Safe-to-spend, cash-flow, category, and account-balance calculations
- Arabic RTL by default, English LTR, dark mode, and privacy mode
- Integer minor-unit money storage and the official Saudi Riyal symbol

Seuly reads real data from Supabase. Missing credentials lead to a clear
configuration screen; the app never substitutes mock financial records.

## Technology

- Swift, SwiftUI, Observation, structured concurrency, and iOS/iPadOS 17+
- Model–View–ViewModel only; networking is owned by Models
- Supabase Auth, Postgres, Row Level Security, and audited write RPCs
- `supabase-swift` 2.54.1 through Swift Package Manager

## Quick start

Requirements: Xcode 26.6 or newer, Supabase CLI, Docker, and Git.

```sh
git clone https://github.com/KhalidH9/Seuly.git
cd Seuly
test "$(readlink supabase/migrations)" = "../Migrations"
supabase start
supabase db reset
```

Copy `Seuly/Support/SupabaseSecrets.plist.example` to
`Seuly/Support/SupabaseSecrets.plist`. Add the local URL and client-safe
publishable/anon key printed by `supabase status`. Never use a secret or
`service_role` key in an iOS build.

The loopback HTTP URL is accepted only in Debug builds and is intended for the
iOS Simulator. Use a reviewed hosted Supabase project when testing on a device.

For hosted use, enable Email Auth and add these callbacks. If confirmation is
disabled, configure CAPTCHA, rate limits, reliable SMTP, and monitoring first:

```text
seuly://auth-callback
seuly://auth-recovery
```

Then open `Seuly.xcodeproj` and run the shared `Seuly` scheme, or use:

```sh
xcodebuild -resolvePackageDependencies -project Seuly.xcodeproj
xcodebuild -project Seuly.xcodeproj -scheme Seuly \
  -destination 'generic/platform=iOS Simulator' build
xcodebuild -project Seuly.xcodeproj -scheme Seuly \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' test
```

See [Development](docs/DEVELOPMENT.md) for hosted setup and migration safety.

## Architecture and database

The dependency direction is `View → ViewModel → Model → Supabase`. Views render
state, ViewModels coordinate presentation, and `AuthModel`/`FinanceModel` own
async data access. There are no repositories, services, coordinators, or
alternate application architectures.

The canonical database baseline is the 34 ordered files in `Migrations/`:
14 forced-RLS tables, three security-invoker views, and eight authenticated
write RPCs. Reads are RLS-governed and tenant-scoped for user-owned data;
clients receive no direct table writes. See [Architecture](docs/ARCHITECTURE.md) and
[Database](docs/DATABASE.md).

## Project documentation

- [Development guide](docs/DEVELOPMENT.md)
- [Database reference](docs/DATABASE.md)
- [Localization guide](docs/LOCALIZATION.md)
- [Contributing](CONTRIBUTING.md)
- [Security](SECURITY.md), [Privacy](PRIVACY.md), and [Support](SUPPORT.md)
- [Roadmap](ROADMAP.md), [Changelog](CHANGELOG.md), and
  [third-party notices](THIRD_PARTY_NOTICES.md)

## Project status

The unit suite contains 85 tests. Live disposable-project RLS/RPC integration
tests and in-app account deletion remain release work. Seuly is licensed under
the [Apache License 2.0](LICENSE).
