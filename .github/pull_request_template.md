## Summary

<!-- What changed, why, and what user outcome does it produce? -->

## Type

- [ ] Feature
- [ ] Bug fix
- [ ] Refactor
- [ ] Database/security
- [ ] Localization/accessibility
- [ ] Documentation/tooling

## Verification

<!-- List exact automated and manual checks with results. -->

- [ ] Debug simulator build succeeds
- [ ] Unit tests pass
- [ ] Unsigned Release device build succeeds
- [ ] Arabic RTL and English LTR were checked where relevant
- [ ] Light/dark mode, Dynamic Type, and VoiceOver were checked where relevant

## Architecture and quality

- [ ] The change preserves strict View → ViewModel → Model boundaries
- [ ] No authored Swift, SQL, or localization file exceeds 100 lines
- [ ] Every file under `Seuly/Views` contains one `View` struct
- [ ] Reusable behavior was extended instead of duplicated
- [ ] Production runtime contains no mock, demo, or fallback financial data

## Data and security

- [ ] No credential, personal record, or production database content is included
- [ ] Money remains integer minor units; journal/transfer invariants are preserved
- [ ] Schema changes are append-only migrations in root `Migrations/`
- [ ] RLS, grants, RPC ownership, replay safety, and two-user isolation were reviewed
- [ ] Privacy implications and data retention behavior are documented

## Localization

- [ ] All user-facing copy is localized in both Arabic and English
- [ ] Keys and placeholder types match, and mixed-direction values render correctly

## Visual evidence

<!-- Add sanitized before/after images or write “Not applicable.” -->

## Related work

<!-- Closes #123; links to discussion or design context. -->
