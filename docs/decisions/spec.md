# Feature Specification: Architecture Decisions & Codebase Refactoring

**Reference**: `docs/decisions/architecture-decisions.md`

## Overview
Execute approved architectural refactorings across the codebase to improve modularity, Clean Architecture adherence, and maintainability.

## User Stories

### US1: Sharing Architecture Reorganization (Priority: P1)
As a developer, I want sharing logic in `core` and presentation in `features/sharing` so that dependencies are clean and un-duplicated.

### US2: Network Folder Renaming (Priority: P2)
As a developer, I want `core/networking` renamed to `core/network` to follow Flutter community conventions.

### US3: Infrastructure Services Renaming (Priority: P3)
As a developer, I want `background` and `time` service folders renamed to `background_tasks` and `timer` for clarity.

### US4: Religious Event Display Names Relocation (Priority: P4)
As a developer, I want religious event display names moved into `features/prayer` domain.

### US5: Firebase Web Resilience & Retry Mechanics (Priority: P5)
As a user on web, I want the app to handle Firebase connection timeouts gracefully with retries and a fallback error screen.

### US6: Common Widgets Clean-Up & Consolidation (Priority: P6)
As a developer, I want `common/` widgets organized cleanly by overlay and presentation type without duplication.

### US7: API Error Handler & Failure Formatting Safeguards (Priority: P7)
As an Arabic user, I want error messages formatted through `FailureMapper` so technical English strings never leak into UI.

### US8: Feature-Specific Utility Migration (Priority: P8)
As a developer, I want feature-specific helpers moved out of `core/utils` into their respective features.

### US9: AppStrings Standardization & Dialect Guidelines (Priority: P9)
As a user, I want consistent Modern Simplified Fusha Arabic text across all screens.
