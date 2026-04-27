# Audit Tasks: Salat Ala Nabi Feature Refactoring

This document outlines the tasks required to bring the `salat_ala_Nabi` feature and related services into full compliance with the project's engineering standards defined in `CLAUDE.md`.

## 1. Naming & Structure (Section C)
- [ ] **Rename Feature Directory**: Rename `lib/features/salat_ala_Nabi` to `lib/features/salat_ala_nabi` (all lowercase snake_case).
- [ ] **Refactor Repository Naming**:
    - Rename `IReminderRepo` to `IReminderRepository`.
    - Rename `ReminderRepoImpl` to `ReminderRepositoryImpl`.
    - Update all imports and DI registrations.
- [ ] **Refactor Model Naming**:
    - Rename `ReminderSettings` to `ReminderSettingsModel`.
    - Update all usages in Cubits, Data Sources, and Repositories.
- [ ] **Refactor Constants Naming**:
    - Rename `SalawatConstants` to `AppSalawatConstants`.
    - Ensure it follows the `App` prefix rule for global constants.

## 2. Architecture & Logic (Section A & C)
- [ ] **Move Business Logic to Model**:
    - Move the time-range checking logic from `salawat_background_executor.dart` to a method within `ReminderSettingsModel` (e.g., `bool isWithinWorkingHours(DateTime time)`).
- [ ] **Decouple Background Executor**:
    - Remove manual instantiation of `NotificationServiceImpl` in `salawatCallbackDispatcher`.
    - Use the service locator (`sl<INotificationService>()`) or a dedicated initialization flow for background tasks to avoid skipping DI.

## 3. UI & Styling Compliance (Section B)
- [ ] **Remove Ad-hoc RTL Overrides**:
    - Remove the manual `Directionality(textDirection: TextDirection.rtl)` in `WorkingHoursWidget`.
    - Rely on the global localization system for RTL handling.
- [ ] **Refactor Ad-hoc Container Styling**:
    - Replace the inline `color.withValues(alpha: 0.15)` in `CustomWorkingHourOption` and `WorkingHourOptionItem` with a proper design token or constant if this pattern is reused.
- [ ] **UI State Isolation Check**:
    - Ensure all states (Loading, Success, Error) are fully isolated as per Section B, Rule 1. (Currently mostly done via `SalatAlaNabiSkeleton` and `AppErrorView`).

## 4. Dependency Injection (Section C, 6)
- [ ] **Update DI Registrations**:
    - Update `lib/core/di/features_di.dart` to use the new naming conventions (`IReminderRepository`, `ReminderSettingsModel`, etc.).
    - Ensure `ReminderCubit` remains a `factory` and repositories are `lazySingletons`.

## 5. Clean-up & Polish
- [ ] **Strings Audit**:
    - Verify all Arabic strings in the feature are centralized in `AppStrings`.
- [ ] **Logger Consistency**:
    - Ensure `AppLogger` is used for all error logging in the repository and background service without exception.
- [ ] **Dispose Check**:
    - Ensure no controllers or focus nodes are created inside `build` methods in any of the feature's widgets.

---
**Note**: Each task should be followed by the `/code-review` skill once implemented to ensure no new violations are introduced.
