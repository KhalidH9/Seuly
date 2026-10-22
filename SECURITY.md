# Security Policy

Seuly handles sensitive financial records. Please report vulnerabilities
privately and give maintainers a reasonable opportunity to respond.

## Supported versions

Until a stable release exists, only the latest commit on `main` and the newest
tagged preview receive security fixes. Older previews are unsupported.

## Reporting a vulnerability

Use GitHub's private vulnerability form:

https://github.com/KhalidH9/Seuly/security/advisories/new

Do not open a public issue. Include affected versions, impact, reproduction
steps, proof of concept where safe, and any suggested mitigation. Remove real
credentials and personal or financial data from the report.

Maintainers aim to acknowledge a report within three business days and provide
a status update within seven. Resolution timing depends on scope and severity.
Please coordinate disclosure; no bounty program is currently offered.

## Security boundaries

In scope are the iOS client, authentication callbacks, committed migrations,
RLS policies, write RPCs, cross-user data isolation, and accidental secret
exposure. Supabase platform vulnerabilities should also be reported to
Supabase through its official security process.

Avoid denial-of-service testing, social engineering, accessing another
person's data, or testing any project you do not own. Use a disposable local or
hosted Supabase project.

## Credential policy

Only a Supabase publishable key or legacy `anon` key belongs in the client.
Never commit database passwords, JWT secrets, secret keys, access tokens, or a
`service_role` key. `Seuly/Support/SupabaseSecrets.plist` is intentionally
ignored. If a privileged value is exposed, revoke or rotate it immediately;
removing it from Git history is not sufficient.

Forced RLS and RPC validation reduce risk but are not a security guarantee.
Deployers remain responsible for reviewing migrations, access logs, Auth
settings, dependency alerts, backups, and their Supabase organization.
