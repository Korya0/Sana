# CLAUDE.md

<!--
This file loads into context on EVERY message in this project.
Apply the Golden Test before adding any rule:
"Would removing this cause Claude to make mistakes?" If not — cut it.
These are GENERAL rules reusable across all Flutter projects with the same stack.
Project-specific context lives in PROJECT_CONTEXT.md.
-->

---

# Section A — General Engineering Rules

## 1) Architecture & Separation of Concerns (YOU MUST FOLLOW)
- Follow the project's architecture layer boundaries strictly: presentation → domain → data
- Never bypass layers or mix responsibilities
- **Single Responsibility Principle (SRP)**: Every widget, file, or class MUST have only one clearly defined responsibility. If a component grows too large or handles multiple concerns, refactor and split it.
- UI/presentation layer has ZERO business logic — only rendering, interaction, and state observation
- Business logic lives in the domain layer
- Data access (APIs, databases, storage) lives in the data layer
- Do not introduce new abstractions or patterns without justification

## 2) Shared Code (IMPORTANT)
- Any reusable logic, utility, constant, extension, or helper used in 2+ places goes in `core/`
- Check `core/` before creating new shared code — never duplicate across features
- No cross-feature imports — features are isolated vertical slices

## 3) Error Handling
- Errors flow cleanly across layers — never skip layers
- Handle null, empty, loading, and error states explicitly — no silent failures
- Catch errors at the boundary (data layer), not deep inside business logic
- Use the project's centralized error handler for all Dio/network errors

## 4) Change Discipline
- Make the smallest change that solves the problem
- Fix root causes, not symptoms
- Don't refactor unrelated code unless explicitly requested
- Never break existing functionality, APIs, flows, or UX unless explicitly instructed
- Read relevant code before modifying it — state assumptions when unclear

## 5) Dependencies
- Don't add new packages without justification and asking the user first
- Any new package must be: latest stable, well-maintained, production-grade

## 6) Security
- Never hardcode secrets, tokens, or credentials
- Never log sensitive information
- Validate all external and API input
- Proactively flag security risks when spotted

## 7) Testing
- Write tests for domain and data layer logic
- Bug fixes must include a reproducing test
- Tests must be deterministic — no flaky or timing-dependent tests
- One behavior per test case

## 8) Workflow (Mandatory)
- Before marking any task done → run the `/code-review` skill
- After task approved → run the `/create-pr` skill for branch, commit, and PR output
- PR descriptions must always be in markdown (`.md`) format

---

# Section B — Reusability (إعادة الاستخدام)

## 1) UI & Design System
- All icons MUST use colors defined in the centralized color constants (icons section).
- If a unique icon color is needed, the developer must request permission to add it before implementation.
- All text styles must use centralized text style constants. Inline `TextStyle` definitions or ad-hoc overrides of `fontWeight`, `fontSize`, `color`, or `fontFamily` are strictly forbidden. Other properties (e.g., `height`, `letterSpacing`) may be modified via `.copyWith` when necessary. If a core style is missing, it MUST be created in the centralized styles first.
- **Common Decorations**: Reuse shared decoration widgets for cards, dividers, and highlighted containers. Never create ad-hoc decorations.
- **UI State Management**:
  - Each state (Loading, Success, Error) MUST be isolated into its own dedicated widget, preferably in a separate file within the feature's `widgets` folder.
  - **Loading States**: Use `Skeletonizer` to create skeleton loaders that mirror the actual Success UI.
  - **Error States**: Use centralized error views for full-screen errors, or toast/empty widgets for minor failures.

## 2) Text & String Management
- All user-facing Arabic text MUST be centralized in a single strings constant. No inline Arabic strings allowed.
- **Naming Rule**: String variable names must be descriptive, unique, and match the feature or context.
- **No Aliases**: Avoid redirection/aliases (e.g., `static const String a = b;`). If a string needs to be renamed or consolidated, update all call sites instead.
- **Refactoring**: When merging redundant strings, choose the most descriptive name and perform a global replacement.

---

# Section C — Flutter / Dart Specific Rules

## 1) State Management
- Use **Cubit/Bloc** for feature and application state — not Riverpod, Provider, or GetX
- Cubits depend ONLY on use cases — never directly on repositories or data sources
- `setState` is allowed ONLY for local UI state (e.g., toggles, form focus) — never for business logic
- Keep `setState` scoped to the smallest widget possible to avoid redundant rebuilds up the tree

## 2) No Code Generation
- **No Freezed. No build_runner.** Use Dart 3+ native features instead:
  - `sealed class` for state unions with exhaustive pattern matching
  - `switch` expressions and records for lightweight data
- *Note: Existing files using Freezed should be maintained but new files MUST use native features.*

## 3) Domain Layer Purity
- Domain layer must have ZERO Flutter imports
- No `package:flutter/...` in any file under `domain/`

## 4) Feature Folder Structure
- `features/{feature_name}/data/`
- `features/{feature_name}/domain/`
- `features/{feature_name}/presentation/`

## 5) Error Handling Contract
- Data layer: catch exceptions and map to typed `Failure` classes via centralized error handler
- Domain layer: return `ApiResult<T>` from use cases and repositories
- Presentation layer: map failures to user-friendly messages and UI states

## 6) Dependency Injection
- Use **`get_it`** as the service locator — not `Provider` or constructor-only injection
- Register dependencies in a single `core/di/` setup file (or feature-specific `init` methods)
- Cubits, use cases, and repositories are resolved via `get_it`, not instantiated manually

## 7) Build Method Discipline (IMPORTANT)
- Prefer `const` constructors wherever possible
- NEVER create `TextEditingController`, `AnimationController`, `FocusNode`, or other expensive objects inside `build()`
- Avoid heavy work inside `build()` methods
- Dispose controllers and focus nodes in `StatefulWidget.dispose()`
- Prefer small, composed widgets to minimize rebuild scope
- Use `BlocBuilder`/`BlocSelector` on the smallest widget that needs the state — never at the top of the tree

## 8) Performance & Hygiene (Rules)
- Use `const` for static widgets, `dispose()` for all controllers/streams, and `RepaintBoundary` for animations.

## 9) Data Transformation & Layer Purity
- Move all data transformation or parsing logic (e.g. string formatting, Regex parsing) from the UI layer to the **Data Layer (Models)**.
- Presentation widgets should be as simple and **Stateless** as possible, receiving "ready-to-render" data from models.

## 10) Strict Responsive Sizing & Typography (MANDATORY)
- **Centralized Responsiveness**: Do NOT use `.r(context)` in the UI for spacing or text styles. Their responsiveness must be handled internally within their central files.
- **Explicit UI Scaling**: Use `.r(context)` in the UI only for other dimensions (e.g., icons, custom container sizes, image heights).
- **Column/Row Spacing**: NEVER use hardcoded double values for the `spacing` property in `Column` or `Row`. Always use spacing tokens.
- **Typography Purity**: NEVER create custom `TextStyle` objects. Use centralized text styles exclusively.
- **`copyWith` Restriction**: NEVER use `.copyWith` to modify `fontSize`, `fontWeight`, `color`, or `fontFamily`. Use it ONLY for secondary properties (e.g., `height` for line spacing).

---  

# Section D — Naming Conventions

## Files & Directories
| Element | Convention | Example |
|---|---|---|
| Dart files | `snake_case.dart` | `prayer_times_cubit.dart` |
| Feature folders | `snake_case` | `hadith_search/`, `salat_ala_Nabi/` |
| Data layer folders | `datasources/`, `models/`, `repos/`, `services/`, `constants/` | — |
| Domain layer folders | `entities/`, `repositories/`, `use_cases/` | — |
| Presentation folders | `cubit/`, `views/`, `widgets/`, `routes/` | — |
| Generated files | `*.g.dart`, `*.freezed.dart` | — |
| Assets | `snake_case` in categorized folders | `assets/images/`, `assets/svgs/` |

## Classes
| Element | Convention | Example |
|---|---|---|
| Widgets / Views | `PascalCase` + `View` / `Widget` suffix | `PrayerTimesView` |
| Cubits | `PascalCase` + `Cubit` suffix | `HadithCubit` |
| States | `PascalCase` + `State` suffix | `HadithState` |
| State variants | `Feature` + `Initial/Loading/Success/Error` | `HadithInitial`, `HadithLoading` |
| Entities | `PascalCase` + `Entity` suffix | `HadithEntity` |
| Models (data) | `PascalCase` + `Model` suffix | `HadithModel` |
| Repos (abstract) | `I` prefix + `PascalCase` + `Repository` | `IHadithRepository` |
| Repos (concrete) | `PascalCase` + `Impl` suffix | `HadithRepoImpl` |
| Data sources (abstract) | `I` prefix + `PascalCase` + `DataSource` | `IHadithRemoteDataSource` |
| Data sources (concrete) | `PascalCase` + `DataSource` | `HadithRemoteDataSource` |
| Use cases | `PascalCase` + `UseCase` suffix | `SearchHadithUseCase` |
| Services (abstract) | `I` prefix + `PascalCase` + `Service` | `IAnalyticsService` |
| Services (concrete) | `PascalCase` + `Impl` suffix | `FirebaseAnalyticsServiceImpl` |
| DI modules | `PascalCase` + `DependencyInjection` | `HadithSearchDependencyInjection` |
| Constants classes | `App` prefix + `PascalCase` | `AppColors`, `AppSpacing` |
| Route classes | `PascalCase` + `Routes` suffix | `HomeRoutes` |
| API clients | `PascalCase` + `ApiClient` suffix | `DorarApiClient` |
| Interceptors | `PascalCase` + `Interceptor` suffix | `CorsInterceptor` |

## Variables & Constants
| Element | Convention | Example |
|---|---|---|
| Private fields | `_camelCase` | `_repository`, `_box` |
| Static constants | `camelCase` | `AppColors.scaffoldBackground` |
| Route paths | `kebab-case` strings | `'/hadith-view'` |
| Storage keys | `snake_case` strings | `'hijri_adjustment'` |
| Enum values | `camelCase` | — |

## Constructor Pattern
- Use private constructor `ClassName._()` for classes with only static members (prevents instantiation)

---

# Section E — Error Handling (Deep Dive)

## Error Flow Diagram

```
Network/API Error
    ↓
[Data Layer] DioException caught → centralized error handler → typed Failure
    ↓
[Repository] wraps in ApiResult.failure(failure)
    ↓
[Use Case] passes through ApiResult<T> unchanged
    ↓
[Cubit] pattern-matches on ApiResult → emits UI state
    ↓
[Widget] renders error view with user-friendly message from centralized strings
```

## Failure Hierarchy (sealed class)
```
Failure (sealed)
├── ServerFailure       → API returned non-success status code
├── NetworkFailure      → No internet / timeout / connection error
├── CacheFailure        → Local storage read/write failure
├── LocationFailure     → GPS / geocoding failure
├── SensorFailure       → Compass / sensor unavailable
├── WrongPasswordFailure → Authentication error
├── MissingDataFailure  → Required data not found
└── UnknownFailure      → Catch-all for unexpected errors
```

## Rules
- Never throw raw exceptions from the data layer — always map to `Failure`
- Never show raw exception messages to the user — map via centralized strings
- Every `ApiResult.failure` must carry a `Failure` with a user-friendly `message`
- Use the centralized logger for all error logging (routes to console in debug, Crashlytics in release)
- Catch at the outermost boundary only — don't swallow errors in nested functions
- Always handle all 4 UI states in presentation: `initial`, `loading`, `success`, `error`

---

# Section F — Do's and Don'ts

## ✅ DO

- **DO** follow the existing architecture — don't invent new patterns
- **DO** check `core/` before writing any shared utility, extension, or widget
- **DO** use centralized design tokens for all styling — no hardcoded colors, spacing, or font sizes
- **DO** use centralized strings for all Arabic user-facing text — no inline strings
- **DO** use type-safe asset references from code generation (`flutter_gen`)
- **DO** use `sl<Type>()` from GetIt for dependency resolution
- **DO** use `const` constructors wherever possible
- **DO** dispose all controllers, streams, and subscriptions in `dispose()`
- **DO** use the centralized logger — never use `print()` or `debugPrint()`
- **DO** return `ApiResult<T>` from repositories and use cases
- **DO** handle RTL layout globally via localization — don't add manual RTL overrides
- **DO** test on both mobile and web when making UI changes
- **DO** use `unawaited()` for intentionally fire-and-forget futures
- **DO** use `package:` imports for ALL files within `lib/`. Relative imports are strictly forbidden.
- **DO** avoid unnecessary type annotations on local variables. Use `final` or `var` for inference.
- **DO** prefix abstract interfaces with `I` (e.g., `IHadithRepository`).
- **DO** follow the **Single Responsibility Principle (SRP)** — one class/file/widget per task.

## ❌ DON'T

- **DON'T** add any new package without asking the user first — always justify the need
- **DON'T** write comments in code — the code should be self-documenting; use clear naming instead
- **DON'T** use `print()` or `debugPrint()` — use the centralized logger exclusively
- **DON'T** hardcode colors, spacing, or font sizes — use design tokens from `core/theme/`
- **DON'T** hardcode Arabic strings — add them to centralized strings
- **DON'T** import from one feature into another — features are isolated
- **DON'T** put business logic in widgets or `build()` methods
- **DON'T** create `TextEditingController` / `FocusNode` / `AnimationController` inside `build()`
- **DON'T** use `Provider`, `Riverpod`, `GetX`, or any state management other than Cubit/Bloc
- **DON'T** use `setState` for anything beyond trivial local UI toggles
- **DON'T** bypass the `Failure` → `ApiResult` error handling chain
- **DON'T** throw raw exceptions from repositories or data sources
- **DON'T** swallow errors silently — always log and surface to the user
- **DON'T** add Flutter imports to the domain layer
- **DON'T** use magic numbers — extract to named constants
- **DON'T** duplicate code — if you need it twice, move it to `core/`
- **DON'T** modify generated files (`*.g.dart`, `*.freezed.dart`, `assets.gen.dart`) manually
- **DON'T** skip the DI system — never `new` up a Cubit, repo, or service manually
- **DON'T** refactor unrelated code while fixing a bug or adding a feature
- **DON'T** log sensitive user data (location coordinates, device IDs in production)

---

# Section G — Self-Improvement (Meta-Rule)

When you notice any of the following patterns during a conversation, **proactively suggest** adding or updating a rule in the appropriate file:

| Pattern | Action |
|---|---|
| User repeatedly corrects the same mistake | Suggest a new rule to prevent it |
| User asks for the same thing 2+ times across chats | Suggest codifying it as a standard rule |
| A new convention or decision is agreed upon | Suggest adding it to the relevant section |
| An existing rule is outdated or wrong | Suggest updating or removing it |
| A recurring code pattern emerges | Suggest documenting it as a standard pattern |

**How to suggest:**
- State clearly: *"I noticed you've asked for [X] multiple times. Would you like me to add this as a rule?"*
- Specify **which file** (`CLAUDE.md` for general rules, `PROJECT_CONTEXT.md` for project-specific)
- Specify **which section** it belongs to (e.g., Section B — Reusability, Section D — Do's/Don'ts)
- Never modify these files without explicit user approval

---

# 📎 Project-Specific Context

This project has a companion file **`PROJECT_CONTEXT.md`** at the project root.
It contains the following project-specific sections:

- **Section A — Project Identity & Infrastructure**: App name, locale, fonts, platforms, infrastructure table, bootstrap order, DI registration order
- **Section B — Architecture Documentation**: Complete folder structure, assets structure, feature architectural tiers, design patterns catalog with code examples, data flow diagrams, layer dependency matrix
- **Section C — Project-Specific UI Rules**: Concrete file paths for decorations, design tokens, text styles, and helper utilities used in this project
- **Section D — Project-Specific Do's/Don'ts**: Rules referencing specific project files, tools, and utilities

> When working on this project, always read both `CLAUDE.md` and `PROJECT_CONTEXT.md`.
