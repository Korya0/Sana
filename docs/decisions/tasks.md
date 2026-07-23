# Tasks: Architecture Decisions & Refactoring

**Input**: Design documents from `docs/decisions/architecture-decisions.md`

**Prerequisites**: plan.md (required), spec.md (required for user stories), architecture-decisions.md

**Tests**: Code refactoring verification, static analysis (`flutter analyze`), and compile checks.

**Organization**: Tasks are grouped by user story (in priority order P1-P9) to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3...)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Refactoring initialization and baseline verification

- [ ] T001 Initialize Architecture Refactoring execution environment and verify project branch state
- [ ] T002 Configure static analysis and baseline check using `flutter analyze`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Prerequisites that MUST be checked before refactoring core packages

- [ ] T003 Backup barrel file export list in `lib/core/core.dart` and `lib/features/features.dart`
- [ ] T004 Audit global import statements to ensure clean dependency baseline before directory moves

---

## Phase 3: User Story 1 - Sharing Architecture Reorganization (Priority: P1) 🎯 MVP

**Goal**: Separate Sharing service logic/models into `core/services/sharing/` and presentation widgets into `features/sharing/presentation/`, eliminating duplicate code.

**Independent Test**: Verify sharing logic compiles independently from presentation, and `lib/features/sharing/presentation/` renders share cards without missing dependencies.

### Implementation for User Story 1

- [ ] T005 [P] [US1] Delete legacy presentation folder `lib/core/services/sharing/presentation/`
- [ ] T006 [P] [US1] Update `lib/core/services/sharing/index.dart` to export logic (`i_share_service.dart`, `share_service.dart`) and models (`share_config.dart`) only
- [ ] T007 [P] [US1] Consolidate presentation widgets (`share_card_container.dart`, `app_info_share.dart`, `combined_share_copy_button.dart`) and helpers (`app_clipboard.dart`, `app_share.dart`, `widget_to_image_helper.dart`) under `lib/features/sharing/presentation/`
- [ ] T008 [US1] Refactor all project-wide imports pointing to `lib/core/services/sharing/presentation/` to point to `lib/features/sharing/presentation/`

---

## Phase 4: User Story 2 - Network Folder Renaming (Priority: P2)

**Goal**: Rename `lib/core/networking/` directory to `lib/core/network/` to align with Flutter community standards.

**Independent Test**: Build and run network unit tests or static analysis to confirm zero broken import paths.

### Implementation for User Story 2

- [ ] T009 [P] [US2] Rename directory `lib/core/networking/` to `lib/core/network/`
- [ ] T010 [P] [US2] Update internal barrel export file `lib/core/network/network.dart`
- [ ] T011 [US2] Update project-wide imports from `package:muslim_app/core/networking/` to `package:muslim_app/core/network/`

---

## Phase 5: User Story 3 - Infrastructure Services Renaming (Priority: P3)

**Goal**: Clarify ambiguous service directory names in `lib/core/services/`.

**Independent Test**: Run `flutter analyze` to verify background task and timer imports resolve cleanly.

### Implementation for User Story 3

- [ ] T012 [P] [US3] Rename directory `lib/core/services/background/` to `lib/core/services/background_tasks/`
- [ ] T013 [P] [US3] Rename directory `lib/core/services/time/` to `lib/core/services/timer/`
- [ ] T014 [US3] Update all project-wide imports referencing `core/services/background/` to `core/services/background_tasks/`
- [ ] T015 [US3] Update all project-wide imports referencing `core/services/time/` to `core/services/timer/`

---

## Phase 6: User Story 4 - Religious Event Display Names Relocation (Priority: P4)

**Goal**: Move `religious_event_display_names.dart` from core constants into Prayer feature domain.

**Independent Test**: Verify Prayer feature barrel exports `ReligiousEvent` and `ReligiousEventDisplayNames` together and prayer entity tests pass.

### Implementation for User Story 4

- [ ] T016 [P] [US4] Relocate `lib/core/constants/religious_event_display_names.dart` to `lib/features/prayer/domain/enums/religious_event.dart` alongside `ReligiousEvent` enum
- [ ] T017 [P] [US4] Remove `religious_event_display_names.dart` export from `lib/core/constants/constants.dart`
- [ ] T018 [US4] Export `ReligiousEvent` enum and display names from Prayer feature barrel file `lib/features/prayer/prayer.dart`
- [ ] T019 [US4] Update import in `lib/features/prayer/domain/entities/religious_event_entity.dart` and dependent prayer feature files

---

## Phase 7: User Story 5 - Firebase Web Resilience & Retry Mechanics (Priority: P5)

**Goal**: Protect Web target from hanging on Firebase timeouts or blocked requests using Retry logic and fallback Error App.

**Independent Test**: Simulate Firebase init failure/timeout and verify `BootstrapErrorApp` renders `AppErrorView` with a functional Retry button.

### Implementation for User Story 5

- [ ] T020 [P] [US5] Add retry logic and 8-second timeout with 1-second retry delay in `lib/core/services/firebase_bootstrapper.dart` (or equivalent bootstrapper)
- [ ] T021 [US5] Wrap `initializeApp()` in `lib/main.dart` with `try-catch` exception handling
- [ ] T022 [US5] Create `BootstrapErrorApp` in `lib/main.dart` rendering dependency-free `AppErrorView` with Retry button triggering `main()`

---

## Phase 8: User Story 6 - Common Widgets Clean-Up & Consolidation (Priority: P6)

**Goal**: Reorganize `lib/core/common/` layout and dialog components.

**Independent Test**: Verify dialog and layout imports resolve correctly across all screens using `flutter analyze`.

### Implementation for User Story 6

- [ ] T023 [P] [US6] Move `lib/core/common/layout/permission_rationale_dialog.dart` to `lib/core/common/overlays/dialog/permission_rationale_dialog.dart`
- [ ] T024 [P] [US6] Remove duplicate `ShareCardContainer` in `lib/core/common/layout/` in favor of `lib/features/sharing/presentation/share_card_container.dart`
- [ ] T025 [US6] Update `lib/core/common/common.dart` barrel file and affected import statements across `lib/`

---

## Phase 9: User Story 7 - API Error Handler & Failure Formatting Safeguards (Priority: P7)

**Goal**: Ensure all Technical English errors in `api_error_handler.dart` pass through `FailureMapper` and cannot leak into UI.

**Independent Test**: Inspect Failure classes to verify `toString()` override prevents leaking raw technical English error strings.

### Implementation for User Story 7

- [ ] T026 [P] [US7] Audit repositories in `lib/features/` to verify error responses strictly invoke `FailureMapper.mapFailureToMessage()`
- [ ] T027 [P] [US7] Add `@override` implementation for `toString()` across all `Failure` subclasses in `lib/core/error/failures.dart`

---

## Phase 10: User Story 8 - Feature-Specific Utility Migration (Priority: P8)

**Goal**: Audit and relocate feature-specific helpers from `lib/core/utils/` to their designated feature module.

**Independent Test**: Confirm core shared utilities remain in `lib/core/utils/` while feature utilities reside inside `lib/features/`.

### Implementation for User Story 8

- [ ] T028 [P] [US8] Audit `lib/core/utils/app_feedback.dart` and relocate to `lib/features/feedback/` if feature-specific
- [ ] T029 [US8] Verify core shared utilities (`app_logger.dart`, `app_validators.dart`, `bloc_observer.dart`, `context_extension.dart`, `date_time_provider.dart`, `responsive_extension.dart`, `app_date_formatter.dart`, `version_utils.dart`) remain in `lib/core/utils/` and update any broken imports

---

## Phase 11: User Story 9 - AppStrings Standardization & Dialect Guidelines (Priority: P9)

**Goal**: Establish Modern Simplified Fusha Arabic text rules and document standards in `AppStrings`.

**Independent Test**: Verify `AppStrings` contains documentation guidelines and consistent terminology across Arabic strings.

### Implementation for User Story 9

- [ ] T030 [P] [US9] Add class-level documentation comments to `lib/core/constants/app_strings.dart` establishing Modern Simplified Fusha rules
- [ ] T031 [US9] Audit strings in `lib/core/constants/app_strings.dart` to standardize repeated terms and Arabic punctuation

---

## Phase 12: Polish & Cross-Cutting Concerns

**Purpose**: Final verification, static analysis, and documentation updates

- [ ] T032 [P] Update architecture status log in `docs/decisions/architecture-decisions.md`
- [ ] T033 Run `flutter analyze` across entire project to verify zero compilation or import errors
- [ ] T034 Verify all feature barrel files (`lib/core/core.dart`, `lib/features/features.dart`) export updated paths correctly

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phases 3-11)**: All depend on Foundational phase completion
  - User stories proceed in priority order (US1 → US2 → US3 → US4 → US5 → US6 → US7 → US8 → US9)
- **Polish (Phase 12)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Independent after Foundational (Phase 2)
- **User Story 2 (P2)**: Independent after Foundational (Phase 2)
- **User Story 3 (P3)**: Independent after Foundational (Phase 2)
- **User Story 4 (P4)**: Independent after Foundational (Phase 2)
- **User Story 5 (P5)**: Independent after Foundational (Phase 2)
- **User Story 6 (P6)**: Depends on US1 (uses consolidated `ShareCardContainer` from US1)
- **User Story 7 (P7)**: Independent after Foundational (Phase 2)
- **User Story 8 (P8)**: Independent after Foundational (Phase 2)
- **User Story 9 (P9)**: Independent after Foundational (Phase 2)

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel
- Models, directories, and utilities marked [P] across different stories can be modified in parallel
- US1, US2, US3, US4, US5, US7, US8, and US9 can proceed in parallel across independent files

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL)
3. Complete Phase 3: User Story 1 (Sharing Reorganization)
4. **STOP and VALIDATE**: Verify sharing module compiles and exports cleanly

### Incremental Delivery

1. Complete Setup + Foundational → Baseline ready
2. Deliver US1 (Sharing) → Test & verify
3. Deliver US2 (Network folder) & US3 (Services folder) → Test & verify
4. Deliver US4 (Religious Event) & US5 (Firebase Retry) → Test & verify
5. Deliver US6 (Common Widgets) & US7 (Failure Mapper) → Test & verify
6. Deliver US8 (Utils) & US9 (AppStrings) → Test & verify
7. Phase 12 Polish → Final static analysis check
