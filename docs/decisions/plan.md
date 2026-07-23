# Implementation Plan: Architecture Decisions & Codebase Refactoring

**Reference**: `docs/decisions/architecture-decisions.md`

## Tech Stack & Architecture
- **Framework**: Flutter / Dart
- **Architecture Pattern**: Clean Architecture (Feature-first & Layered Core)
- **State Management**: Bloc / Cubit

## Scope of Implementation
1. Reorganize sharing presentation vs service logic
2. Rename core directory paths (`networking/` -> `network/`, `services/background/` -> `services/background_tasks/`, `services/time/` -> `services/timer/`)
3. Move religious event display names to Prayer domain
4. Implement web resilience retry & error fallback in main/bootstrapper
5. Clean up common overlays & widgets
6. Safeguard failure messages via FailureMapper and toString overrides
7. Audit core utils for feature-specific code
8. Document string conventions in AppStrings
