# Notifications

> **Last reviewed:** 2026-11-28
> **Status:** In development

## Purpose & Scope

- **Goal:** Pending confirmation in `spec.md`.
- **Out of scope:** Custom notification sounds, remote push notifications and streak notifications. The phone's default sound is used for every notification.

## Guidelines for consuming features

- The Quran and Azkar features must follow `spec.md` instead of defining their own notification rules.
- Ask for notification and exact alarm permissions with the same check → explanation → request → denied-with-settings flow used by the Qibla location permission.
- Use exact alarms when available and fall back to inexact alarms with a clear explanation.
- Keep the total number of active reminders at or below 30; each feature spec defines its own budget.
- Keep ids unique and stable so edits and deletes cancel the old schedule.
- Guide the user through disabling battery optimization for the app in system settings, with clear steps and a button that opens the settings screen.
- Restore schedules on app start and after `BOOT_COMPLETED`.
- Use the phone's default notification sound and a dedicated channel; never ship a sound file for notifications.

## Decisions

### D-001: One shared notification service
- **Decision:** Define notification rules once in this service and have the Quran and Azkar specs point to it.
- **Reason:** Notifications are a shared service used by more than one feature. [Confirmed]
- **Rejected alternatives:** Repeating permission and scheduling rules in each feature spec.
- **Date:** 2026-11-28
- **Status:** Active

### D-002: Phone's default sound only
- **Decision:** Use the system default notification sound and remove the bundled `salat_ala_nabi_sound_1.mp3`.
- **Reason:** Developer decision on 2026-11-28; no custom sound is needed. [Confirmed]
- **Rejected alternatives:** A custom raw resource sound with a dedicated channel sound.
- **Date:** 2026-11-28
- **Status:** Active

### D-003: Permission UX copied from Qibla
- **Decision:** Reuse the check → rationale → request → denied-with-open-settings pattern from the Qibla location flow.
- **Reason:** Developer decision on 2026-11-28; the pattern is already organized and familiar. [Confirmed]
- **Rejected alternatives:** Letting the system prompt appear with no in-app explanation.
- **Date:** 2026-11-28
- **Status:** Active

### D-004: Minimum 15-minute gap
- **Decision:** Superseded by D-005.
- **Date:** 2026-11-28
- **Status:** Superseded by D-005

### D-005: No enforced gap between reminders
- **Decision:** Do not impose a minimum gap between two reminders.
- **Reason:** The gap did not improve delivery reliability; Android does not require it and the user may need two nearby reminders. [Confirmed]
- **Rejected alternatives:** Rejecting or merging reminders less than 15 minutes apart.
- **Date:** 2026-11-28
- **Status:** Active

### D-006: 30-reminder total budget
- **Decision:** Cap active reminders at 30 across the app; each feature spec defines its own share.
- **Reason:** Leaves room for prayer times, Quran memorization and Azkar while staying far below the 500-alarm limit reported on Samsung devices. [Inferred]
- **Rejected alternatives:** No cap, or a much smaller single-digit cap.
- **Date:** 2026-11-28
- **Status:** Unconfirmed

### D-007: Battery optimization guidance in settings
- **Decision:** Guide the user into the system settings screen to disable battery optimization with clear steps, rather than only showing a tip.
- **Reason:** Developer decision on 2026-11-28; a guided action is more reliable than advice. [Confirmed]
- **Rejected alternatives:** Showing a passive hint, or requesting battery-optimization exemption without explanation.
- **Date:** 2026-11-28
- **Status:** Active

## Tech Debt / Incomplete

- No notification service code has been written yet.
- Azkar defines its own budget: five categories with one reminder each per day. Other consumers define theirs when implemented.
- No screenshots have been captured for the permission states.
