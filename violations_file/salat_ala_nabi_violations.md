# 🕵️ Architectural Audit: `salat_ala_nabi` Feature

**Status**: ⚠️ Violations Detected
**Feature Tier**: Tier 2 (Simplified Clean Architecture: Data → Presentation)

---

### 🚨 Critical Severity

| Violation | File | Line | Rule Reference | Required Action |
| :--- | :--- | :--- | :--- | :--- |
| **Direct Service Orchestration in Cubit** | `lib/features/salat_ala_nabi/presentation/cubit/reminder_cubit.dart` | 154-162 | **SRP (Single Responsibility Principle)** & Section A (19) | The Cubit is directly handling the initialization and configuration of the `INotificationService`. This leaks infrastructure implementation details into the presentation logic. |
| | | | | **Fix**: Extract a method into the Repository or a dedicated Feature Service to handle the specific "Show Reminder" logic, keeping the Cubit focused on state. |

---

### 🔴 High Severity

| Violation | File | Line | Rule Reference | Required Action |
| :--- | :--- | :--- | :--- | :--- |
| **Magic Numbers in Business Logic** | `lib/features/salat_ala_nabi/presentation/cubit/reminder_cubit.dart` | 106, 108 | Section F: **DON'T use magic numbers** | Hardcoded hours `9` and `17` are used directly in the code to define "Default Hours". |
| | | | | **Fix**: Move these values to `AppSalawatConstants` (e.g., `defaultStartHour`, `defaultEndHour`). |
| **Platform Logic Leakage** | `lib/features/salat_ala_nabi/presentation/cubit/reminder_cubit.dart` | 228-230 | Section A: **Presentation has ZERO business logic** | Cubit directly checks `defaultTargetPlatform` and Android SDK version (`_deviceInfoService.getAndroidSdkInt()`). |
| | | | | **Fix**: Encapsulate platform-specific requirements (like SDK version checks for notifications) inside the `IAppPermissionsManager` implementation. |
| **Magic Number in Cancellation** | `lib/features/salat_ala_nabi/presentation/cubit/reminder_cubit.dart` | 222 | Section F: **DON'T use magic numbers** | `_notificationService.cancel(0)` uses a hardcoded `0` as a notification ID. |
| | | | | **Fix**: Define this as a constant in `AppSalawatConstants`. |

---

### 🟡 Medium Severity

| Violation | File | Line | Rule Reference | Required Action |
| :--- | :--- | :--- | :--- | :--- |
| **Hardcoded Asset Reference** | `lib/features/salat_ala_nabi/data/salawat_constants.dart` | 4 | Section F: **DO use type-safe asset references** | `soundFileName = 'salat_ala_nabi_sound_1'` is a raw string. |
| | | | | **Fix**: Use `Assets.audio.salatAlaNabiSound1.path` (or managed via `Assets` class) to ensure type-safety. |
| **Build Logic Complexity** | `lib/features/salat_ala_nabi/presentation/widgets/working_hours_widget.dart` | 106 | Section C (9): **Stateless as possible** | Logic like `final cubit = settings == this.settings ? null : context.read<ReminderCubit>();` exists inside `build` to determine behavior for skeleton state. |
| | | | | **Fix**: Pass necessary callbacks and state flags explicitly from the parent view instead of performing logic inside `build`. |

---

### 🟢 Low Severity / Hygiene

| Violation | File | Line | Rule Reference | Required Action |
| :--- | :--- | :--- | :--- | :--- |
| **Inconsistent Spacing Usage** | `lib/features/salat_ala_nabi/presentation/widgets/salat_ala_nabi_view_content.dart` | 36, 40, 44 | Section C (137): **Always use spacing tokens** | Uses `AppSpacing.v18 * 2`. While using tokens, the multiplication creates ad-hoc values not defined in tokens. |
| | | | | **Fix**: Check if a larger token exists (e.g., `AppSpacing.v32`) or define a new token if this spacing is standard across the app. |

---

**Audit Summary**: The feature follows the Tier 2 structure well, but suffers from "Logic Bloat" in the Cubit and several magic numbers. Fixing these will bring it to 100% compliance.
