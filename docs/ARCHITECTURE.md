# Architecture

Seuly uses Model–View–ViewModel exclusively. The rule is dependency direction,
not folder naming:

```text
SwiftUI View → ViewModel → Model → Supabase Auth/Postgres
                         ↘ domain calculations
```

## Responsibilities

### Model

`Seuly/Models` contains domain entities, calculations, Supabase DTOs and
payloads, error translation, configuration, `AuthModel`, and `FinanceModel`.
Models own all remote reads and mutations. `PreferencesModel` owns the small
device-local preferences stored in `UserDefaults`.

`FinanceWorkspace` is the authenticated in-memory domain snapshot. Analytics
are deterministic projections of it. Money remains signed `Int64` minor units
through storage, mapping, calculations, and formatting.

### ViewModel

`Seuly/ViewModels` contains `@MainActor` observable presentation state. A
ViewModel validates user input, maps domain values for display, coordinates
Model calls, and exposes navigation intent. It does not access Supabase,
construct SQL, or become a second domain layer.

`AppViewModel` is the composition root. It loads configuration, constructs one
Supabase client, injects Models into child ViewModels, and derives the root
route from authentication and workspace state.

### View

`Seuly/Views` contains SwiftUI rendering. A screen observes a ViewModel, renders
its state, and forwards user intent. Leaf Views may receive immutable domain or
presentation values. Every View file contains exactly one `View` struct.

`Seuly/ViewSupport` contains reusable visual implementation: theme, layout,
typography, color, motion, field modifiers, and button styles. It is not an
application architecture layer and contains no business or network behavior.

## Async data flow

1. A View starts a structured `Task` for user intent or lifecycle work.
2. Its ViewModel awaits a Model operation.
3. The Model validates session/request context and awaits Supabase.
4. DTOs are mapped into domain values; stale or cancelled results are rejected.
5. The Model updates observable state on the main actor.
6. The View re-renders from the ViewModel's derived presentation state.

Mutations use stable UUID request identifiers. After success, only affected
workspace slices are refreshed. User transitions clear prior presentation and
finance state to prevent cross-session leakage.

## Navigation and state

`AppViewModel.Route` is derived state: configuration, launch, authentication,
workspace load, onboarding, password recovery, main app, or unavailable. Child
navigation uses small route enums and sheet selections owned by ViewModels;
there is no coordinator object.

## Non-negotiable boundaries

- No repository, service, use-case, coordinator, Redux, or VIPER layer
- No database or authentication calls from Views or ViewModels
- No production mock/fallback finance data
- No floating-point representation for stored or calculated money
- No global mutable session or finance state
- No authored Swift file over 100 physical lines

Extensions split a single type by cohesive responsibility without duplicating
state. New behavior should extend the closest existing Model or ViewModel and
reuse shared Views and formatters before introducing another type.
