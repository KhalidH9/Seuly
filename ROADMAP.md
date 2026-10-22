# Seuly Roadmap

This roadmap communicates direction, not promises or deadlines. Priorities may
change after security review, contributor feedback, and real-world validation.

## Public preview foundation

- Keep project licensing and third-party attribution current
- Protect `main`, enable CI, secret scanning, dependency updates, and CodeQL
- Add sanitized product screenshots and an accessibility review
- Add disposable-Supabase integration tests for RLS, RPCs, and replay safety
- Add in-app account deletion and document operator privacy obligations

## Reliability and usability

- Add UI tests for onboarding, authentication recovery, and core money flows
- Expand accessibility, localization, and visual-regression coverage
- Improve failure recovery, observability without tracking, and migration checks
- Validate performance with large but sanitized account histories
- Make backup, export, and user-controlled data portability explicit

## Product exploration

- Richer recurring-plan management and forecasting
- Widgets, App Intents, and Shortcuts where privacy can be preserved
- Optional import workflows with transparent review before saving
- More regional currencies and high-quality community translations
- Carefully scoped financial assistance that is explainable and opt-in

## Non-goals for now

Seuly is not a bank, payment processor, tax engine, investment adviser, or an
autonomous money manager. Features that obscure calculations, weaken tenant
isolation, upload data without clear consent, or add AI without measurable user
value will not be accepted.

Ideas are welcome through the repository's GitHub feature-request form.
