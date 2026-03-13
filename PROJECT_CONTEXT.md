# 🌐 Project Context: سَـنَـا (Sana)

## 📖 Overview
**Sana (سَـنَـا)** is a high-performance, modern Islamic companion app built with Flutter. It delivers a premium user experience through cutting-edge software architecture combined with a refined dark aesthetic (glassmorphism, gold accents, and smooth animations).

**Platforms:** Android · iOS · Web  
**Version:** 1.0.0+4  
**Primary Language:** Arabic  

---

## 🏗️ Architectural Foundations

### 1. Clean Architecture (Feature-Based)
Each feature follows a strict layered structure:
- **Data Layer**: `DataSources` (local JSON / remote APIs), `Repositories` (interface + implementation), `Models` (Freezed/JsonSerializable).
- **Presentation Layer**: `Cubit` (state management), `Views` (screens), `Widgets` (reusable components).
- **Domain Layer** (where applicable): `Entities`, `UseCases`, `Repository Interfaces` (e.g., Hadith Search).

### 2. State Management
- **`flutter_bloc`** (Cubit) with **Freezed Sealed States** (`Initial`, `Loading`, `Loaded`, `Error`).
- All states use `@freezed` with code generation for type-safe pattern matching.

### 3. Dependency Injection
- **`GetIt`** for service location with phased initialization.
- **Constructor Injection** enforced — no `sl<T>()` inside logic or data classes.
- Modular DI files per feature: `core_di`, `prayer_di`, `hadith_di`, etc.

### 4. Error Handling
- **`ApiResult<T>`** sealed class: `Success(data)` | `ApiFailure(Failure)`.
- **`Failure`** sealed class: `Server`, `Network`, `Cache`, `Location`, `Sensor`, `MissingData`, `Unknown`.
- **`ErrorMapper`** converts `DioException` → `Failure`.
- Every repository method returns `ApiResult` — no raw exceptions.

### 5. Logging & Crash Reporting
- **`AppLogger`**: Debug mode → formatted console logs. Release mode → **Firebase Crashlytics**.
- **Zero `print()` calls** in the entire codebase.
- **`BlocObserver`** sends all Bloc errors to Crashlytics with full stack traces.
- Global error handlers (Flutter + Platform) configured in `service_locator.dart`.

### 6. Design System
- **Typography**: Cairo (UI), UthmanTaha (Quran) — via FlutterGen.
- **Spacing**: `AppSpacing` constants — eliminates magic numbers.
- **Colors**: `AppColors` curated dark palette with gold accents.
- **Icons**: `SolarIcons` + `FlutterIslamicIcons`.

---

## 🛠️ Tech Stack

| Category | Technology |
| :--- | :--- |
| **Framework** | Flutter (Stable) |
| **State Management** | `flutter_bloc` (Cubit) + `freezed` |
| **Networking** | `Dio` + `Retrofit` (code-generated API clients) |
| **Local Storage** | `Hive` (via `ILocalStorageService` abstraction) |
| **Cloud** | `Firebase Firestore`, `Remote Config`, `Crashlytics`, `Analytics`, `Performance` |
| **Navigation** | `GoRouter` (declarative routing) |
| **Background Tasks** | `Workmanager` (Salat ala Nabi reminders) |
| **Notifications** | `flutter_local_notifications` |
| **Location** | `Geolocator` + Geocoding API |
| **Prayer Calculations** | `adhan` (astronomical prayer time engine) |
| **Quran** | `quran_library` |
| **Asset Generation** | `FlutterGen` (type-safe asset access) |
| **Performance UI** | `Skeletonizer`, `Sliver` system, `AnimatedSliverList` |
| **Live Updates** | `Shorebird` (code push) |
| **Web Hosting** | Vercel |

---

## 🧩 Feature Breakdown

### 🕌 Prayer Times (50 files)
Full prayer time system with 5 specialized services:
- **Engine**: `adhan` library for astronomical calculations.
- **Real-time countdown**: Auto-updates via `Timer` at each prayer transition.
- **Religious events**: Hijri-based event detection (Ramadan, Eid, Ashura, etc.).
- **Prayer status**: Descriptive contextual messages based on current time.
- **User settings**: Calculation method, Madhab, manual adjustments.
- **Lifecycle**: Listens to `LocationCubit` + `AppDateCubit` streams, refreshes on app resume.

### 📖 Quran Reader (3 files)
Clean wrapper around `quran_library` package:
- Full Quran with Uthmanic font rendering.
- Surah, Juz, Hizb navigation.
- Custom dark theme with gold accents.
- Error handling with retry via `AppErrorWidget`.

### 🔍 Hadith Search (30+ files)
Full Clean Architecture with Domain layer:
- **API**: Dorar API via Retrofit-generated client.
- **UseCase**: `SearchHadithUseCase` encapsulates search logic.
- **Pagination**: Infinite scroll with `hasReachedMax` + `isLoadingMore` guards.
- **Favorites**: Local persistence via `ILocalStorageService`.
- **Smart error handling**: Distinguishes network errors from server errors.
- **Web**: Disabled with informational banner (CORS proxy defunct).

### 📿 Azkar (25 files)
Interactive dhikr experience:
- 23 categorized azkar loaded from local JSON with priority sorting.
- Interactive counter with haptic feedback (vibration).
- Debounce protection against rapid taps.
- Optimistic scroll to next dhikr on completion.
- Share and copy support.

### 📰 Daily Content (18 files)
Daily rotating Islamic content:
- Daily Hadith, daily Sunnah, name of the day (Asma ul Husna).
- **Shuffled-rotation algorithm**: Ensures variety without repetition.
- Auto-advances on date change via `AppDateCubit` stream.
- Favorites system with local persistence.

### 🤲 Asma ul Husna (16 files)
99 Names of Allah display:
- Animated Sliver list with expandable meaning cards.
- Share as image, copy to clipboard.
- "Name of the Day" integrated into Daily Content.
- Skeletonizer loading state.

### 🧭 Qibla Finder (23 files)
Compass-based Qibla direction:
- **Algorithm**: Haversine formula for bearing + distance calculation.
- **Sensor**: `flutter_compass` with smooth needle animation.
- Distance to Kaaba display.
- Interactive help dialog.
- **Web**: Disabled with informational banner.

### 📿 Salat ala Nabi — Prayer Reminder (21 files)
Background notification system:
- **`Workmanager`** for periodic background tasks.
- Customizable interval (15 min minimum), working hours, and modes.
- High-priority notification channel with custom Islamic sounds.
- Android 13+ notification permission handling.
- **Web**: Disabled with informational banner.
- **iOS**: Works with `audio` background mode; WorkManager has limited iOS support.

### 📍 Location Manager (12 files)
Central GPS management:
- Permission flow with retry/denial tracking.
- `LocationGuard` widget protects location-dependent screens.
- Silent background location update when stored location exists.
- Reverse geocoding for city/country display.

### 🔄 App Update (13 files)
Remote-controlled update system:
- Firebase Remote Config for version checking.
- Force update overlay + optional update banner.
- Cached config for offline resilience.

### 💬 Feedback (13 files)
In-app feedback system:
- Sends to Firebase Firestore with device metadata.
- Fire-and-forget with Firestore offline persistence.

### 📚 Teaching Prayer (15 files)
Step-by-step prayer instruction:
- Local JSON content parsed via `TeachingContentParser`.
- Section/topic card UI with share support.

### 🛠️ Developer Dashboard (14 files, hidden)
Admin panel for reviewing user feedback:
- Accessible via secret double-tap in settings.
- Firestore-backed with delete capability.

### 🔗 Sharing System (6 files)
Cross-platform sharing:
- Widget-to-image capture via `RenderRepaintBoundary`.
- `share_plus` for uniform platform sharing.

### 📅 App Date (8 files)
Hijri/Gregorian date management:
- Hijri adjustment with user control.
- Day-change detection for content refresh.

---

## 🔒 Coding Standards

- **SOLID Principles**: DIP + SRP strictly enforced.
- **`ApiResult` pattern**: Every repository returns `ApiResult<T>` — no raw exceptions.
- **Crashlytics coverage**: Every `catch` block reports to `AppLogger.error` with full stack traces.
- **Zero `print()`**: All logging via `AppLogger`.
- **Linting**: Strict `analysis_options.yaml` with Flutter recommended rules.

---

## 📂 Directory Structure

```
lib/
├── core/
│   ├── common/       ← Shared widgets (overlays, slivers, cards)
│   ├── constants/    ← AppStrings
│   ├── di/           ← GetIt registration (modular per feature)
│   ├── error/        ← Failure + ErrorMapper
│   ├── networking/   ← Dio, Retrofit, ApiResult, interceptors
│   ├── routing/      ← GoRouter + AppRoutes + AppTransitions
│   ├── services/     ← Analytics, LocalStorage, DeviceInfo, Firebase
│   ├── theme/        ← AppColors, AppSpacing, AppTextStyles
│   └── utils/        ← AppLogger, BlocObserver, formatters
├── features/
│   ├── app_date/
│   ├── app_update/
│   ├── asma_ul_husna/
│   ├── azkar/
│   ├── daily_content/
│   ├── developer_dashboard/
│   ├── feedback/
│   ├── hadith_search/
│   ├── home/
│   ├── location_manager/
│   ├── prayer/
│   ├── qibla/
│   ├── quran/
│   ├── salat_ala_Nabi/
│   ├── sharing/
│   ├── splash/
│   └── teaching_prayer/
└── main.dart
```
