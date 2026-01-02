# Sana Project Documentation

This document provides a comprehensive overview of the **Sana** project execution, architecture, and feature breakdown.

## 1. Project Overview

**Sana** is a holistic Islamic mobile application built with Flutter. It aims to assist Muslims in their daily worship and spiritual life by providing accurate tools for prayer times, Qibla direction, Quran reading, daily Azkar, and self-purification (Tazkiyah).

The application is designed with a modern, premium aesthetic, prioritizing user experience with smooth animations and a clean dark-themed interface.

## 2. Technology Ecosystem

- **Framework:** Flutter (v3.38.4+)
- **Language:** Dart (v3.10.3+)
- **State Management:** `flutter_bloc` (Bloc/Cubit pattern)
- **Dependency Injection:** `get_it`
- **Navigation:** `go_router`
- **Local Storage:** `shared_preferences`
- **Backend/Services:** Firebase (Core, Firestore, Analytics)
- **Calculations:** `adhan` (Prayer Times), `hijri` (Calendar), `geolocator` (Location)
- **UI/Assets:** `flutter_svg`, `lottie`, `animate_do`, `font_awesome_flutter`

## 3. Architecture

The project follows a **Feature-First / Clean Architecture** structure, ensuring modularity and scalability.

### Folder Structure (`lib/`)

- **`core/`**: Contains shared resources accessed across the entire application.

  - **`common/`**: Reusable UI widgets and logic (e.g., custom buttons, cards).
  - **`constants/`**: Global constants (API keys, asset paths, configuration values).
  - **`di/`**: Dependency Injection setup (`service_locator.dart`).
  - **`error/`**: Custom error handling classes and failure definitions.
  - **`routing/`**: Navigation configuration (`app_router.dart`).
  - **`services/`**: Infrastructure-level services (Location, Network, Audio, Date/Time).
  - **`theme/`**: Theme definitions (colors, typography, styles).
  - **`utils/`**: Helper functions and extensions.

- **`features/`**: Contains the feature-specific code. Each feature folder typically follows a micro-architecture:
  - **`presentation/`**: Widgets, Screens, and Cubits/Blocs.
  - **`domain/`**: Entities and Usecases (Business Logic).
  - **`data/`**: Models, Data Sources, and Repositories.

## 4. Feature Breakdown

### 4.1. Core Features

- **Prayer Times (`features/prayer`)**

  - Calculates accurate prayer times based on user location.
  - Supports multiple calculation methods.
  - Displays "Next Prayer" countdown.
  - Location handling via `LocationCubit`.

- **Quran (`features/quran`)**

  - Full Quran reading experience.
  - Utilizes `quran_library` package.
  - Future: Audio recitations, memorization tools.

- **Azkar (`features/azkar`)**

  - Daily Athkar (Morning, Evening, Sleep, etc.).
  - Electronic Tasbeeh counter.
  - Customizable texts and sharing options.

- **Qibla (`features/qibla`)**
  - Compass interface pointing to the Kaaba.
  - Uses device magnetometer sensors.

### 4.2. Engagement Features

- **Daily Content (`features/daily_content`)**

  - Displays a "Hadith of the Day" or "Sunnah of the Day".
  - Rotates content daily.
  - Allows favoriting and history viewing.

- **Tazkiyah (`features/tazkiyah`)**

  - Focuses on self-purification ("Mahlikat" - Destructive traits).
  - Displays cards with Quranic verses and Hadiths related to moral improvement.
  - Shareable content cards.

- **Asma Ul Husna (`features/asma_ul_husna`)**

  - List of the 99 Names of Allah with meanings.
  - Beautiful UI presentation.

- **Salat Ala Nabi (`features/salat_ala_Nabi`)**

  - Reminders and counters for sending blessings upon the Prophet (PBUH).

- **Teaching Prayer (`features/teaching_prayer`)**
  - Step-by-step guides for performing Salah.

### 4.3. App Structure Features

- **Home (`features/home`)**
  - Main dashboard aggregating key info (Next Prayer, Daily Content, Quick Access).
- **Splash (`features/splash`)**
  - Initial loading screen with branding.
- **Report (`features/report`)**
  - Feedback mechanism for users.

## 5. State Management & Data Flow

The application uses **Cubit** for state management.

1.  **UI (Widget)**: Listens to state changes and dispatches events/methods to the Cubit.
2.  **Cubit**: Handles business logic, calls UseCases or Repositories.
3.  **Repository**: distincts data sources (Local vs Remote).
4.  **Data Source**: Fetches raw data (API, DB, SharedPrefs).

**Global Providers** (defined in `main.dart`):

- `LocationNameCubit`: Manages reverse geocoding of user location.
- `AppDateCubit`: Centralized time source (replaces raw `DateTime.now()`).
- `LocationCubit`: Manages GPS permission and coordinates.
- `PrayerTimesCubit`: Computes and updates prayer times.
- `DailyContentCubit`: Manages daily Hadith/Sunnah rotation.

## 6. Setup & Development

### Prerequisites

- Flutter SDK: `3.38.4` (or compatible)
- Dart SDK: `3.10.3` (or compatible)
- Firebase Project (configured via `flutterfire`)

### Initialization

The `main()` function ensures critical services are ready before app launch:

1.  `WidgetsFlutterBinding.ensureInitialized()`
2.  `initializeApp()`: Sets up DI, Firebase, Notifications, etc.
3.  `runApp(SanaApp)`: Mounts the widget tree.
4.  `initializeAppPostFrame()`: Initializes heavier background tasks (optional).

## 7. Configuration Files

- `pubspec.yaml`: Dependency management.
- `analysis_options.yaml`: Linting rules for code quality.
- `lib/core/di/service_locator.dart`: Central registry for `GetIt` injections.
- `lib/core/routing/app_router.dart`: Route definitions for `GoRouter`.

## 8. Roadmap & Future

- **Quran Audio**: Full implementation of audio playback.
- **Localization**: Full English support (currently structure exists, primary content is Arabic).
- **Widgets**: Home screen widgets for Android/iOS.
