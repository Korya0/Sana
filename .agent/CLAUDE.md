# CLAUDE.md — دليل القواعد العامة والمشتركة (Shared & Common Guide)

<!--
هذا هو الملف الرئيسي للقواعد البرمجية ويتم تحميله تلقائياً في سياق كل محادثة.
يعمل هذا الملف كدليل عام وبوابة توجيه سياقية (Context Router) للأدلة الفرعية المتخصصة.
-->

---

# 🗺️ بوابة التوجيه السياقي (Context Router - MANDATORY)

أيها المساعد الذكي، قبل البدء في كتابة أو تعديل أي كود برمي، يجب عليك تحديد طبيعة العمل وقراءة الدليل الفرعي المخصص باستخدام أداة القراءة المتاحة:

* 🎨 **إذا كنت تعمل على شاشات، خطوط، ألوان، تفاعلات، تجاوب، نصوص عربية، أو أي تعديل جمالي ومرئي**:
  > **يجب عليك فوراً قراءة الدليل المتخصص**: [CLAUDE_UI.md](file:///d:/flutter/flutter_Projects/muslim_app/.agent/CLAUDE_UI.md)
  
* 🗄️ **إذا كنت تعمل على منطق الأعمال، قواعد البيانات، الكيوبيتس، طبقة الدومين، الـ APIs، حقن الاعتماديات، معالجة الأخطاء، أو الـ models**:
  > **يجب عليك فوراً قراءة الدليل المتخصص**: [CLAUDE_DATA.md](file:///d:/flutter/flutter_Projects/muslim_app/.agent/CLAUDE_DATA.md)

* ⚙️ **عند طلب بناء ميزة جديدة، حل مشكلة برمجية، أو الإبلاغ عن خطأ (Bug) أو تعديل كبير**:
  > **يجب عليك فوراً قراءة واتباع مراحل دليل إدارة المهام بدقة**: [CLAUDE_PROCESS.md](file:///d:/flutter/flutter_Projects/muslim_app/.agent/CLAUDE_PROCESS.md)

---

# Section A — General Engineering Rules

## 1) Architecture & Separation of Concerns (YOU MUST FOLLOW)
- Follow the project's architecture layer boundaries strictly: presentation → domain → data.
- Never bypass layers or mix responsibilities.
- **Single Responsibility Principle (SRP)**: Every widget, file, or class MUST have only one clearly defined responsibility. If a component grows too large or handles multiple concerns, refactor and split it.
- UI/presentation layer has ZERO business logic — only rendering, interaction, and state observation.
- Business logic lives in the domain layer.
- Data access (APIs, databases, storage) lives in the data layer.
- Do not introduce new abstractions or patterns without justification.

## 2) Shared Code (IMPORTANT)
- Any reusable logic, utility, constant, extension, or helper used in 2+ places goes in `core/`.
- Check `core/` before creating new shared code — never duplicate across features.
- No cross-feature imports — features are isolated vertical slices.

## 3) Change Discipline
- Make the smallest change that solves the problem.
- Fix root causes, not symptoms.
- Don't refactor unrelated code unless explicitly requested.
- Never break existing functionality, APIs, flows, or UX unless explicitly instructed.
- Read relevant code before modifying it — state assumptions when unclear.

## 4) Dependencies
- Don't add new packages without justification and asking the user first.
- Any new package must be: latest stable, well-maintained, production-grade.

## 5) Security
- Never hardcode secrets, tokens, or credentials.
- Never log sensitive information.
- Validate all external and API input.
- Proactively flag security risks when spotted.

## 6) Testing
- Write tests for domain and data layer logic.
- Bug fixes must include a reproducing test.
- Tests must be deterministic — no flaky or timing-dependent tests.
- One behavior per test case.

## 7) Error Handling (Rule: Log Once at the Source)
- **Data Layer (Repository/DataSource)**: Catch exceptions and call `AppLogger.error()` **once** at the source. Return `Result.failure(Failure)`.
- **Logic Layer (Cubit/UseCases)**: Handle `Result.failure` quietly by updating state (e.g. `ErrorState`). **DO NOT** log the error again.
- **UI Layer (Widgets)**: Show the error message (Toast/Dialog). Use only `AppLogger.localError()` — no `AppLogger.error()` or `reportToFirebase()`.
- Always use `unawaited(AppLogger.error(...))` not `await` to avoid blocking the response.
- Use `on Object catch` (not `on Exception catch`) to catch all error types including programming errors.
- Don't pass `report: true` manually — `AppLogger.error()` has built-in `_checkIfFirebaseWorthy()` logic.

### Logging Level Quick Reference
| Method | Layer | Firebase? |
|--------|-------|-----------|
| `info()` / `debug()` | Any (debug mode) | ❌ No |
| `warn()` | Data layer only | ❌ No (expected/transient) |
| `localError()` | UI/Cubit | ❌ No |
| `error()` | Repository only | 🤖 Auto-decides |
| `reportToFirebase()` | Critical startup/services | ✅ Always |

---

# Section B — Naming Conventions

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

### Feature Folder Structure (Standard 3-Layer)
For features utilizing Tier 1 (Clean Architecture), organize folders as follows:
- `features/{feature_name}/data/`
- `features/{feature_name}/domain/`
- `features/{feature_name}/presentation/`

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
| Constants classes | `App` prefix + `PascalCase` | `MyColors` (ThemeExtension), `AppSpacing` |
| Route classes | `PascalCase` + `Routes` suffix | `HomeRoutes` |
| API clients | `PascalCase` + `ApiClient` suffix | `DorarApiClient` |
| Interceptors | `PascalCase` + `Interceptor` suffix | `CorsInterceptor` |

## Variables & Constants
| Element | Convention | Example |
|---|---|---|
| Private fields | `_camelCase` | `_repository`, `_box` |
| Static constants | `camelCase` | `AppSpacing.md` |
| Route paths | `kebab-case` strings | `'/hadith-view'` |
| Storage keys | `snake_case` strings | `'hijri_adjustment'` |
| Enum values | `camelCase` | — |

## Constructor Pattern
- Use private constructor `ClassName._()` for classes with only static members (prevents instantiation).

---

# Section C — Team Workflow

## Mandatory Workflow Steps
- Before marking any task done → run the `/code-review` skill.
- After task approved → run the `/create-pr` skill for branch, commit, and PR output.
- PR descriptions must always be in markdown (`.md`) format.

---

# Section D — Self-Improvement (Meta-Rule)

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
- Specify **which file** (`CLAUDE.md` for general rules, `PROJECT_CONTEXT.md` for project-specific, or the UI/DATA sub-guides).
- Specify **which section** it belongs to.
- Never modify these files without explicit user approval.

---

# Section E — General Do's and Don'ts

## ✅ DO
- **DO** follow the existing architecture — don't invent new patterns.
- **DO** use `package:` imports for ALL files within `lib/`. Relative imports are strictly forbidden.
- **DO** avoid unnecessary type annotations on local variables. Use `final` or `var` for inference.
- **DO** follow the **Single Responsibility Principle (SRP)** — one class/file/widget per task.
- **DO** test on both mobile and web when making changes.

## ❌ DON'T
- **DON'T** add any new package without asking the user first — always justify the need.
- **DON'T** write comments in code — the code should be self-documenting; use clear naming instead.
- **DON'T** duplicate code — if you need it twice, move it to `core/`.
- **DON'T** refactor unrelated code while fixing a bug or adding a feature.
- **DON'T** log sensitive user data in production.

---

# 📎 Project-Specific Context

This project has a companion file **`PROJECT_CONTEXT.md`** at the project root.
It contains the following project-specific sections:

- **Section A — Project Identity & Infrastructure**: App name, locale, fonts, platforms, infrastructure table, bootstrap order, DI registration order
- **Section B — Architecture Documentation**: Complete folder structure, assets structure, feature architectural tiers, design patterns catalog with code examples, data flow diagrams, layer dependency matrix
- **Section C — Project-Specific UI Rules**: Concrete file paths for decorations, design tokens, text styles, and helper utilities used in this project
- **Section D — Project-Specific Do's/Don'ts**: Rules referencing specific project files, tools, and utilities

> When working on this project, always read `CLAUDE.md` and check `CLAUDE_UI.md` / `CLAUDE_DATA.md` / `CLAUDE_PROCESS.md` as directed.
