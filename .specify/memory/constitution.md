<!-- Sync Impact Report
Version change: 1.0.0 -> 1.1.0
Modified principles: 
- I. Clean Architecture -> I. Pragmatic Tiered Architecture (Introduced Tiers 1-3)
- II. State Management with Cubit -> II. Strict State Management & Types (Added SRP and Sealed Classes focus)
- III. High-Performance Modern UI -> III. High-Performance Modern UI & Safe Assets (Added flutter_gen and design tokens)
- IV. Robust Local Storage -> IV. Robust Networking & Local Storage (Added Dio/Retrofit)
- V. Background Processing -> V. Background Processing & Shared Code Discipline (Added core/ usage)
Added sections: Technology Stack Requirements expanded (go_router, get_it, Shorebird)
Removed sections: None
Templates requiring updates:
- .specify/templates/plan-template.md (✅ updated)
- .specify/templates/spec-template.md (✅ updated)
- .specify/templates/tasks-template.md (✅ updated)
Follow-up TODOs: None
-->
# Sana Constitution

## Core Principles

### I. Pragmatic Tiered Architecture
Not all features require full Clean Architecture. We use a pragmatic tiered approach:
- **Tier 1 (Full 3-Layer)**: Data → Domain → Presentation. Used for remote APIs and complex rules.
- **Tier 2 (Simplified 2-Layer)**: Data → Presentation. Used when business logic is straightforward.
- **Tier 3 (Presentation-Only)**: Used for pure UI screens.
Dependency Injection MUST be managed using `get_it` (`sl<Type>()`). Cross-feature imports are strictly forbidden.

### II. Strict State Management & Types
State management MUST be handled using Cubit (`flutter_bloc`) combined with Dart 3 Sealed Classes for compile-time exhaustiveness. State MUST NOT be modified outside of Cubits. We enforce a strict Single Responsibility Principle (SRP) across all files.

### III. High-Performance Modern UI & Safe Assets
The user interface MUST be visually premium, utilizing our design tokens (`context.color` via `MyColors`, `AppSpacing`, `AppTextStyles` from `core/theme/`). Asset references MUST use `flutter_gen` (`Assets.images.*`). We NEVER hardcode UI values or text (use `AppStrings`).

### IV. Robust Networking & Local Storage
Local data persistence MUST utilize Hive for high-speed local storage. Networking MUST use Dio + Retrofit (code-gen) + interceptor chain. We avoid `freezed` & `json_serializable` in favor of Native Dart 3 sealed classes where possible. Applications MUST support robust offline capabilities.

### V. Background Processing & Shared Code Discipline
Features requiring scheduled tasks MUST utilize `Workmanager`. Any reusable logic, utility, or widget used in 2+ places MUST be placed in `core/` to prevent duplication. Code generation must only use approved generators (Retrofit, flutter_gen).

## Technology Stack Requirements

- **Framework**: Flutter (Stable)
- **Language**: Dart
- **Navigation**: `go_router` (centralized in `core/routing/`)
- **Dependency Injection**: `get_it`
- **Networking**: `dio` + `retrofit`
- **Database**: Hive (via `ILocalStorageService`)
- **Cloud Interface**: Firebase (Analytics, Crashlytics, Remote Config, Firestore)
- **State Management**: Cubit (`flutter_bloc`) with Sealed Classes
- **Asset Safety**: `flutter_gen`
- **OTA Updates**: Shorebird

## Development Workflow

- **Design First**: Implementations MUST start with detailed planning via SpecKit.
- **Strict Imports**: Use `package:` imports for ALL files within `lib/`. Relative imports are strictly forbidden.
- **Layer Boundaries**: UI/presentation layer has ZERO business logic. Domain handles logic. Data handles external sources.
- **Testing**: Manual test scenarios for UI. Architectural audits before merge. Write deterministic tests.

## Governance

This Constitution supersedes all other practices. All Pull Requests and code reviews MUST verify compliance with these architectural and design principles. Any major deviations or architectural changes MUST be documented and approved.

**Version**: 1.1.0 | **Ratified**: 2026-07-06 | **Last Amended**: 2026-07-06
