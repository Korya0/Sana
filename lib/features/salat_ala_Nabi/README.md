# Salat Ala Nabi Feature

## Overview
Reminders and tracking for sending blessings upon the Prophet (PBUH).

## Features
- **Periodic Reminders**: Configurable notifications.
- **Background Execution**: Works even when the app is closed using `Workmanager`.
- **Custom Sounds**: Unique notification sound for Salawat.

## Technical Details
- Uses `flutter_local_notifications` for alerts.
- `Workmanager` handles background tasks during specific hours.
- Configurable range (start/end hours) to respect user sleep time.
