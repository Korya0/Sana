# Spec: Notifications

> **Status:** In progress
> **Created:** 2026-11-28
> **Note:** This is a shared service, not a user-facing feature. The Quran and Azkar specs must follow the rules in this document instead of redefining their own notification behavior. Requirements start unchecked until the service is implemented and verified.

## Goal
Pending: proposed wording, awaiting developer confirmation.

---

## Part 1: Permissions

- [ ] Before the first notification is scheduled, the app requests the phone's notification permission.
- [ ] Before requesting a permission, the app shows a short screen that explains why it is needed and what the user must do.
- [ ] When a permission is denied, the app shows clear steps and offers a button that opens the system settings.
- [ ] The permission flow follows the same pattern as the location permission in the Qibla feature.
- [ ] The app checks whether exact alarms are available before scheduling an exact reminder.
- [ ] When exact alarms are unavailable, the app explains the limitation in plain language.
- [ ] When the user grants exact alarm permission from settings, the app reschedules its notifications immediately.
- [ ] When the user revokes the permission, the app switches to the inexact mode and tells the user.

---

## Part 2: Scheduling

- [ ] The app uses exact alarms when the permission is granted.
- [ ] The app falls back to inexact alarms when the permission is not granted.
- [ ] Each scheduled notification has a unique, stable id.
- [ ] Editing a reminder replaces the old schedule for that id.
- [ ] Deleting a reminder cancels its schedule.
- [ ] The app keeps the total number of active reminders at or below 30.
- [ ] Each feature spec defines its own reminder budget within that total.
- [ ] The app guides the user through disabling battery optimization for the app in system settings, with clear steps and a button that opens the right settings screen.
- [ ] The app restores all active reminders after a device restart.
- [ ] The app restores all active reminders when the app is opened.
- [ ] Reminder times are stored in local time and recalculated across time zone and daylight-saving changes.

---

## Part 3: Presentation

- [ ] Every notification uses the phone's default notification sound.
- [ ] The app does not add or ship a custom notification sound.
- [ ] Notifications are delivered through a dedicated channel.
- [ ] Notification title and message are written in Modern Simplified Fusha in `AppStrings`.
- [ ] Tapping a notification opens the screen that owns the reminder.

---

## Part 4: Quality assurance

- [ ] Verify that every notification service file has complete unit and widget test coverage.
- [ ] A full integration test suite covers permission, scheduling, cancellation and rescheduling flows.
- [ ] Verify behavior on a Samsung device with battery saver on and off.
- [ ] Verify behavior after a device restart and after a permission change in system settings.
- [ ] Verify complete responsiveness of every permission screen and notification-related dialog.
- [ ] Capture screenshots for every permission state and dialog, store them under `screenshots/notifications/`, and reference them in the root `README.md` and `docs/features/notifications/README.md`.
- [ ] Review all related docs and READMEs before closing the service.

---

## Out of Scope

Decided by the developer; not part of this spec for now.

- A custom sound shipped with the app (the phone's default sound is used instead).
- Remote or push notifications.
- Notification sounds other than the phone's default.
- Streak notifications.

## Open Questions

- **Notification time:** What fixed time should daily review and ward notifications be sent? Current assumption: a developer-set time.
