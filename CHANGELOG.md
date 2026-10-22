# Changelog

All notable changes to Seuly will be recorded here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and releases follow
[Semantic Versioning](https://semver.org/spec/v2.0.0.html) where practical.

## [Unreleased]

### Added

- Initial public-source documentation and contribution workflows.
- Arabic-first and English-localized SwiftUI personal-finance experience.
- Supabase Auth, forced-RLS schema, security-invoker views, and audited RPCs.
- Accounts, transactions, transfers, budgets, goals, recurring plans, search,
  cash-flow insights, safe-to-spend, privacy mode, and appearance controls.
- Official Saudi Riyal symbol support and integer minor-unit money handling.

### Changed

- Standardized the project and product name as Seuly.

### Security

- RLS-governed reads, tenant isolation for owned data, and eight write RPCs.
- Rejected privileged Supabase keys from client configuration.

[Unreleased]: https://github.com/KhalidH9/Seuly/commits/main
