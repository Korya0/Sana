# 🔔 PLUGIN: NOTIFICATIONS (FCM & LOCAL)
> **Version:** 1.0.0 | **Author:** Antigravity (Senior Partner)
> **Target:** 100% Delivery rate across Foreground, Background, and Terminated states.

## 🏛️ CORE PHILOSOPHY
Notifications are highly invasive. Apple and Android 13+ treat them as extreme privileges. Asking blindly at app launch results in a 80% rejection rate.

---

## 🛠️ NOTIFICATION PROTOCOL
- **Contextual Request:** Ask for the `Permission.notification` (using F9) only AFTER explaining the value (e.g. "To get updates on your grocery delivery").
- **FCM Architecture:** 
  1. `FirebaseMessaging.onMessage`: Handles notifications while the app is active (Foreground). Must manually trigger a local notification to appear as a Snackbar/Toast.
  2. `FirebaseMessaging.onBackgroundMessage`: Handles Terminated/Background. MUST be a `@pragma('vm:entry-point')` top-level function. **Cannot** access UI or local singletons.

## 🔔 FLUTTER LOCAL NOTIFICATIONS
- **Initialization:** Must initialize separately for Android and iOS using `FlutterLocalNotificationsPlugin`.
- **Channels (Android):** Apps targeting Android 8+ MUST declare `AndroidNotificationChannel`. Create a `"high_importance_channel"` for alarms, and a `"silent_channel"` for data updates.
- **Payload Handling:** Extract the click payload inside `onDidReceiveNotificationResponse`. Use the Router (E - Navigation layer) to parse string payloads identifying deep linking (e.g., redirect to `/chat/123`).
