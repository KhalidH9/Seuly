# Localization

Seuly ships Arabic and English. Arabic (`ar_SA`) is the product default and
fallback; English (`en_US`) is opt-in. The app changes text, locale, numerals,
dates, currency presentation, and layout direction together at runtime.

## Resources

Localized resources live in `Localization/ar.lproj` and
`Localization/en.lproj`. Each language has 484 entries representing 475
distinct key names across 13 tables:

```text
Activity  App  Auth  Dashboard  Data  Errors  InfoPlist
Insights  Onboarding  Planning  Settings  Shared  Transactions
```

`L10n` resolves a named key and table. `AppLanguage` defines the supported
locales and directions. `LocalizationStore` caches the selected bundles, while
`AppFormatters` and money presentation use the active locale.

## Copy workflow

1. Choose the table owned by the feature; do not create a generic duplicate.
2. Add the same key to Arabic and English in the same change.
3. Write natural Arabic first, then an equivalent—not mechanically literal—
   English message.
4. Preserve every format placeholder and its type in both values.
5. Use `L10n.text` for plain copy and `L10n.format` for substitutions.
6. Use reusable inline-value Views when a localized sentence embeds the Riyal
   symbol or another styled value.
7. Add tests for computed keys, plurals, formatting, and user-visible errors.

Never hardcode user-facing copy in Swift, build sentences by concatenating
fragments, use localized text as a database identifier, or translate brand
names, currency codes, email addresses, and other protocol values.

## Arabic and RTL quality

- Inspect the actual screen in RTL; string review alone is insufficient.
- Prefer semantic leading/trailing alignment over left/right assumptions.
- Isolate LTR protocol values only where needed, without reversing the screen.
- Check mixed Arabic, numbers, currency symbols, punctuation, and placeholders.
- Keep financial language direct, calm, specific, and free of shame or hype.
- Verify truncation at large Dynamic Type sizes and meaningful VoiceOver order.

## Validation

```sh
plutil -lint Localization/ar.lproj/*.strings
plutil -lint Localization/en.lproj/*.strings
xcodebuild -project Seuly.xcodeproj -scheme Seuly \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' test
```

Substitute any installed iPhone simulator when that model is unavailable.

The localization tests enforce Arabic/English key parity, placeholder parity,
non-empty production values, required computed keys, and Arabic as the default.
Also test representative screens manually in both directions and appearances.

## Adding a language

Add the language to `AppLanguage`, create all 13 matching tables, add it to
`CFBundleLocalizations`, include every file in the Xcode variant group, and add
parity tests. A translation is not complete until copy, formats, direction,
accessibility, screenshots, and error states have been reviewed by a fluent
speaker.
