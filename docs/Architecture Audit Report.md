# Architecture Audit Report

**Project:** Sana (Muslim App)  
**Date:** July 25, 2026  
**Auditor:** Flutter Architecture Review  
**Pattern:** Feature-First Clean Architecture + BLoC/Cubit State Management

---

## Overall Score: **7.5 / 10**

### Score Breakdown
| Dimension | Score | Rationale |
|---|---|---|
| Consistency | 7/10 | Good overall but inconsistencies in naming (`repos`/`repositories`) and barrel file coverage |
| Layer Compliance | 6/10 | Several violations of Clean Architecture dependency rules (presentation→data, domain→other data) |
| Test Coverage | 8/10 | Excellent azkar test suite, but no tests for any other feature |
| Naming & Organization | 7/10 | Generally consistent but folder naming and interface placement issues |
| Reusability | 8/10 | Strong core layer with good widget/services abstractions |
| Maintainability | 8/10 | Feature isolation is good; DI separation is well done |

### Summary

The project demonstrates a well-structured Feature-First Clean Architecture with consistent patterns across most features. The codebase shows mature engineering practices: proper separation of concerns, abstract interface patterns, use of sealed classes for state management, Result type for error handling, and dependency injection via GetIt. The `azkar` feature serves as the gold standard with full Clean Architecture layers, use cases, validators, and comprehensive test coverage.

However, several architectural violations and inconsistencies were identified that reduce maintainability and violate Clean Architecture dependency rules. These include domain entities depending on Flutter, presentation layers bypassing domain to access data directly, cross-feature dependencies from domain to data layers, and core infrastructure depending on feature modules.

### Strengths

1. **Consistent feature folder structure** — All features use the same `data/`, `domain/`, `presentation/`, `di/` layout
2. **Excellent use of sealed classes** — State management uses sealed classes/pattern matching throughout
3. **Result type pattern** — `Result<T>` with `Success` and `FailureResult` variants is used consistently
4. **Abstract interface pattern** — Data sources and repositories use abstract interfaces with clear contracts
5. **DI separation** — Each feature has its own `di/` module, registered centrally in `features_di.dart`
6. **Single-responsibility use cases** — In the `azkar` feature, use cases are granular and focused
7. **Comprehensive tests** — The `azkar` feature has thorough unit, widget, and integration tests
8. **Good separation of calculators** — Pure calculation logic separated into `calculators/` in the prayer feature
9. **Re-export barrel pattern minimized** — Only key features use barrel files

### Weaknesses

1. **Domain entities depend on Flutter** — Several domain entities import `package:flutter/foundation.dart` (violates Clean Architecture)
2. **Presentation bypassing domain** — Cubits in some features directly import data layer services instead of domain contracts
3. **Core depends on features** — Core infrastructure (bootstrap, common widgets) imports feature modules, violating the inward dependency rule
4. **Cross-feature data dependencies from domain** — Domain use cases import data models from other features
5. **Repository interface placement inconsistencies** — Some features define repository interfaces in the data layer instead of domain
6. **Unnecessary abstractions** — The `prayer/data/services/prayer_state_service.dart` is a pure re-export with no added value
7. **Missing barrel files** — Some features lack barrel (`.feature_name.dart`) export files
8. **Naming inconsistencies** — `repos/` vs `repositories/` folder naming across features

---

# Global Observations

### Architectural Style

The project follows a **Feature-First Clean Architecture** with three main layers:

```
Presentation (Cubits/Pages/Widgets)
    ↓ depends on
Domain (Entities/Use Cases/Repository Interfaces) — [OPTIONAL]
    ↓ contracts implemented by
Data (Repository Impls/Data Sources/Models)
```

Core shared code lives in `lib/core/` and provides infrastructure, reusable widgets, services, theme, and utilities.

### Domain Layer Evaluation

Per the project's guidance, the Domain layer is **optional** and should only exist when there is actual business logic that justifies it. Here is the evaluation per feature:

| Feature | Domain Exists | Domain Justified | Notes |
|---|---|---|---|
| azkar | ✅ Full | ✅ Yes | Use cases, entities, validators, params — all well justified |
| prayer | ✅ Full | ✅ Yes | Calculation services, use cases for religious events |
| qibla | ✅ Full | ✅ Yes | Pure math calculation service, use cases |
| teaching_prayer | ✅ Yes | ✅ Yes | Business logic for parsing teaching content |
| salat_ala_nabi | ✅ Yes | ✅ Yes | Working hours use cases, reminder scheduling |
| asma_ul_husna | ⚠️ Partial | ❌ Unnecessary | Has `domain/entities/` but repository interface is in data layer |
| developer_dashboard | ⚠️ Partial | ❌ Unnecessary | Has `domain/entities/` with single entity, no use cases |
| feedback | ✅ Yes | ⚠️ Borderline | Has domain repository contract but it could be simpler |
| daily_content | ❌ Missing | ⚠️ Borderline | Has complex business logic (shuffle, favorites, daily advancement) that could benefit from domain |
| app_date | ❌ Missing | ✅ Acceptable | Simple date display — domain unnecessary |
| app_update | ❌ Missing | ✅ Acceptable | Simple update check — domain unnecessary |
| home | ❌ Missing | ✅ Acceptable | Simple feature list — domain unnecessary |
| settings | ❌ Missing | ✅ Acceptable | Simple settings — domain unnecessary |
| quran | ❌ Missing | ✅ Acceptable | Minimal feature — domain unnecessary |
| location_manager | ❌ Missing | ✅ Acceptable | Mostly SDK orchestration — domain unnecessary |
| main_layout | ❌ Missing | ✅ Acceptable | Shell/navigation only |
| splash | ❌ Missing | ✅ Acceptable | Simple splash screen |
| sharing | ❌ Missing | ✅ Acceptable | Helper widgets, logic in core |

---

# Violations

## Severity Legend
- **CRITICAL** — Breaks architecture fundamentals, hard to test/maintain
- **HIGH** — Significant violation of layer rules
- **MEDIUM** — Violates best practices but manageable
- **LOW** — Minor inconsistency, cosmetic

---

### VIOLATION-001: Domain Entity Depends on Flutter

| Field | Value |
|---|---|
| **Feature** | Multiple |
| **Layer** | Domain |
| **Files** | `prayer/domain/entities/prayer_state_result.dart`, `prayer/domain/entities/prayer_times_entity.dart`, `prayer/domain/entities/sunnah_entity.dart`, `prayer/domain/entities/prayer_time_status.dart`, `prayer/domain/entities/religious_event_entity.dart`, `prayer/domain/entities/user_prayer_times_settings_entity.dart`, `prayer/domain/entities/sunnah_times_entity.dart`, `azkar/domain/entities/reminder_entity.dart`, `azkar/domain/entities/reading_settings.dart`, `azkar/domain/params/create_reminder_params.dart`, `azkar/domain/params/update_reminder_params.dart`, `qibla/domain/entities/qibla_entities.dart`, `teaching_prayer/domain/entities/teaching_prayer_entity.dart`, `salat_ala_nabi/domain/entities/reminder_settings_entity.dart`, `developer_dashboard/domain/entities/feedback_entity.dart` |
| **Severity** | MEDIUM |
| **Current Location** | `{feature}/domain/entities/*.dart` |
| **Recommended Location** | Keep in domain but replace `package:flutter/foundation.dart` with pure Dart equivalents |
| **Reason** | Clean Architecture dictates that domain layer must be pure Dart with zero Flutter dependencies. `@immutable`, `listEquals`, and `DeepCollectionEquality` are Flutter-isms that couple domain to the framework. |
| **Suggested Fix** | Remove `import 'package:flutter/foundation.dart'`. Use `@immutable` from `package:meta/meta.dart` instead. Replace `listEquals` with manual `ListEquality` from `collection` package or implement custom equality. Replace `DeepCollectionEquality` similarly. |

---

### VIOLATION-002: Presentation Layer Imports Data Layer Directly

| Field | Value |
|---|---|
| **Feature** | prayer |
| **Layer** | Presentation → Data |
| **File** | `lib/features/prayer/presentation/cubits/prayer_times_cubit.dart` |
| **Severity** | HIGH |
| **Current Location** | `prayer/presentation/cubits/prayer_times_cubit.dart` |
| **Recommended Location** | Should depend on domain repository interface and domain services only |
| **Reason** | Lines 8-11 import `data/services/prayer_status_service.dart`, `data/services/prayer_times_service.dart`, `data/services/religious_events_service.dart`, `data/services/user_settings_service.dart` directly from the data layer. This bypasses the domain layer entirely, breaking the dependency rule (`Presentation → Domain ← Data`). |
| **Suggested Fix** | Either: (a) Move service interfaces to domain layer (they are already partially there for `PrayerStateService`), or (b) Have the cubit depend only on domain repository interfaces and domain service interfaces, with implementations injected via DI. |

---

### VIOLATION-003: Presentation Layer Imports Data Directly (Missing Domain Interface)

| Field | Value |
|---|---|
| **Feature** | asma_ul_husna |
| **Layer** | Presentation → Data |
| **File** | `lib/features/asma_ul_husna/presentation/cubits/asma_ul_husna_cubit.dart` |
| **Severity** | HIGH |
| **Current Location** | `asma_ul_husna/presentation/cubits/asma_ul_husna_cubit.dart` |
| **Recommended Location** | Inject via domain repository interface |
| **Reason** | Line 5: `import 'package:sana/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart'` — imports from data layer. The repository interface (`AsmaUlHusnaRepository`) is defined in `data/repos/` instead of `domain/repos/`, forcing the presentation layer to depend on data. |
| **Suggested Fix** | Move the `abstract interface class AsmaUlHusnaRepository` from `data/repos/` to `domain/repos/`. Update the cubit import to use the domain location. The repo impl stays in data. |

---

### VIOLATION-004: Core Depends on Feature (Outward Dependency)

| Field | Value |
|---|---|
| **Feature** | core/common |
| **Layer** | Core → Feature |
| **File** | `lib/core/common/cards/daily_content_base_card.dart` |
| **Severity** | HIGH |
| **Current Location** | `core/common/cards/daily_content_base_card.dart` |
| **Recommended Location** | Move `CombinedShareCopyButton` to core, or invert the dependency |
| **Reason** | Line 8: `import 'package:sana/features/sharing/presentation/combined_share_copy_button.dart'` — core/common widgets should NOT depend on feature modules. This creates a tight coupling and breaks the principle that core is a shared library used by features. |
| **Suggested Fix** | Move `CombinedShareCopyButton` from `features/sharing/presentation/` to `core/common/buttons/` since it's a reusable UI component. The same applies to `custom_rich_content_dialog.dart` which also imports it. |

---

### VIOLATION-005: Core Bootstrap Depends on Feature

| Field | Value |
|---|---|
| **Feature** | core/bootstrap |
| **Layer** | Core → Feature |
| **File** | `lib/core/bootstrap/lifecycle_manager.dart` |
| **Severity** | HIGH |
| **Current Location** | `core/bootstrap/lifecycle_manager.dart` |
| **Recommended Location** | Inject the dependency or create a core notification reminder abstraction |
| **Reason** | Line 5: `import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart'` — core bootstrap logic imports from a feature's domain layer. The lifecycle manager should not know about specific features. |
| **Suggested Fix** | Abstract the reminder rescheduling concern behind a core interface (e.g., `ReminderRescheduler`), implement it in the azkar feature, and inject it. The lifecycle manager should depend on the abstraction only. |

---

### VIOLATION-006: Domain Use Case Depends on Another Feature's Data Model

| Field | Value |
|---|---|
| **Feature** | prayer → app_date |
| **Layer** | Domain (prayer) → Data (app_date) |
| **Files** | `prayer/domain/use_cases/religious_event_use_cases.dart`, `prayer/domain/use_cases/calculate_days_between_hijri_dates_use_case.dart` |
| **Severity** | CRITICAL |
| **Current Location** | `prayer/domain/use_cases/*.dart` (line 1 in both files) |
| **Recommended Location** | Move `AppHijriDate` to a shared domain entity location |
| **Reason** | Both use cases import `package:sana/features/app_date/data/models/app_date_model.dart` — this is a double violation: (1) domain depending on data layer, (2) cross-feature dependency from domain. Domain entities should be shared abstractions, not concrete data models. |
| **Suggested Fix** | Extract `AppHijriDate` into a core domain-level entity or a shared feature domain package. Both features should depend on this shared abstraction, not on `app_date/data/models/`. |

---

### VIOLATION-007: Repository Interface Defined in Data Layer

| Field | Value |
|---|---|
| **Feature** | asma_ul_husna |
| **Layer** | Data (misplaced interface) |
| **File** | `lib/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart` |
| **Severity** | MEDIUM |
| **Current Location** | `asma_ul_husna/data/repos/asma_ul_husna_repository.dart` |
| **Recommended Location** | `asma_ul_husna/domain/repos/asma_ul_husna_repository.dart` |
| **Reason** | The abstract interface `AsmaUlHusnaRepository` is defined in the data layer alongside its implementation `AsmaUlHusnaRepoImpl`. Repository contracts should live in the domain layer so presentation depends on domain abstractions, not data concretions. |
| **Suggested Fix** | Move the interface to `domain/repos/`. Keep the implementation in `data/repos/`. |

---

### VIOLATION-008: Unnecessary Data Layer Re-Export

| Field | Value |
|---|---|
| **Feature** | prayer |
| **Layer** | Data (redundant) |
| **File** | `lib/features/prayer/data/services/prayer_state_service.dart` |
| **Severity** | LOW |
| **Current Location** | `prayer/data/services/prayer_state_service.dart` |
| **Recommended Location** | Remove the file (or inline the import path) |
| **Reason** | This file is a single-line re-export: `export 'package:sana/features/prayer/domain/services/prayer_state_service.dart';`. It adds no value — it's pure indirection. Consumers importing from `data/services/` get the domain implementation anyway. This creates confusion about where the actual implementation lives. |
| **Suggested Fix** | Delete this re-export file and update all consumers to import directly from the domain layer. |

---

### VIOLATION-009: Naming Inconsistency — `repos/` vs `repositories/`

| Field | Value |
|---|---|
| **Features** | Multiple |
| **Layer** | Data/Domain |
| **Files** | `asma_ul_husna/data/repos/`, `azkar/data/repositories/`, `teaching_prayer/data/repos/`, `qibla/data/repos/` (with `qibla/domain/repositories/`) |
| **Severity** | LOW |
| **Current Location** | Varies per feature |
| **Recommended Location** | Standardize to one naming convention |
| **Reason** | Some features use `repos/` (asma_ul_husna, teaching_prayer, qibla, daily_content, developer_dashboard, feedback) while others use `repositories/` (azkar). The qibla feature is inconsistent within itself: `domain/repositories/` but `data/repos/`. |
| **Suggested Fix** | Choose one convention (`repositories/` recommended for clarity) and apply across all features. |

---

### VIOLATION-010: Missing Barrel Export Files

| Field | Value |
|---|---|
| **Features** | Some features |
| **Layer** | Feature root |
| **Files** | Missing `{feature_name}.dart` in: `home`, `app_date`, `app_update`, `developer_dashboard`, `feedback`, `location_manager`, `main_layout`, `splash`, `hadith_search` |
| **Severity** | LOW |
| **Current Location** | N/A |
| **Recommended Location** | `lib/features/{feature_name}/{feature_name}.dart` |
| **Reason** | 10 features already have barrel files (`asma_ul_husna.dart`, `daily_content.dart`, `prayer.dart`, `qibla.dart`, `salat_ala_nabi.dart`, `settings.dart`, `teaching_prayer.dart`, `quran.dart`, `splash.dart`, `azkar.dart`). 8 features are missing them. Barrel files improve import ergonomics and provide a clean public API surface. |
| **Suggested Fix** | Add barrel export files for missing features (`home`, `app_date`, `app_update`, `developer_dashboard`, `feedback`, `location_manager`, `main_layout`, `splash`). |

---

> ⚠️ **Note on Domain Absence:** Per project policy, the absence of a Domain layer is **not** considered a violation. The following is a **recommendation only**, not a required fix.

### Suggestion-011: daily_content May Benefit from Domain Layer (Optional)

| Field | Value |
|---|---|
| **Feature** | daily_content |
| **Layer** | Domain (missing) |
| **Files** | No `domain/` folder exists |
| **Severity** | 💡 Recommendation (not a violation) |
| **Current Location** | N/A |
| **Recommended Location** | Optional — no action needed now |
| **Reason** | `daily_content` has moderate business logic (shuffled advancement, daily tracking, favorites). Currently in data services and repository. Consider adding domain if the feature grows significantly. |
| **Suggested Fix** | Optional — if the feature expands, extract entities and use cases to a domain layer. |

---

# Architecture Smells

### Massive Cubits
| Feature | Cubit | Lines (approx.) | Issues |
|---|---|---|---|
| prayer | `PrayerTimesCubit` | ~150 | Handles init, timer scheduling, prayer calculation, state management, locale setting, and service coordination. Too many concerns. |
| location_manager | `LocationCubit` | ~200 | Acts as facade over 2 other cubits while handling permission logic, service enabling, position saving, user choices, and retry — too many responsibilities. |
| salat_ala_nabi | `ReminderCubit` | ~200 | Manages init, loading, toggling, interval changes, working hours mode, time updates, save/discard — significant orchestration. |

### Large Widgets
| Feature | Widget | Issues |
|---|---|---|---|
| settings | `SettingsView` | Contains 3 private widget classes (`_SectionHeader`, `_QuickTile`, `_SocialIcon`). Consider extracting to separate files. |

### Dead Code
| Location | Detail |
|---|---|
| `azkar/data/repositories/reminder_repository_impl.dart` | `rescheduleAllActiveReminders()` method body is empty with a TODO comment noting the method is no longer needed. |

### Duplicated Logic
| Pattern | Details |
|---|---|
| Error handling | The `try/catch` → `unawaited(AppLogger.error(...))` → `Result.failure(...)` pattern is duplicated across ~15 repository files. A centralized utility could reduce boilerplate. |

---

# Dependency Violations

## Diagram of Current Dependency Issues

```
lib/core/
  ├── common/cards/ ──────imports──────> features/sharing/presentation/   ❌
  ├── bootstrap/ ─────────imports──────> features/azkar/domain/            ❌
  └── routing/ ───────────imports──────> features/*/presentation/routes/  ✅ (acceptable)

features/prayer/
  ├── presentation/cubits/ ──imports──> data/services/                    ❌
  ├── domain/use_cases/ ────imports──> features/app_date/data/models/     ❌❌
  │                                     (domain → other feature's data)
  └── data/services/ ───────re-exports─> domain/services/                  ⚠️ (unnecessary)

features/asma_ul_husna/
  ├── presentation/cubits/ ──imports──> data/repos/                       ❌
  └── data/repos/ ──────────defines──> interface + impl in same file      ❌

features/qibla/
  ├── domain/repositories/ ──defines──> interface
  └── data/repos/ ──────────implements─> interface                        ✅ (correct)
      BUT: folder named "repos" vs "repositories" — naming inconsistency  ⚠️

features/azkar/
  ├── domain/repositories/ ──defines──> interface
  └── data/repositories/ ────implements─> interface                       ✅ (correct)
```

## Summary of Dependency Issues

| # | Source | Target | Type | Severity |
|---|---|---|---|---|
| 1 | Core/common | features/sharing | Core → Feature | HIGH |
| 2 | Core/bootstrap | features/azkar | Core → Feature | HIGH |
| 3 | prayer/presentation | prayer/data | Presentation → Data | HIGH |
| 4 | asma_ul_husna/presentation | asma_ul_husna/data | Presentation → Data | HIGH |
| 5 | prayer/domain | app_date/data | Domain → (other) Data | CRITICAL |
| 6 | Core/di | All features | Core → Feature | ✅ Acceptable (DI wiring) |
| 7 | Core/routing | All features | Core → Feature | ✅ Acceptable (router config) |
| 8 | home/presentation | location_manager, prayer, app_date | Cross-feature (presentation) | ✅ Acceptable (orchestrating page) |

---

# Naming Issues

| # | File/Folder | Current Name | Recommended | Severity |
|---|---|---|---|---|
| 1 | Multiple features | `repos/` | `repositories/` | LOW |
| 2 | `qibla/domain/repositories/` vs `qibla/data/repos/` | Mixed | Consistent `repositories/` | LOW |
| 3 | `feedback/domain/repos/feedback_repository.dart` | `repos/` | `repositories/` | LOW |
| 4 | `prayer/calculators/` | Well-named | No change needed | 🟢 |
| 5 | `azkar/domain/use_cases/` | Some files use `_usecase.dart` suffix, some `_use_case.dart` | Standardize to `_use_case.dart` | LOW |

---

# Layer Analysis (Per Feature)

## `azkar` — Score: **9/10** ✅

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Data sources have abstract interfaces, clear DTOs (models), mappers, repository impls |
| **Domain** | ✅ Full domain layer: entities, repository interfaces, use cases, params, validators |
| **Presentation** | ✅ Cubits depend on use cases (domain), not data layer directly |
| **DI** | ✅ Dedicated DI module |
| **Naming** | ⚠️ `data/repositories/` vs others using `repos/` — minor |
| **Tests** | ✅ Comprehensive test suite across all layers |
| **Notes** | Gold standard feature. The `ReminderUseCases` facade pattern elegantly reduces cubit constructor dependencies. The `ReminderSchedulerHelper` is a pure utility. |

**Issues:** `reminder_validator.dart` imports only domain → good. `ReminderCubit` imports `AppPermissionsManager` and `NotificationService` from core/services → acceptable as these are core abstractions. The `rescheduleAllActiveReminders()` method in `ReminderRepositoryImpl` is left empty with a TODO comment — dead code.

---

## `prayer` — Score: **5.5/10** ⚠️

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Good data sources, repository impl with proper error handling |
| **Domain** | ✅ Rich domain: entities, repository interfaces (correctly in domain), services, use cases |
| **Presentation** | ❌ **Cubit imports data services directly** — bypasses domain |
| **Calculators** | ✅ Pure logic separated into `calculators/` — excellent pattern |
| **Naming** | ✅ Consistent |
| **Issues** | Major: presentation→data dependency. Unnecessary re-export in data layer. Domain use cases depend on another feature's data models (CRITICAL). |

---

## `qibla` — Score: **8/10** ✅

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Data source abstraction, proper repo impl |
| **Domain** | ✅ Full domain: entities (with @immutable from Flutter — minor), repository interface, service + impl, use cases |
| **Presentation** | ✅ Cubit depends on use cases (domain) |
| **Naming** | ⚠️ Inconsistent: `domain/repositories/` vs `data/repos/` |
| **Notes** | Well-structured. Pure math in domain service (`QiblaServiceImpl`) is a good example of business logic separation. |

---

## `teaching_prayer` — Score: **7.5/10** ✅

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Local data source, repo impl |
| **Domain** | ✅ Entities, repository interface, use cases (parsing logic) |
| **Presentation** | ✅ Cubit depends on domain repository interface |
| **Naming** | ✅ Consistent |
| **Issues** | Domain entity imports Flutter (minor). |

---

## `salat_ala_nabi` — Score: **7/10** ✅

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Data sources, models, services for background tasks |
| **Domain** | ✅ Entities, repository interfaces, use cases |
| **Presentation** | ⚠️ Cubit depends on domain repository and domain service — correct, but cubit is large with orchestration logic |
| **Naming** | ✅ Consistent |
| **Issues** | Domain entity imports Flutter. The `ReminderCubit` in presentation has significant state management logic that blurs the line between state and business logic. The `salawat_background_executor.dart` uses `@pragma('vm:entry-point')` — well done for background isolate support. |

---

## `asma_ul_husna` — Score: **5/10** ⚠️

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Data source abstraction, models, repo impl |
| **Domain** | ❌ Has `domain/entities/` but **repository interface is in data layer** |
| **Presentation** | ❌ Cubit imports from `data/repos/` instead of `domain/repos/` |
| **DI** | ✅ Dedicated DI module |
| **Naming** | ✅ Consistent |
| **Issues** | Missing domain repository interface forces presentation-data coupling. Domain layer is incomplete — has entities but no use cases or repository contract. |

---

## `daily_content` — Score: **6.5/10** ⚠️

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Data source, models, repository, shuffle service, favorites service |
| **Domain** | ❌ No domain layer (acceptable per guidelines, but borderline given complexity) |
| **Presentation** | ✅ Cubits handle state well, but orchestration logic is in the cubit |
| **Naming** | ✅ Consistent |
| **Issues** | No domain layer despite complex business logic (shuffled daily rotation, favorites, multi-type content). Consider adding domain if feature grows. |

---

## `home` — Score: **8/10** ✅

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Simple data source, repository, model |
| **Domain** | ❌ No domain (acceptable — simple feature) |
| **Presentation** | ✅ Orchestrates multiple features via BlocProviders — correct pattern for a dashboard page |
| **Naming** | ✅ Consistent |
| **Issues** | None significant. The home view correctly acts as an orchestrator, not a container of business logic. |

---

## `feedback` — Score: **7/10** ✅

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Remote data source, repo impl |
| **Domain** | ✅ Has domain repository contract |
| **Presentation** | ✅ Cubit depends on domain repository interface |
| **Naming** | ⚠️ `domain/repos/` vs `data/repos/` — inconsistent |
| **Issues** | Minor naming inconsistency with `repos/` abbreviation. |

---

## `developer_dashboard` — Score: **6/10** ⚠️

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Remote data source, repo impl with caching |
| **Domain** | ⚠️ Has `domain/entities/` but no use cases, no repository interface in domain |
| **Presentation** | ✅ Cubit depends on data repository interface |
| **Naming** | ⚠️ Mixed: `data/repos/` with interface in same file |
| **Issues** | Domain entity imports Flutter. `DashboardRepoImpl` has in-memory caching (`_cachedFeedbacks`) mixed with persistence concerns — violates SRP. |

---

## `app_date` — Score: **7.5/10** ✅

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Repository with abstract interface, model |
| **Domain** | ❌ No domain (acceptable) |
| **Presentation** | ✅ Cubit well-structured with lifecycle management |
| **Naming** | ✅ Consistent |
| **Issues** | None significant. Simple feature, well-implemented. |

---

## `app_update` — Score: **7/10** ✅

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Data source (remote config), repository, model |
| **Domain** | ❌ No domain (acceptable) |
| **Presentation** | ✅ Cubit handles caching and remote fetch |
| **Naming** | ✅ Consistent |
| **Issues** | The `AppUpdateService` in data layer combines remote config fetch, caching, version resolution, and URL launching — multiple concerns. Consider splitting. |

---

## `location_manager` — Score: **6.5/10** ⚠️

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Data sources (local + remote), repository interface + impl |
| **Domain** | ❌ No domain (acceptable) |
| **Presentation** | ⚠️ Three cubits (location, permission, position) that overlap in responsibilities |
| **DI** | ⚠️ Registered in `services_di.dart` as if it's a core service, not a feature |
| **Issues** | The feature is treated as both a feature and a service — its cubits are registered in `services_di.dart`. `LocationCubit` (~200 lines) acts as a facade over `LocationPermissionCubit` and `LocationPositionCubit`, handling permission checks, location enforcement, user choice flows, and retry logic — too many responsibilities for a single cubit. Consider the **Massive Cubit** smell. |

---

## `quran` — Score: **6/10** ⚠️

| Aspect | Assessment |
|---|---|
| **Data** | ✅ Repository impl |
| **Domain** | ⚠️ Has `domain/repos/` with interface — correct, but no use cases |
| **Presentation** | ✅ Cubit depends on domain interface |
| **Naming** | ⚠️ File named `quran_repo.dart` (abbreviated) |
| **Issues** | Very lightweight — effectively delegates to a third-party package (`quran_library`). The repo impl skips the data source layer and initializes the library directly. Consider wrapping library initialization behind a data source. |

---

## `settings` — Score: **7.5/10** ✅

| Aspect | Assessment |
|---|---|
| **Data/DI** | ✅ DI module |
| **Domain** | ❌ No domain (acceptable) |
| **Presentation** | ✅ Cubit + View are well-structured |
| **Naming** | ✅ Consistent |
| **Issues** | Minor: `settings_cubit.dart` imports `kIsWeb` and `AppStrings` and `AppLinks` directly from constants — acceptable for a presentation-only cubit. |

---

## `sharing` — Score: **5/10** ⚠️

| Aspect | Assessment |
|---|---|
| **Structure** | ⚠️ Only `presentation/` folder with widgets |
| **Core overlap** | ❌ Core services (`core/services/sharing/`) contain the actual sharing logic |
| **Responsibility** | ⚠️ Unclear boundary — is this a feature or a UI component? |
| **Issues** | This "feature" is actually a collection of reusable UI widgets. It's used by core (see Violation-004). The real sharing logic is in `core/services/sharing/`. Consider either: (a) making it a proper feature with its own services, or (b) moving these widgets to `core/common/widgets/` since they are reused UI components. |

---

## `splash` — Score: **7/10** ✅

| Aspect | Assessment |
|---|---|
| **Structure** | ✅ Minimal, correct |
| **Domain** | ❌ No domain (acceptable) |
| **Presentation** | ✅ Cubit + View clean and simple |
| **Issues** | The splash view triggers `HeavyServicesBootstrapper` setup (notification tap handler) — this could be centralized in the app bootstrap instead. |

---

## `main_layout` — Score: **8/10** ✅

| Aspect | Assessment |
|---|---|
| **Structure** | ✅ Clean shell with StatefulShellRoute |
| **Presentation** | ✅ Well-organized |
| **Issues** | None. Good use of GoRouter nested navigation. |

---

## `hadith_search` — Score: **0/10** ⚠️

| Aspect | Assessment |
|---|---|
| **Content** | Empty folder |
| **Issues** | Planned feature with no implementation. Either remove or add a `.gitkeep` with documentation. |

---

# Positive Findings

These are architecture decisions that should remain unchanged:

1. **Result type pattern** — Using `Sealed class Result<T>` with `Success` and `FailureResult` variants is a clean, type-safe approach to error handling that is used consistently across all features. **Keep.**

2. **Feature-first folder organization** — The feature-based structure with optional domain layers is well-suited to the app's domain and allows features to evolve independently. **Keep.**

3. **Azkar feature as reference implementation** — The azkar feature's full Clean Architecture with use cases, validators, params, and comprehensive tests sets a high bar that other features should aspire to. **Keep.**

4. **Separate calculators in prayer feature** — Moving pure calculation logic to `calculators/` folder keeps it testable and independent of BLoC/Cubit concerns. **Keep. Apply to other features where appropriate.**

5. **Dedicated DI modules per feature** — Each feature having its own `di/` method allows independent testing and maintainability. **Keep.**

6. **Abstract interface pattern for data sources** — The consistent use of `abstract interface class FooDataSource` with `FooDataSourceImpl` provides good testability and abstraction. **Keep.**

7. **Sealed classes for state** — Using sealed classes/Augmented enums for state with pattern matching in `switch` expressions is modern, safe, and readable. **Keep and extend to remaining features.**

8. **Background isolate support** — The `salawat_background_executor.dart` uses `@pragma('vm:entry-point')` and re-initializes DI in the isolate — proper handling of Flutter background execution. **Keep.**

9. **MidnightTimerService** — Separate timer service for day boundary events is a good abstraction for triggering daily refresh. **Keep.**

10. **Cubit lifecycle protection** — Most cubits correctly check `isClosed` before emitting, preventing memory leaks and crashes. **Keep.**

---

# Refactoring Roadmap

## Critical Priority (Fix Immediately)

| # | Violation | Description | Effort |
|---|---|---|---|
| CRIT-1 | VIOLATION-006 | Domain use cases importing other feature's data models | 1-2 hours |
| | | **Action:** Extract `AppHijriDate` to a shared domain entity in core or as a standalone shared model. Update both `prayer/domain/use_cases/` and `app_date/data/models/` to use the shared definition. | |

## High Priority (Fix Soon)

| # | Violation | Description | Effort |
|---|---|---|---|
| HIGH-1 | VIOLATION-002 | Prayer cubit imports data services directly | 2-3 hours |
| | | **Action:** Move service interfaces (`PrayerStatusService`, `PrayerTimesService`, `ReligiousEventsService`, `UserSettingsService`) to `prayer/domain/services/` or have the cubit depend only on the domain repository interface. Keep implementation in data. | |
| HIGH-2 | VIOLATION-003 | AsmaUlHusna repository interface in data layer | 1 hour |
| | | **Action:** Move `abstract interface class AsmaUlHusnaRepository` from `data/repos/` to `domain/repos/`. Update cubit import. | |
| HIGH-3 | VIOLATION-004 | Core common depends on feature (CombinedShareCopyButton) | 1-2 hours |
| | | **Action:** Move `CombinedShareCopyButton` from `features/sharing/presentation/` to `core/common/buttons/`. Update all imports. | |
| HIGH-4 | VIOLATION-005 | Core bootstrap depends on azkar feature | 1-2 hours |
| | | **Action:** Create a core abstraction for reminder rescheduling. Inject the feature-specific implementation. | |

## Medium Priority (Fix in Next Sprint)

| # | Violation | Description | Effort |
|---|---|---|---|
| MED-1 | VIOLATION-001 | Domain entities depend on Flutter foundation | 2-4 hours |
| | | **Action:** Remove `package:flutter/foundation.dart` from all domain files. Use `package:meta/meta.dart` for `@immutable`. Use `package:collection/collection.dart` for `DeepCollectionEquality`. | |
| MED-2 | VIOLATION-008 | Remove unnecessary re-export in prayer/data/services | 15 min |
| | | **Action:** Delete `prayer/data/services/prayer_state_service.dart` re-export. Update any consumers. | |
| MED-3 | VIOLATION-009 | Standardize naming: `repos/` → `repositories/` | 1 hour |
| | | **Action:** Rename all `repos/` folders to `repositories/` across all features. Update imports. | |
| MED-4 | location_manager | Feature registered as service in services_di.dart | 1 hour |
| | | **Action:** Move location_manager DI registration from `services_di.dart` to `features_di.dart` or its own feature DI module. | |
| MED-5 | developer_dashboard | In-memory cache mixed with repository (SRP violation) | 1-2 hours |
| | | **Action:** Extract the caching concern into a separate cache service or use a consistent pattern. | |

## Low Priority (Fix When Convenient)

| # | Violation | Description | Effort |
|---|---|---|---|
| LOW-1 | VIOLATION-010 | Missing barrel export files for features | 30 min |
| | | **Action:** Add `{feature_name}.dart` barrel files for: `home`, `app_date`, `app_update`, `developer_dashboard`, `feedback`, `location_manager`, `main_layout`, `splash`. | |
| LOW-2 | hadith_search | Empty folder | 5 min |
| | | **Action:** Either remove the folder or add documentation about planned implementation. | |
| LOW-3 | azkar RepositoryImpl | Empty `rescheduleAllActiveReminders()` method | 15 min |
| | | **Action:** Either implement or remove the method from the interface. | |
| LOW-4 | sharing feature | Unclear boundary — UI widgets vs real feature | 2-3 hours |
| | | **Action:** Evaluate whether `features/sharing/` should become a real feature or be dissolved into `core/common/widgets/` and `core/services/sharing/`. | |
| LOW-5 | Naming: `_usecase` vs `_use_case` suffix | Inconsistent file naming | 15 min |
| | | **Action:** Standardize all use case file names to `_use_case.dart` suffix. | |

---

# Summary

This project is structurally sound with a well-chosen Feature-First Clean Architecture. The `azkar` and `qibla` features demonstrate the ideal implementation. The main areas requiring attention are:

1. **🔴 Fix cross-feature domain-to-data dependency** (CRITICAL) — The prayer domain use cases should not depend on another feature's data layer.
2. **🟠 Repair presentation-to-data bypass** (HIGH) — Several cubits import data services directly instead of going through domain contracts.
3. **🟠 Disentangle core-from-feature dependencies** (HIGH) — Core infrastructure should not depend on features.
4. **🟡 Remove Flutter from domain** (MEDIUM) — Domain entities should be pure Dart.
5. **🟡 Standardize naming** (MEDIUM) — Consistent `repos`/`repositories` naming across features.

The total estimated effort to resolve all issues is approximately **2-3 days** for a single developer. The most impactful changes are the CRITICAL and HIGH priorities, which could be completed in a single focused session.
