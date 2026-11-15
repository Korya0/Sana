# Naming Rules

## 1. Files & folders

| Element | Convention | Example |
|---|---|---|
| Dart file | `snake_case.dart` | `prayer_times_cubit.dart` |
| Feature folder | `snake_case` | `salat_ala_nabi/` |
| Data folders | `repositories/` · `data_sources/` · `models/` · `mappers/` · `services/` · `constants/` | — |
| Domain folders | `entities/` · `repositories/` · `use_cases/` · `params/` · `validators/` · `enums/` | — |
| Presentation folders | `cubits/` · `views/` · `widgets/` | — |
| DI file | `<feature>_di.dart` | `qibla_di.dart` |
| Asset | `snake_case`, inside a category folder | `assets/images/logo.png` |
| Generated file | follows its generator's convention; never edit by hand | `*.g.dart` |
| Test | `<file>_test.dart` | `prayer_times_cubit_test.dart` |

- Write `repositories`, not `repos`.

## 2. Classes

`PascalCase`. An implementation defaults to `<Contract>Impl`; a descriptive name is
allowed only when it clarifies the technology (`FirebaseAnalyticsServiceImpl`,
`FirestoreDatabaseClient`).

| Element | Rule | Example |
|---|---|---|
| Screen-level view | `View` suffix, never `Screen` | `PrayerTimesView` |
| Widget | named by responsibility; `Widget` suffix not required | `PrayerCard` |
| Cubit | `Cubit` suffix | `PrayerTimesCubit` |
| State | `<Feature>State`, variants `extends` it | `PrayerTimesState` → `PrayerTimesLoaded` |
| Entity | `Entity` suffix | `PrayerTimeEntity` |
| Model | `Model` suffix | `PrayerTimeModel` |
| Repository | no `I`, full `Repository`, impl `Impl` | `QiblaRepository` → `QiblaRepositoryImpl` |
| Data source | no `I`, `Local`/`Remote` + `DataSource`, impl `Impl` | `QiblaLocalDataSource` → `QiblaLocalDataSourceImpl` |
| Use case | `UseCase` suffix | `GetQiblaDirectionUseCase` |
| Service | no `I`, `Service` suffix, impl `Impl` | `AnalyticsService` → `AnalyticsServiceImpl` |
| Constant / theme class | `App` prefix | `AppSize`, `AppTextStyles` |
| ThemeExtension | `App` prefix for new classes | `AppColors` |
| DI function | `setup<Name>Dependencies(GetIt sl)` | `setupQiblaDependencies(sl)` |
| Route class | `PascalCase` | `AppRouter`, `AppRoutes` |
| API client | `ApiClient` suffix | `LocationApiClient` |
| Interceptor | `Interceptor` suffix | `AuthInterceptor` |

- Existing `My*` names stay until deliberately renamed.
- Use an abstract contract (and an `Impl`) only when substitution or testing
  requires it.
- States: don't force four — allow the real conditions (empty, pagination,
  playback …). `Loaded` and `Success` are not interchangeable.

## 3. Variables & identifiers

- **Private:** `_lowerCamelCase` — `_repository`, `_box`.
- **Variables, functions, getters, parameters:** `lowerCamelCase`; a function
  starts with a verb — `calculateNextPrayer()`.
- **Boolean:** reads as a condition — `isEnabled`, `hasReminder`, `canPlayAudio`.
- **Constant:** `lowerCamelCase`, never `UPPER_SNAKE_CASE` — `defaultPageSize`.
  `const` for compile-time, `final` for assigned once at runtime.
- **Route path:** `kebab-case` string — `'/prayer-times'`; its Dart holder is
  `lowerCamelCase` — `prayerTimesPath`.
- **Storage key:** `snake_case` — `hijri_adjustment`. Renaming a key breaks access
  to already-stored data.
- **Enum:** type `PascalCase`, values `lowerCamelCase` — `PrayerType.fajr`.
- **Mixin / extension / typedef:** `PascalCase` — `DateTimeFormatting`,
  `PrayerTimeCallback`.

## 4. Constructor

- A static-only utility class uses a private constructor to prevent
  instantiation:

```dart
class AppSize {
  AppSize._();

  static double get p16 => _scaled(16);
}
```

- An instantiable class gets a private constructor only for a specific reason.
