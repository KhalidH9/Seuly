# Privacy

This document describes the open-source Seuly client. The repository does not
include or operate a public hosted service. A person or organization deploying
Seuly must publish a policy for its own Supabase project and jurisdiction.

## Data Seuly uses

Depending on what a user enters, Seuly processes a display name, email address,
Supabase user identifier, accounts, institutions, transactions, merchants,
notes, budgets, goals, recurring plans, categories, and preferences. These
records are linked to the authenticated account to provide app functionality.

## Where data goes

The app communicates directly with the configured Supabase project. Supabase
Auth manages the authentication session. Financial records are stored in that
project's Postgres database. The project operator controls its region,
retention, backups, logs, subprocessors, and administrative access.

Language, appearance, and the visual privacy-mode preference are stored in
`UserDefaults` on the device. Privacy mode only obscures amounts on screen; it
does not encrypt, delete, or withhold them from the configured database.

## Tracking and analytics

The client contains no advertising SDK, behavioral analytics, or tracking
domains. Its Apple privacy manifest declares no tracking. It declares name,
email address, user ID, other financial information, and other user content as
linked data used for app functionality, plus the required-reason UserDefaults
API (`CA92.1`). Review dependency and platform behavior before deployment.

## Access, correction, and deletion

Users can update supported records through the app. This preview does not yet
provide in-app account deletion or a complete data-export flow. A hosted
operator must provide a contact and lawful request process. In a self-managed
project, deleting the Auth user cascades through Seuly's user-owned tables;
verify backups and retention separately before promising deletion timing.

## Security and retention

Postgres Row Level Security scopes reads to the authenticated user. Client
writes use validated RPCs instead of direct table grants. These controls do not
replace secure configuration, updates, backups, access reviews, or incident
response. See [SECURITY.md](SECURITY.md).

Seuly is not directed to children. This text is technical documentation, not
legal advice, and should be reviewed before distributing a hosted build.
