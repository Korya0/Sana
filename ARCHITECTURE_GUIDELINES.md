# Universal Flutter Architecture Constitution (The Sana Blueprint)

This document defines the strict architectural standards for this and all future projects. It is designed to ensure scalability, maintainability, and zero human error.

## 1. Core Architecture Pattern
- **Pattern:** Clean Architecture (Simplified).
- **Layers:** 
  - **Data Layer:** Repositories, DataSources, Models (Code-generated).
  - **Logic Layer:** Cubits (State management via Freezed).
  - **Presentation:** UI Widgets (Purely visual, consuming Cubit states).
  - **Domain (Optional):** Use only for complex business logic to avoid over-engineering.

## 2. Tech Stack & Tools (The Golden Standards)
- **Navigation:** `GoRouter` (Declarative system with deep linking support).
- **Networking:** `Retrofit` (Built on Dio) for all API calls.
- **Serialization:** `json_serializable` for all Models.
- **State Management:** `Flutter_Bloc` (Cubit) + `Freezed`.
- **DI:** `GetIt` (Phased initialization).
- **Assets:** `flutter_gen` (No hardcoded asset paths).

## 3. Error Handling Pattern: ApiResult
We abandon generic exceptions in favor of the **Sealed Result Pattern**.
```dart
@Freezed()
abstract class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(Failure failure) = ApiFailure<T>;
}
```
*Every repository method must return an `ApiResult`.*

## 4. Coding Standards (No Compromise)

### Dependency Injection (DIP)
- Cubits MUST depend on Interfaces (e.g., `ILocationRepository`), NEVER on concrete implementations.
- Register all dependencies in `service_locator.dart` using appropriate lifecycles (`LazySingleton` vs `Factory`).

### State Modeling
- High-level states MUST use `freezed` sealed classes.
- Use `switch` or `map` in the UI to handle `initial`, `loading`, `success`, and `error` states. This ensures 100% case coverage.

### Design Tokens (Spacing & Typography)
- Prohibited: Hardcoded numbers (`16.0`) or colors (`Colors.blue`).
- Requirement: Use predefined constants from `AppSpacing`, `AppColors`, and `AppTextStyles`.
- Responsiveness: Use `Expanded`, `Flexible`, and `LayoutBuilder` for maximum performance. Use `ScreenUtil` only if explicitly required for complex layouts.

## 5. Project Organization & Modularization
- **Internal Packages:** Core logic should be extracted into internal Dart packages (e.g., `packages/core_ui`, `packages/api_service`) to ensure reusability across multiple projects.
- **Folder Structure:** 
  - `core/`: Global utilities, themes, and networking.
  - `features/`: Divided by domain (feature-based structure). Each feature has `data/`, `logic/`, and `presentation/`.

## 6. Quality Assurance (Testing & Linting)
- **Unit Testing:** All Repositories and Cubits must have unit tests covering the core logic.
- **Linting:** Use a strict `analysis_options.yaml` that enforces:
  - Strong Types.
  - Required Doc Comments for core utilities.
  - Sorting imports.
  - No "Magic Numbers".

## 7. Deployment & Maintenance
- **Shorebird:** All refactors must consider patch compatibility (avoid breaking native changes mid-release cycle).
- **Logging:** Use `AppLogger` for all production debugging. NEVER use `print`.
