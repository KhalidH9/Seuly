# Development Guide

## Requirements

- macOS with Xcode 26.6 or newer
- iOS/iPadOS 17+ simulator or device
- Git, Docker, and the Supabase CLI
- A disposable Supabase project for hosted integration work

## Clone and prepare

```sh
git clone https://github.com/KhalidH9/Seuly.git
cd Seuly
xcodebuild -resolvePackageDependencies -project Seuly.xcodeproj
test "$(readlink supabase/migrations)" = "../Migrations"
```

`Migrations/` is the only SQL source. The committed symlink lets the Supabase
CLI discover it without creating a second migration history.

## Run Supabase locally

```sh
supabase start
supabase db reset
supabase status
```

Copy `Seuly/Support/SupabaseSecrets.plist.example` to the ignored
`SupabaseSecrets.plist`. Set `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` to
the local API URL and client-safe anon key shown by `supabase status`.

Loopback HTTP endpoints are accepted only in Debug builds and work from the
iOS Simulator. A physical device cannot reach the Mac through `127.0.0.1`;
use a reviewed hosted project for device testing.

Local Auth should allow `seuly://auth-callback` and `seuly://auth-recovery`.
Email confirmation is disabled because registration expects an active session.

## Use a new hosted project

```sh
supabase login
supabase link --project-ref YOUR_PROJECT_REF
supabase db push
supabase migration list
```

Only do this against a new or reviewed disposable project. Never reset, push,
or repair a database that used another migration history until it is backed up,
pulled, diffed, and reconciled using `Migrations/README.md`.

In Supabase Auth, enable Email sign-up, disable **Confirm email**, and add both
callback URLs. This immediate-session flow does not prove email ownership.
Before public sign-up, configure CAPTCHA, rate limits, reliable SMTP, and
monitoring. Put only the URL and publishable/legacy anon key in the client.
Never use a database password, secret key, or `service_role` key.

## Build and test

Open `Seuly.xcodeproj`, choose the `Seuly` scheme, select a simulator, and run.
For a device build, choose your own development team locally; shared settings
must not contain a maintainer's team identifier. Forks may also need unique app
and test bundle identifiers for signing; keep those personal changes local.

```sh
xcodebuild -project Seuly.xcodeproj -scheme Seuly \
  -destination 'generic/platform=iOS Simulator' build
xcodebuild -project Seuly.xcodeproj -scheme Seuly \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' test
xcodebuild -project Seuly.xcodeproj -scheme Seuly -configuration Release \
  -destination 'generic/platform=iOS' build CODE_SIGNING_ALLOWED=NO
```

Use `xcodebuild -project Seuly.xcodeproj -scheme Seuly -showdestinations` and
substitute any installed iPhone simulator when the documented model is absent.

The unit target has 85 tests. It covers money safety, analytics, recurring
projection, localization, auth/session policy, persistence context, and search.
It does not yet replace live disposable-project RLS/RPC integration tests.

## Configuration alternatives

CI or a launch environment may provide `SUPABASE_URL` and
`SUPABASE_PUBLISHABLE_KEY`; environment values take precedence over the plist.
Invalid hosts, placeholders, privileged keys, and unknown key formats are
rejected. A missing valid configuration intentionally shows a setup screen.

## Before a pull request

Follow `CONTRIBUTING.md`. Validate both languages, inspect visible RTL/LTR
layouts, test cancellation and session changes, and verify that no credential
or private financial record is staged. Database work must also test anonymous
denial, direct-write denial, and isolation between two users.
