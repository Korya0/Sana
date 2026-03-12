# Sana Project: Architecture & Development Guidelines

This document serves as the "Source of Truth" for the architecture and coding standards of the Sana Project. All current and future features must adhere to these rules.

## 1. Core Principles

### SOLID Adherence
- **SRP (Single Responsibility):** Each class must have one job. Separate UI, Business Logic (Cubit), and Data (Repository).
- **DIP (Dependency Inversion):** High-level modules (Cubits) must not depend on low-level modules (Repositories). Both must depend on abstractions (Interfaces).
- **Reusable UI:** Common widgets (buttons, cards, dialogs) must be stored in `core/common` and reused across features.

## 2. Dependency Injection (GetIt)

We use a phased initialization strategy in `service_locator.dart`.

### Registration Types
- **registerLazySingleton:** Use for global services, Repositories, and Cubits that need to persist state across the app (e.g., `LocationCubit`, `DailyContentCubit`).
- **registerFactory:** Use for Cubits that are screen-specific and should be reset whenever the screen is closed (e.g., `HadithSearchCubit`).
- **registerSingletonAsync:** Use for services requiring `await` during initialization.

### Phased Startup
1. **Critical Parallel Launch:** `Firebase`, `Locator`, `Orientations`, and `Locale` must start in a `Future.wait` to minimize splash screen time.
2. **Post-Frame Init:** Non-critical heavy services (Background tasks, warm-ups) must run after the first frame renders to ensure a snappy user experience.

## 3. Data Layer Pattern

Every Repository MUST follow this structure:
1. **Interface:** An abstract class `I[Feature]Repository`.
2. **Implementation:** A concrete class `[Feature]RepositoryImpl`.
3. **Registration:** Always register the Interface in GetIt:
   ```dart
   sl.registerLazySingleton<I[Feature]Repository>(() => [Feature]RepositoryImpl(sl()));
   ```

## 4. Sharing & Interaction

### Global Sharing System
- Use `WidgetToImage.shareWidget` for any widget-to-image sharing.
- All shareable widgets should be wrapped in `ShareCardContainer` to enforce established constraints (500x800) and prevent rendering errors.
- Always use `Directionality.of(context)` instead of hardcoded `RTL` to support future localization.

## 5. UI & Aesthetics
- **Premium Design:** Use only curated color palettes from `AppColors`. No browser defaults.
- **Animations:** Follow the established patterns in `core/common/animations`. Every list should use `AnimatedSliverList`.
- **Haptics:** Use haptic feedback for long-press actions to enhance the premium feel.

## 6. Development Workflow
- **No Over-Engineering:** Keep solutions simple and maintainable.
- **Shorebird Compatibility:** Avoid unnecessary native changes or heavy dependency swaps that might break patch compatibility.
- **Logging:** Use `AppLogger` for all errors and info. Never use `print`.
