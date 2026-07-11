# Implementation Plan: Azkar Reminder Notifications

**Branch**: `feature/azkar-reminders` | **Date**: 2026-07-11 | **Spec**: [spec.md](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/spec.md)

## Summary

This feature adds a local notification reminder system to the Azkar module. It allows users to schedule reminders for specific azkar categories, custom-configure repeating days, toggle them on/off, edit, and delete them. The data is persisted locally using Hive, and scheduling is managed via `flutter_local_notifications` combined with the `timezone` package.

## Technical Context

- **Language/Version**: Dart 3.x / Flutter Stable
- **Primary Dependencies**: `flutter_local_notifications`, `timezone`, `flutter_bloc` (Cubit), `get_it`
- **Storage**: Hive (Local storage box specifically for reminders)
- **Testing**: Manual testing on Android and iOS emulator/devices
- **Target Platform**: Android and iOS
- **Project Type**: Mobile Application
- **Constraints**: Offline-capable, timezone-aware, must restore schedules on device reboot.

## Constitution Check

- [x] Does the plan define which Architecture Tier this feature uses (Tier 1/2/3)?
  - *Yes, Tier 1: Domain, Data, and Presentation layers.*
- [x] Is State Management handled entirely by Cubit (`flutter_bloc`) using Sealed Classes?
  - *Yes, using ReminderCubit and ReminderState sealed classes.*
- [x] Does the UI plan use standard design tokens (`MyColors`, `AppSpacing`) and `flutter_gen` for assets?
  - *Yes, conforming to the design tokens defined in core/theme.*
- [x] Are dependencies managed via `get_it`?
  - *Yes, using GetIt in core/di.*
- [x] Are background tasks scheduled with Workmanager?
  - *N/A, local notification scheduling uses flutter_local_notifications API directly.*

## Project Structure

### Documentation

```text
lib/features/azkar/
├── spec.md              # Feature specification
├── plan.md              # Technical implementation plan
└── tasks.md             # Task checklist (to be generated)
```

### Source Code

```text
lib/
├── core/
│   ├── di/
│   │   └── azkar_di.dart                   # Registration of reminder use cases/cubits
│   └── services/
│       └── notification/
│           ├── i_notification_service.dart # Existing generic notification interface (extended)
│           ├── notification_service_impl.dart # Existing implementation (updated)
│           ├── notification_keys.dart      # Static key constants for payloads and types
│           ├── notification_scheduler.dart # Scheduling logic contract
│           ├── notification_scheduler_impl.dart # Scheduling logic implementation
│           └── models/
│               ├── notification_request.dart # Request details model
│               └── notification_payload.dart # Payload details model
│
└── features/
    └── azkar/
        ├── domain/
        │   ├── entities/
        │   │   ├── reminder_entity.dart
        │   │   ├── weekday.dart
        │   │   └── repeat_type.dart
        │   ├── repositories/
        │   │   └── reminder_repository.dart
        │   └── usecases/
        │       ├── create_reminder_use_case.dart
        │       ├── update_reminder_use_case.dart
        │       ├── delete_reminder_use_case.dart
        │       ├── toggle_reminder_use_case.dart
        │       └── get_reminders_use_case.dart
        ├── data/
        │   ├── datasources/
        │   │   ├── reminder_local_data_source.dart
        │   │   └── reminder_local_data_source_impl.dart
        │   ├── mappers/
        │   │   └── reminder_mapper.dart
        │   ├── models/
        │   │   └── reminder_model.dart
        │   └── repositories/
        │       └── reminder_repository_impl.dart
        └── presentation/
            ├── cubits/
            │   └── reminder/
            │       ├── reminder_cubit.dart
            │       └── reminder_state.dart
            └── widgets/
                ├── reminder_section.dart
                ├── reminder_tile.dart
                ├── reminder_dialog.dart
                ├── repeat_selector.dart
                └── reminder_empty_view.dart
```

**Structure Decision**: Tier 1 architecture. Clean separation of notifications infrastructure in `lib/core/services/notification` and reminders feature-specific domain/data/presentation in `features/azkar`.
