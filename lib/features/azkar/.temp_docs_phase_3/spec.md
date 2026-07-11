# Feature Specification: Azkar Reminder Notifications

**Feature Branch**: `feature/azkar-reminders`

**Created**: 2026-07-11

**Status**: Approved

## User Scenarios & Testing

### User Story 1 - Reminder Management (Priority: P1) 🎯 MVP

As a user, I want to create, edit, delete, and toggle reminders for my azkar, so that I can manage when I want to be reminded.

**Why this priority**: Core functionality needed to have any reminders at all. Without setting and persisting reminders, the feature does not exist.
**Independent Test**: User can open an Azkar page, create a reminder for a specific time and repeat pattern, view it in a list, toggle it on/off, edit it, and delete it. All state changes are persisted locally.

**Acceptance Scenarios**:
1. **Given** the user is on a specific Azkar page, **When** they click "Add Reminder", select a time, and save, **Then** the reminder is saved locally and displayed in the reminders list.
2. **Given** a reminder is enabled, **When** the user toggles it off, **Then** the reminder state changes to disabled, and its scheduled notification is cancelled while the record remains.
3. **Given** a reminder exists, **When** the user edits its time or repeat pattern, **Then** the old notification is cancelled, and the updated reminder is scheduled and saved.
4. **Given** a reminder exists, **When** the user deletes it, **Then** its local record is removed, and its scheduled notification is cancelled.

---

### User Story 2 - Receive Notifications (Priority: P2)

As a user, I want to receive a local notification at the scheduled time of my reminder, even when the app is in the background or closed.

**Why this priority**: The value of a reminder is in being actively notified in a timely manner.
**Independent Test**: Set a reminder for 1 minute in the future, close the app or send it to the background, and verify that the system notification appears exactly at the scheduled time.

**Acceptance Scenarios**:
1. **Given** the app is in the background or closed, **When** the scheduled reminder time arrives, **Then** a local notification is displayed with the title "حان وقت الذكر" and body "لا تنس أذكار الصباح" (or the appropriate template).
2. **Given** the device is restarted, **When** the boot process completes, **Then** the app restores and schedules all active reminders.

---

### User Story 3 - Open Azkar From Notification (Priority: P3)

As a user, I want to tap on a notification and be taken directly to the related Azkar page.

**Why this priority**: Direct access to the target content ensures a frictionless user experience and high engagement.
**Independent Test**: Tap the displayed notification and verify that the app launches and navigates directly to the details page of the Azkar associated with the reminder.

**Acceptance Scenarios**:
1. **Given** a reminder notification is displayed on the device, **When** the user taps the notification, **Then** the app opens and navigates immediately to the details page of the corresponding `azkarId`.

---

## Edge Cases

- **Permission Denied**: If notification permission is denied, explain why it is needed and direct the user to system settings to enable it.
- **Empty / Cancelled Dialog**: If the user cancels the reminder creation dialog without selecting a time, no reminder should be saved or scheduled.
- **Timezone Change**: If the user travels to a different timezone, recalculate and reschedule reminders based on the new local time.
- **Manual Clock Change**: If the user manually changes the device clock, detect the change and reschedule reminders to match the correct target time.
- **Multiple Reminders**: If the user schedules multiple reminders for the same Azkar, ensure they each generate distinct notification IDs and do not overwrite each other.
- **Large Number of Reminders**: Ensure the system handles a large volume of reminders without lagging or hitting platform notification limits (max 500 on Android).

## Functional Requirements

- **FR-001**: Every reminder MUST be associated with a specific `azkarId`.
- **FR-002**: Reminders MUST support daily repeating and custom days repeating.
- **FR-003**: Reminders MUST be persisted locally using Hive storage.
- **FR-004**: Notifications MUST work entirely offline without any internet connection.
- **FR-005**: The system MUST request notification permissions only when the user attempts to schedule their first reminder.
- **FR-006**: Tapping a notification MUST redirect the user to the specific Azkar details screen using GoRouter.

## Key Entities

- **Reminder**:
  - `id`: Unique identifier (String)
  - `azkarId`: The ID of the target Azkar (String)
  - `time`: Time of day in format "HH:mm" (String)
  - `repeatType`: Type of repeat (e.g. daily, customDays) (String)
  - `days`: List of integers representing days of the week (List<int>)
  - `isEnabled`: Flag indicating if the reminder is active (bool)
  - `timezone`: The timezone string (String)
  - `template`: The notification message template key (String)

## Success Criteria

- **SC-001**: Reminders are fired within 60 seconds of their scheduled time.
- **SC-002**: Tapping a notification opens the correct Azkar page in under 1 second.
- **SC-003**: Data persistence is maintained with zero loss across app updates and device restarts.
