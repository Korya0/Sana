# Tasks: Azkar Reminder Notifications

**Input**: Design documents from `lib/features/azkar/`

**Prerequisites**: [spec.md](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/spec.md) (required), [plan.md](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/plan.md) (required)

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization, dependency additions, extending the existing local notifications service, and integrating timezone initialization.

- [x] T001 Add `timezone` package to `pubspec.yaml` (since `flutter_local_notifications` is already present)
- [x] T002 [P] Review and extend `INotificationService` interface in `lib/core/services/notification/i_notification_service.dart` if needed to support zoned scheduling and payload taps
- [x] T003 [P] Create notification request model `NotificationRequest` in `lib/core/services/notification/models/notification_request.dart`
- [x] T003b [P] Create payload key constants `NotificationKeys` in `lib/core/services/notification/notification_keys.dart` to keep payload keys generic and modular
- [x] T004 [P] Create notification payload model `NotificationPayload` in `lib/core/services/notification/models/notification_payload.dart`
- [x] T005 Update `NotificationServiceImpl` wrapping the local notification plugin in `lib/core/services/notification/notification_service_impl.dart` to handle zoned scheduling and callbacks
- [x] T006 Register `NotificationScheduler` in `lib/core/di/services_di.dart` (reusing existing `INotificationService` injection)
- [x] T007 Initialize `timezone` database and load local locations inside `_initHeavyServices()` of `lib/core/di/service_locator.dart`
- [x] T008 Configure platform-specific files: register boot receiver in `android/app/src/main/AndroidManifest.xml` and configure permissions/initialization in `ios/Runner/AppDelegate.swift`
- [x] T009 Verify core integration by testing that app launches and initialization runs without errors

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Create shared domain contracts, enums, value objects, and repository/data source contracts.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T010 [P] Create enums `WeekDay` in `lib/features/azkar/domain/entities/weekday.dart` and `RepeatType` in `lib/features/azkar/domain/entities/repeat_type.dart`
- [x] T011 [P] Create notification template enum `NotificationTemplate` in `lib/features/azkar/domain/entities/notification_template.dart`
- [x] T012 Create reminder domain entity `ReminderEntity` in `lib/features/azkar/domain/entities/reminder_entity.dart`
- [x] T013 [P] Create failure classes for reminder operations in `lib/core/error/failures.dart`
- [x] T014 [P] Create repository interface `ReminderRepository` contract in `lib/features/azkar/domain/repositories/reminder_repository.dart`
- [x] T015 [P] Create local data source contract `ReminderLocalDataSource` in `lib/features/azkar/data/datasources/reminder_local_data_source.dart`
- [x] T016 [P] Create notification scheduler contract `NotificationScheduler` in `lib/core/services/notification/notification_scheduler.dart`
- [x] T017 [P] Create UseCase parameters `create_reminder_params.dart` and `update_reminder_params.dart` in `lib/features/azkar/domain/params/`

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Reminder Management (Priority: P1) 🎯 MVP

**Goal**: Implement local storage (Hive), repositories, use cases, Cubit, state, and UI for managing (create, update, delete, toggle) reminders.

**Independent Test**: User opens an Azkar details screen, adds a reminder via a dialog, views the reminder in a list, toggles it on/off, edits its time, and deletes it. All states persist locally.

### Implementation for User Story 1

- [x] T018 [P] [US1] Create database model `ReminderModel` annotated for Hive in `lib/features/azkar/data/models/reminder_model.dart`
- [x] T019 [US1] Run build_runner to generate Hive Adapter class in `lib/features/azkar/data/models/reminder_model.g.dart`
- [x] T020 [US1] Register `ReminderModel` adapter in `lib/core/di/core_di.dart`
- [x] T021 [US1] Setup Hive box for reminders in `lib/core/di/core_di.dart`
- [x] T022 [US1] Implement `ReminderLocalDataSourceImpl` using Hive box in `lib/features/azkar/data/datasources/reminder_local_data_source_impl.dart`
- [x] T023 [P] [US1] Create mapper `ReminderMapper` in `lib/features/azkar/data/mappers/reminder_mapper.dart` to map model to entity
- [x] T024 [US1] Implement `ReminderRepositoryImpl` combining Hive local data source in `lib/features/azkar/data/repositories/reminder_repository_impl.dart` (enforce "Log Once at the Source" by catching exceptions and calling `AppLogger.error` once at the repository/datasource level, returning `Result.failure`)
- [x] T025 [P] [US1] Implement `CreateReminderUseCase` in `lib/features/azkar/domain/usecases/create_reminder_use_case.dart`
- [x] T026 [P] [US1] Implement `UpdateReminderUseCase` in `lib/features/azkar/domain/usecases/update_reminder_use_case.dart`
- [x] T027 [P] [US1] Implement `DeleteReminderUseCase` in `lib/features/azkar/domain/usecases/delete_reminder_use_case.dart`
- [x] T028 [P] [US1] Implement `ToggleReminderUseCase` in `lib/features/azkar/domain/usecases/toggle_reminder_use_case.dart`
- [x] T029 [P] [US1] Implement `GetRemindersUseCase` in `lib/features/azkar/domain/usecases/get_reminders_use_case.dart`
- [x] T030 [US1] Register all reminder use cases and repository in `lib/core/di/azkar_di.dart`
- [x] T031 [P] [US1] Create reminder state `ReminderState` as sealed class in `lib/features/azkar/presentation/cubits/reminder/reminder_state.dart`
- [x] T032 [US1] Implement state transitions in `ReminderCubit` in `lib/features/azkar/presentation/cubits/reminder/reminder_cubit.dart` (handle `Result.failure` quietly by updating state to error; do NOT call `AppLogger.error` again in the Cubit)
- [x] T033 [US1] Register `ReminderCubit` as a factory in `lib/core/di/azkar_di.dart`
- [x] T034 [P] [US1] Create `RepeatSelector` widget for repeat options in `lib/features/azkar/presentation/widgets/repeat_selector.dart`
- [x] T035 [P] [US1] Create `ReminderDialog` with time selector in `lib/features/azkar/presentation/widgets/reminder_dialog.dart`
- [x] T036 [P] [US1] Create `ReminderTile` to list reminders and support delete/toggle in `lib/features/azkar/presentation/widgets/reminder_tile.dart`
- [x] T037 [P] [US1] Create `ReminderEmptyView` for zero states in `lib/features/azkar/presentation/widgets/reminder_empty_view.dart`
- [x] T038 [US1] Create container widget `ReminderSection` in `lib/features/azkar/presentation/widgets/reminder_section.dart`
- [x] T039 [US1] Integrate `ReminderSection` inside Settings bottom sheet or Azkar screen in `lib/features/azkar/presentation/pages/azkar_details_page.dart`

**Checkpoint**: At this point, User Story 1 (Reminder Management) should be fully functional and testable independently

---

## Phase 4: User Story 2 - Receive Notifications (Priority: P2)

**Goal**: Implement local notification scheduling logic, handle timezones, handle exact alarm permissions, and restore schedules on device reboot.

**Independent Test**: Schedule a reminder for 1 minute from now, background the app, and verify that the local notification triggers on time. Reboot the device and verify that the reminder is restored.

### Implementation for User Story 2

- [x] T040 [US2] Implement `NotificationSchedulerImpl` using `INotificationService` and `timezone` package in `lib/core/services/notification/notification_scheduler_impl.dart`
- [x] T041 [US2] Register `NotificationScheduler` in `lib/core/di/services_di.dart`
- [x] T042 [US2] Integrate `NotificationScheduler` scheduling/cancelling in `ReminderRepositoryImpl` in `lib/features/azkar/data/repositories/reminder_repository_impl.dart`
- [x] T043 [US2] Add Exact Alarm permission request dialog and check API in `lib/core/services/notification/notification_service_impl.dart` and `android/app/src/main/AndroidManifest.xml`
- [x] T044 [US2] Add the standard `ScheduledNotificationBootReceiver` for `flutter_local_notifications` to `android/app/src/main/AndroidManifest.xml` to restore notifications on boot automatically
- [x] T045 [US2] Add helper logic inside `_initHeavyServices()` of `lib/core/di/service_locator.dart` to verify or trigger rescheduling of active reminders if necessary on startup

**Checkpoint**: At this point, User Stories 1 AND 2 should both work together - notifications will fire correctly at scheduled times.

---

## Phase 5: User Story 3 - Open Azkar From Notification (Priority: P3)

**Goal**: Support tapping the notification to deep-link directly to the specific Azkar page.

**Independent Test**: Tap a reminder notification from the device notification drawer and verify that the app opens and redirects to the details page of the Azkar.

### Implementation for User Story 3

- [x] T046 [US3] Configure GoRouter paths to support direct navigation via azkar ID in `lib/core/routing/app_router.dart`
- [x] T047 [US3] Implement notification click listener and routing execution inside `NotificationServiceImpl` in `lib/core/services/notification/notification_service_impl.dart`

**Checkpoint**: All user stories should now be independently functional and integrated together.

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Handle edge cases, validations, loading/error states, and code cleanups.

- [x] T048 [P] Create validation logic class `ReminderValidator` in `lib/features/azkar/domain/validators/reminder_validator.dart`
- [x] T049 [P] Integrate validation logic and handle empty/invalid times in `lib/features/azkar/presentation/widgets/reminder_dialog.dart`
- [x] T050 [P] Handle permission denied state, showing clear prompt with navigation to device settings in `lib/features/azkar/presentation/widgets/reminder_section.dart`
- [x] T051 Handle timezone travel changes by checking and rescheduling reminders on app resume in `lib/core/di/service_locator.dart` (or app lifecycle handling)
- [x] T052 Detect manual device clock changes and trigger rescheduling in `lib/core/di/service_locator.dart` (or app lifecycle handling)
- [x] T053 Add loading skeletons using Skeletonizer in `lib/features/azkar/presentation/widgets/reminder_section.dart`
- [x] T054 Add error handling state UI in `lib/features/azkar/presentation/widgets/reminder_section.dart` (render the error view cleanly from the UI state; do NOT call `AppLogger.error` in the widget)
- [x] T055 Verify performance with a large number of reminders (e.g. 50+ notifications) to verify no lag or memory leaks
- [x] T056 [P] Clean up files, remove print logs, audit imports (ensure no relative imports and use package:sana/ everywhere), check architecture compliance, and run code linting

---

## Phase 6: Notification Bug Fixes & Deep-Link Navigation

**Purpose**: Fix notifications permission requesting, customize notification messages based on Azkar type, and support displaying the correct category title when launching via deep-link.

- [x] T057 [US2] Update `NotificationKeys` in `lib/core/services/notification/notification_keys.dart` to match integer category IDs (`morningAzkarId` to `'2'`, `eveningAzkarId` to `'3'`, `sleepAzkarId` to `'4'`)
- [x] T058 Define notification permission strings in `lib/core/constants/app_strings.dart`
- [x] T059 [US2] Request Notification permission using `IAppPermissionsManager` before showing reminder dialog and when toggling reminder ON in `lib/features/azkar/presentation/widgets/reminder_section.dart`
- [x] T060 [US2] Enhance `ReminderRepositoryImpl._scheduleAll` in `lib/features/azkar/data/repositories/reminder_repository_impl.dart` to fetch the category title and customize notification content dynamically
- [x] T061 [US3] Update `AzkarListView` in `lib/features/azkar/presentation/views/azkar_list_view.dart` to asynchronously load and update category title on deep-link navigation when title is missing/fallback

---

---

## Phase 7: Architecture & UI Rules Refactoring

**Purpose**: Fix architectural leaks (bypassing state management) and enforce strict UI guidelines from CLAUDE_UI.md.

- [x] T062 Clean `AzkarListView` architecture leak by injecting `GetCategoriesUseCase` into `AzkarCubit` and adding `resolvedTitle` to `AzkarLoaded` state.
- [x] T063 Update dependency injection for `AzkarCubit` in `lib/core/di/azkar_di.dart` and fix all related unit tests (`azkar_cubit_test.dart`, `azkar_list_view_test.dart`, etc.).
- [x] T064 Extract all hardcoded Arabic UI strings from Reminder widgets into `lib/core/constants/app_strings.dart`.
- [x] T065 Enforce `CLAUDE_UI.md` typography rules by replacing manual `TextStyle` instantiations with `Theme.of(context).textTheme` in all Reminder widgets.
- [x] T066 Enforce `CLAUDE_UI.md` spacing rules by replacing hardcoded numerical paddings/sized boxes with `AppSpacing` tokens in all Reminder widgets.
- [x] T067 Run `flutter analyze` and `flutter test` to verify 100% codebase compliance.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User Story 1 (P1) is the MVP and should be completed first.
  - User Story 2 (P2) depends on User Story 1 for data models and repositories.
  - User Story 3 (P3) depends on User Story 2 for notifications payload details.
- **Polish (Final Phase)**: Depends on all user stories being complete.
- **Notification Bug Fixes & Deep-Link Navigation (Phase 6)**: Depends on Phase 3, 4, 5, and Polish Phase completion.

### Within Each User Story

- Models before services
- Services before UI widgets
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Presentation widgets within US1 marked [P] can be implemented in parallel once repository and use cases are ready.

---

## Parallel Example: User Story 1

```bash
# Implement independent UI widgets in parallel:
Task: "Create RepeatSelector widget in lib/features/azkar/presentation/widgets/repeat_selector.dart"
Task: "Create ReminderEmptyView widget in lib/features/azkar/presentation/widgets/reminder_empty_view.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL)
3. Complete Phase 3: User Story 1 (Reminder Management)
4. **STOP and VALIDATE**: Verify local storage and UI list operations manually.

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test local persistence independently (MVP!)
3. Add User Story 2 → Test active notification firing (Offline + Background)
4. Add User Story 3 → Test notification click navigation flow (Deep Link)
5. Each story adds value without breaking previous stories
6. Complete Phase 6 → Verify permission requesting, dynamic notification titles/bodies, and deep-link category page navigation.
