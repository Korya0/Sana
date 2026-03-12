# 🌐 Project Context: سَـنَـا (Sana)

## 📖 Overview
**Sana (سَـنَـا)** is a high-performance, modern Islamic companion application built with Flutter. It aims to provide a premium user experience by combining cutting-edge software architecture with a refined aesthetic (vibrant dark modes, glassmorphism, and smooth animations).

The project is designed with **Scalability** and **Maintainability** as core priorities, adhering to a strict "Blueprints" system for architecture and design tokens.

---

## 🏗️ Architectural Foundations

### 1. Clean Architecture (Modified)
The project follows a feature-based Clean Architecture structure to decouple business logic from the UI.
- **Data Layer**: 
    - `DataSources`: Handles raw data from APIs (Dorar, Religious APIs) or local storage (SharedPreferences).
    - `RepositoriesImpl`: Implements the domain interfaces, handling error mapping and data flow.
    - `Models`: Data transfer objects with JSON serialization logic.
- **Logic Layer (BLoC/Cubit)**:
    - Independent controllers for each stateful UI segment.
    - **Sealed States Pattern**: Uses sealed classes (Manual implementation for Shorebird compatibility) to represent UI states (`Initial`, `Loading`, `Loaded`, `Error`).
- **Presentation Layer**:
    - **Views**: Main screens composed of slivers for high-performance scrolling.
    - **Widgets**: Reusable, atomic UI components.
    - **Skeletonizer**: Integrated for professional loading states.

### 2. Dependency Injection (DI)
- Power by `GetIt` for service location.
- **Phased Initialization**: `setupLocator()` handles the registration of core services, then feature-specific dependencies in a modular fashion (`core_di`, `prayer_di`, etc.).
- **Constructor Injection**: Strict rule—no `sl<T>()` inside logic or data classes.

### 3. Design System & Tokens
- **Typography**: Uses custom font families—**Cairo** (Main) and **UthmanTaha** (Quranic text).
- **Spacing**: Centralized in `AppSpacing` to eliminate "Magic Numbers".
- **Colors**: Curated palette in `AppColors` supporting a premium Dark Mode.
- **Icons**: Standardized on `SolarIcons` and `FontAwesome`.

---

## 🛠️ Tech Stack & Key Integrations

| Category | Technology / Library |
| :--- | :--- |
| **Framework** | Flutter (Stable Channel) |
| **State Management** | `flutter_bloc` (Cubit) |
| **Networking** | `Dio` + `Retrofit` (Planned/Transitioning) |
| **Database** | `Firebase Firestore` + `SharedPreferences` |
| **Navigation** | `GoRouter` (Declarative Routing) |
| **Background Tasks** | `Workmanager` (For Salat-ala-Nabi reminders) |
| **Localization** | Arabic (Primary) / English (Planned) |
| **Performance** | `Skeletonizer`, `Sliver` system, `AnimatedSliverList` |
| **Analytics/Ops** | `Firebase Crashlytics`, `Remote Config`, `Sentry` |
| **Deployment** | `Shorebird` (Code Push), `Vercel` (Web Hosting) |

---

## 🧩 Feature Breakdown

### 🕌 Prayer Times & Religious Events
- **Engine**: `Adhan` library for astronomical calculations.
- **Location**: `Geolocator` + `Geocoding` for automatic city/country detection.
- **Lifecycle**: Real-time countdown to next prayer via `Timer` within `HomePrayerHeader`.

### 🔍 Hadith Search (Dorar API Integration)
- Connects to the Dorar API to fetch authenticated Hadiths.
- **Features**: Pagination (Lazy loading), HTML parsing for clean text, and a localized favorites system using `ISharedPref` (DIP).

### 📿 Salat-ala-Nabi (Advanced Reminders)
- Uses `Workmanager` to schedule periodic tasks in the background.
- **Modes**: 24-hour, Default (10am-10pm), and Custom intervals.
- **Notification**: High-priority alert channels with custom Islamic sounds.

### 📖 Holy Quran
- Utilizes `quran_library` for metadata.
- **Rendering**: Uthmanic font rendering with SVG decorative elements.
- **Logic**: Searchable indexing and reading history.

### 🧭 Qibla Finder
- Uses `flutter_compass` and device sensors.
- Implements a low-pass filter for smooth needle movement.

---

## 🔒 Coding Standards & Compliance

- **SOLID Principles**: Strict adherence to Dependency Inversion (DIP) and Single Responsibility (SRP).
- **Shorebird-Safe Evolution**: Avoiding code-generation (`freezed`, `json_serializable`) where it might conflict with dynamic patching, favoring manual but robust implementations.
- **Linting**: Controlled by `analysis_options.yaml` (Strict typing, no magic numbers).
- **Error Handling**: Use of `Either<Failure, T>` from `dartz` to force error handling at the call site.

---

## 🚀 DevOps & Deployment Pipelines

- **Web Rendering**: Optimized via `vercel.json` for SPA routing.
- **Native Splash**: Customized via `flutter_native_splash.yaml`.
- **Hotfixes**: Integrated with `Shorebird` for instantaneous logic fixes without app store re-submissions.

---

## 📂 Directory Map (Highlights)
- `lib/core/di/`: The "Heart" of the app, wiring all components.
- `lib/core/common/`: Shared UI components (Overlays, Sliders, Slivers).
- `lib/features/`: Domain-specific folders containing the logic and views.
- `assets/json/`: Local data storage for Azkar and static religious content.
