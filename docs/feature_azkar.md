# Azkar Feature Documentation

## Overview

The Azkar feature allows users to browse categories of Islamic remembrances (أذكار) and interact with individual azkar items through a tap-based counter.

**What it does:**
- Displays a list of azkar categories (e.g., أذكار الصباح, أذكار المساء, أذكار النوم)
- Opens a scrollable list of azkar items when a category is selected
- Each zikr item shows its Arabic text, optional description/reference, and a circular counter
- Users tap or long-press on a zikr card to increment its counter
- When a zikr's count reaches its target, the card fades/scales down and the list auto-scrolls to the next incomplete item
- When all azkar in a category are completed, a toast is shown and the view auto-pops after 500ms
- If the user tries to exit mid-progress, a confirmation dialog asks whether to leave
- Users can share a zikr as a styled image card or copy its text to the clipboard
- Users can customize their reading experience by adjusting the font size via a settings bottom sheet

**Data source:** Local JSON files bundled as app assets, cached into Hive boxes with versioned migration.

---

## Architecture

Three layers inside `azkar/`, with dependencies pointing inward toward Domain:

```
            Domain
   (Entities, UseCases, Contracts)
            ▲
            |
 ┌──────────┴──────────┐
 |                     |
Presentation          Data
(Cubits, UI)    (Models, Repository Impl)
```

- **Presentation depends on Domain:** `AzkarCubit` calls `GetAzkarByCategoryUseCase` and receives `ZikrEntity`. It never imports anything from Data.
- **Data depends on Domain:** `AzkarRepositoryImpl` implements `IAzkarRepository`. `CategoryModel` extends `CategoryEntity`, `ZikrModel` extends `ZikrEntity`.
- **Domain depends on nothing:** `IAzkarRepository`, entities, and use cases have zero imports from Presentation or Data. No Flutter imports.

### Presentation
Responsible for UI rendering and user interaction.
Contains Cubits (`AzkarCubit`, `AzkarCategoriesCubit`) for state management and Widgets for display.
Cubits receive use cases via constructor injection and work only with domain entities and the `Result` type.

### Domain
Contains business rules and contracts.
Defines entities (`CategoryEntity`, `ZikrEntity`), use cases (`GetCategoriesUseCase`, `GetAzkarByCategoryUseCase`), and the repository interface (`IAzkarRepository`).
The repository interface lives here so that Use Cases can depend on it without knowing the Data layer implementation.

### Data
Responsible for retrieving raw data from bundled JSON assets and persisting it in Hive.
Contains the data source interface and implementation (`IAzkarLocalDataSource` → `AzkarLocalDataSourceImpl`), models (`CategoryModel`, `ZikrModel`), repository implementation (`AzkarRepositoryImpl`), and string constants (`AzkarConstants`).
Models extend entities directly (`CategoryModel extends CategoryEntity`), so the repository returns models as entities without a separate mapping step.

---

## Folder Structure

```
lib/features/azkar/
├── data/
│   ├── constants/        # Hive box names, JSON key strings
│   ├── datasources/      # Interface + implementation for local data access
│   ├── models/           # CategoryModel, ZikrModel (extend domain entities, add fromJson)
│   └── repositories/     # AzkarRepositoryImpl (implements IAzkarRepository)
│
├── domain/
│   ├── entities/         # CategoryEntity, ZikrEntity, ReadingSettings
│   ├── repositories/     # IAzkarRepository, IReadingSettingsRepository
│   └── usecases/         # GetCategoriesUseCase, GetAzkarByCategoryUseCase, GetReadingSettingsUseCase, UpdateReadingSettingsUseCase
│
└── presentation/
    ├── cubits/
    │   ├── azkar/             # AzkarCubit + AzkarState + ZikrIncrementResult
    │   ├── categories/        # AzkarCategoriesCubit + AzkarCategoriesState
    │   └── reading_settings/  # ReadingSettingsCubit + ReadingSettingsState
    ├── utils/            # CategoryIconMapper (category ID → icon)
    ├── views/            # AzkarListView (main screen), ReadingSettingsBottomSheet, FontSizeSection
    └── widgets/          # ZikrItemCard, ZikrCounter, ZikrShareCard, skeleton loader
```

**Where to add future changes:**

| Change | Location |
|--------|----------|
| New data field (e.g., audio URL) | Add to `ZikrEntity` → update `ZikrModel.fromJson` → update `AzkarConstants` keys |
| New data source (e.g., remote API) | Add new interface in `domain/repositories/` and implementation in `data/datasources/` |
| New business rule (e.g., filter by reference) | Add new use case in `domain/usecases/` |
| New UI screen (e.g., favorites view) | Add new view in `presentation/views/`, new cubit in `presentation/cubits/` |
| New widget (e.g., audio player) | Add in `presentation/widgets/` |

### Dependency Injection

Registered in [`azkar_di.dart`](file:///d:/flutter/flutter_Projects/muslim_app/lib/core/di/azkar_di.dart) (`core/di/`) using `get_it`:

| Registration | Type | Reason |
|-------------|------|--------|
| `IAzkarLocalDataSource` → `AzkarLocalDataSourceImpl` | lazySingleton | One Hive connection shared across the app |
| `IAzkarRepository` → `AzkarRepositoryImpl` | lazySingleton | Holds `_isReady` flag, must persist across calls |
| `GetCategoriesUseCase` | lazySingleton | Stateless, reusable |
| `GetAzkarByCategoryUseCase` | lazySingleton | Stateless, reusable |
| `GetReadingSettingsUseCase` | lazySingleton | Stateless, reusable |
| `UpdateReadingSettingsUseCase`| lazySingleton | Stateless, reusable |
| `AzkarCategoriesCubit` | factory | Fresh state each time the categories screen opens |
| `AzkarCubit` | factory | Each azkar list screen needs its own independent counters |
| `ReadingSettingsCubit` | factory | Loaded when settings are opened or text size is needed |

---

## Data Flow

### Loading Azkar

**Architecture flow:**

```
Widget → Cubit → UseCase → Repository Interface → Repository Impl → DataSource → Result → Cubit State → UI
```

**Detailed steps:**

```
User taps category
       ↓
AzkarListView (creates AzkarCubit via sl<AzkarCubit>())
       ↓
AzkarCubit.loadAzkar(categoryId)
       ↓
  emits AzkarLoading
       ↓
GetAzkarByCategoryUseCase.call(categoryId)
       ↓
IAzkarRepository.getAzkarByCategory(categoryId)
       ↓
AzkarRepositoryImpl
       ↓
AzkarLocalDataSourceImpl
       ↓
returns List<ZikrModel>
       ↓
Result.success(models) → AzkarCubit
       ↓
AzkarCubit emits final state
       ↓
AzkarListContent (BlocBuilder) renders UI
```

**Implementation details inside the Data layer:**

- **Versioned migration:** `_ensureReady()` runs once per session. Compares the `version` field from `assets/azkar_version.json` against the version stored in Hive's `azkar_metadata_box`. If the asset version is newer, it reloads categories and deletes stale category boxes from disk.
- **Lazy category loading:** `getAzkarByCategory(id)` opens Hive box `azkar_category_{id}`. If the box is empty, it loads the corresponding JSON file from assets, parses it into `ZikrModel` objects, and saves them to Hive. Subsequent calls read directly from Hive.
- **No manual mapping:** `ZikrModel extends ZikrEntity`, so the repository returns models directly as entities via `Result.success(models)`.

---

### Counter Interaction

**Architecture flow:**

```
Widget → Cubit (local state only) → Cubit State → UI
```

Counter updates are **purely local state changes**. They never leave the Presentation layer — no UseCase, Repository, or DataSource is involved. The Cubit holds a `Map<int, int>` of `{zikrId: currentCount}` in memory and updates it synchronously.

**Detailed steps:**

```
User taps ZikrItemCard
       ↓
_handlePress() debounces (200ms) → triggers haptic vibration
       ↓
AzkarCubit.incrementZikr(zikrId)
  → synchronous, returns ZikrIncrementResult immediately
       ↓
If currentCount < zikr.count:
  → creates new counters map with count + 1
  → emits AzkarLoaded with updated counters
  → returns ZikrCompleted (if reached target) or ZikrIncremented
       ↓
ZikrItemCard receives result synchronously:
  → ZikrCompleted: double vibration + onCompleted → auto-scroll to next item
  → ZikrIncremented: single vibration only
       ↓
BlocBuilder in ZikrItemCard rebuilds:
  → buildWhen checks only this zikr's counter changed
  → updates progress ring, remaining count, opacity/scale
       ↓
BlocListener in AzkarListView checks:
  → if all azkar completed → shows toast → pops after 500ms
```

---
Counter updates are **purely local state changes**. They never leave the Presentation layer.

### Reading Settings Flow

**Architecture flow:**

```
Widget (Slider) → Cubit.changeFontSize (Local State) → Cubit.saveSettings() → UseCase → Repository → LocalStorage
```

**Detailed steps:**
1. App loads: `ReadingSettingsCubit.loadSettings()` calls `GetReadingSettingsUseCase` which pulls the saved `double` from storage and wraps it in a `ReadingSettings` entity.
2. User drags slider: The `FontSizeSection` widget uses a debounced `_localFontSize` state to update the slider and text preview instantly at 60fps without triggering constant Cubit state emissions and list rebuilds.
3. User releases slider (`onChangeEnd`): The widget calls `cubit.changeFontSize(finalValue)` to update the in-memory state, and `unawaited(cubit.saveSettings())` to persist the new font size via `UpdateReadingSettingsUseCase`.

---

## Layer Responsibilities

### Domain Layer

**Rules:**
- No Flutter imports. No imports from Data or Presentation.
- Entities are pure Dart classes with `final` fields and no behavior.
- Use cases receive the repository interface via constructor and delegate to it.
- All return types use `Result<T>` to represent success/failure.

**Components:**

| Component | Role |
|-----------|------|
| `CategoryEntity` | Defines the shape of a category: `id`, `title` |
| `ZikrEntity` | Defines the shape of a zikr: `id`, `text`, `count`, optional `reference`, `description` |
| `ReadingSettings`| Defines the shape of reading preferences: `fontSize` |
| `IAzkarRepository` | Contract with two methods: `getCategories()`, `getAzkarByCategory(int)` |
| `IReadingSettingsRepository` | Contract for fetching and updating reading preferences |
| `GetCategoriesUseCase` | Delegates to `repository.getCategories()` |
| `GetAzkarByCategoryUseCase` | Delegates to `repository.getAzkarByCategory(categoryId)` |
| `GetReadingSettingsUseCase`| Delegates to `readingSettingsRepository.getReadingSettings()` |
| `UpdateReadingSettingsUseCase`| Delegates to `readingSettingsRepository.updateReadingSettings(settings)` |

**Future changes:** Add a new entity here if you introduce a new data shape. Add a new use case here for any new business operation (e.g., filtering, searching). Never add framework-specific code.

---

### Data Layer

**Rules:**
- Implements domain interfaces (`IAzkarRepository`, indirectly via data source).
- Models extend domain entities and add `fromJson` — no separate mapping step.
- All JSON key strings live in `AzkarConstants`. If the JSON schema changes, only `AzkarConstants` and the affected model's `fromJson` need updating.
- Repository wraps all data source calls in `try/catch` and returns `Result.failure(CacheFailure(...))` on error.

**Components:**

| Component | Role |
|-----------|------|
| `AzkarConstants` | Centralized Hive box names and JSON key strings. Private constructor. |
| `CategoryModel` | Extends `CategoryEntity`, adds `fromJson` using `AzkarConstants` keys |
| `ZikrModel` | Extends `ZikrEntity`, adds `fromJson` using `AzkarConstants` keys |
| `IAzkarLocalDataSource` | Interface: `ensureDatabaseReady()`, `getCategories()`, `getAzkarByCategory(int)` |
| `AzkarLocalDataSourceImpl` | Loads JSON from bundled assets, persists to Hive, handles versioned migration and lazy per-category loading |
| `AzkarRepositoryImpl` | Implements `IAzkarRepository`. Ensures database readiness once per session via `_isReady` flag. Converts exceptions to `CacheFailure` results. |
| `ReadingSettingsRepositoryImpl` | Implements `IReadingSettingsRepository`. Relies directly on `ILocalStorageService` to persist `double` font size values. Handles default fallbacks and exception mapping to `CacheFailure`. |

**Future changes:** To add a new data source (e.g., remote API), create a new class implementing `IAzkarLocalDataSource` and swap it in the DI registration. To add a new field, update the entity in Domain, then update the model's `fromJson` and `AzkarConstants` here.

---

### Presentation Layer

**Rules:**
- Cubits depend only on use cases and domain entities. Never import from Data.
- Cubits are registered as factory (new instance per screen) so each screen has independent state.
- Widgets read state from cubits via `BlocBuilder` / `BlocListener`. They do not call repositories or data sources directly.
- Counter logic lives entirely in `AzkarCubit` as local state — no Data layer involvement.

**Components:**

| Group | Components | Role |
|-------|-----------|------|
| **Cubits** | `AzkarCategoriesCubit`, `AzkarCubit`, `ReadingSettingsCubit` | Load data via use cases, manage state transitions, handle counter increments, and manage reading preferences |
| **States** | `AzkarCategoriesState`, `AzkarState`, `ReadingSettingsState` | Sealed hierarchies. `ReadingSettingsLoaded` holds the current `ReadingSettings` entity. |
| **Results** | `ZikrIncrementResult` | Sealed: `ZikrIncremented`, `ZikrCompleted`, `ZikrIgnored` — returned synchronously by `incrementZikr()` for immediate UI feedback |
| **Views** | `AzkarListView`, `ReadingSettingsBottomSheet` | Main screen and settings modal |
| **Widgets** | `ZikrItemCard`, `ZikrCounter`, `ZikrContent`, `ZikrActionsRow`, `ZikrShareCard`, `SkeletonizerAzkarList`, `AzkarListContent`, `FontSizeSection` | Card display, animated counter ring, share/copy actions, loading skeleton, font size slider |
| **Utils** | `CategoryIconMapper` | Maps 23 category IDs to icons. Add new mappings here when adding categories. |

**Future changes:** Add new screens in `views/`, new cubits in `cubits/`, new widgets in `widgets/`. To add a new user interaction (e.g., long-press to favorite), handle it in the widget and delegate to a cubit method.

---

## State Management Flow

State transitions are linear and handled exclusively by Cubits.

### State Transition Diagram

```
[Initial] ──(load)──▶ [Loading] ─┬─(success)──▶ [Loaded] ↺ (increment)
                                 ├─(empty)────▶ [Empty]
                                 └─(failure)──▶ [Error]
```

### Data Loading Flow

**Categories (`AzkarCategoriesCubit`):**
- `Initial` → `loadCategories()` triggers `Loading`.
- `Loading` → `Loaded(categories)` on success with data.
- `Loading` → `Empty` on success with empty list.
- `Loading` → `Error(message)` on failure.

**Azkar List (`AzkarCubit`):**
- `Initial` → `loadAzkar(id)` triggers `Loading`.
- `Loading` → `Loaded(azkar, counters: {id: 0})` on success with data.
- `Loading` → `Error(message)` on failure.

### Local Counter Updates

In this specific feature, counter updates are treated as ephemeral local state rather than persistent domain data. They occur entirely within the `Loaded` state.
- `Loaded` → `incrementZikr(id)` triggers synchronous counter update:
  - Emits new `Loaded` state with updated `counters` map.
  - Synchronously returns `ZikrIncremented`, `ZikrCompleted`, or `ZikrIgnored` to the UI for immediate haptic feedback and scrolling.

### Performance & Rebuild Optimization

- **`buildWhen` in `ZikrItemCard`:** A list of 50 azkar would lag if all rebuilt on every tap. `buildWhen` ensures only the tapped card rebuilds, maintaining 60fps scrolling.
- **Synchronous Returns:** `incrementZikr` returns a synchronous result rather than relying purely on state emission. The UI needs to trigger immediate haptic feedback and auto-scrolling *before* the next frame. Relying only on `BlocListener` would introduce visual lag.

---

## Error Handling

### Strategy
Our high-level strategy is **Edge Catching & Safe Propagation**. Exceptions originate within the deepest data source layers (e.g., Hive errors, JSON parsing). The Repository boundary acts as a firewall, catching all raw exceptions, logging them to remote services (Firebase), and wrapping them into safe, sealed `Failure` objects for the Presentation layer.

### Propagation Flow

```
DataSource (Throws Exception) 
       ↓
Repository (Catches Exception → Logs to Firebase → Returns CacheFailure)
       ↓
Cubit (Receives FailureResult → Emits AzkarError State)
       ↓
UI (BlocBuilder renders AppErrorView)
```

### Layer-Specific Rules

| Layer | Rule | Implementation |
|-------|------|----------------|
| **Data Source** | Catch, Log, Recover/Rethrow | Uses `on Object catch`. Logs via `AppLogger.reportToFirebase()`. Some errors are intentionally recovered (e.g. a missing category JSON logs a warning but returns an empty list to avoid crashing). |
| **Repository** | Firewall & Map | Wraps all calls in `try/catch`. Maps exceptions to `Result.failure(CacheFailure(message))`. We use `CacheFailure` because all current azkar data is sourced from local storage (Hive/Assets). |
| **Cubit** | State Mapping | No `try/catch` here. Checks `is FailureResult` and emits `AzkarError(failure.message)`. |
| **UI** | Display | `BlocBuilder` shows `AppErrorView(message)` when state is `AzkarError`. |

**Future changes:** If you add network calls, throw a custom exception (e.g., `ServerException`) in the data source, catch it in the repository, and return `Result.failure(NetworkFailure(message))` to distinguish it from cache issues.

---

## Key Design Decisions

### Architecture & Layering
- **Repository Interface in Domain:** `IAzkarRepository` lives in the Domain layer, while its implementation `AzkarRepositoryImpl` lives in Data. *Reason:* This reverses the dependency; Presentation can depend on Domain's interface without ever importing or knowing about the Data layer implementation.
- **Models Extend Entities Directly:** `ZikrModel extends ZikrEntity`. *Reason:* Eliminates boilerplate `toEntity()` mapping methods in the Repository. *Trade-off:* The domain entity must be designed in a way that allows extension, slightly coupling the entity structure to the model's needs.

### State Management
- **Local Counter State in Cubit:** Counter increments (`incrementZikr`) do not touch the Data or Domain layers. *Reason:* In this specific feature, zikr counting is treated as ephemeral UI state rather than a strict Domain entity update rule. Writing to a local database on every rapid tap would introduce severe UI jank.
- **Cubit Factory Lifetime:** `AzkarCubit` and `AzkarCategoriesCubit` are registered as factories (not singletons) in DI. *Reason:* Every time the user opens a category, a fresh Cubit instance is created with counters initialized to zero. If they exit and return, the state resets naturally.

### Data & Performance
- **Lazy Hive Box Loading:** We do not load all 23 JSON category files at app startup. *Reason:* Parsing large JSON files blocks the main thread. A category box is populated from JSON only when the user taps that specific category for the first time.
- **Repository `_isReady` Flag:** Asset parsing and Hive version migration checks are heavy. *Reason:* The `_isReady` flag ensures these checks run only once per app session when the repository is first accessed, eliminating overhead on subsequent queries.

### Error Handling
- **`Result` Type over Exceptions:** The repository catches all exceptions and returns a sealed `Result` object (Success/Failure). *Reason:* Forces the Presentation layer (Cubits) to handle errors exhaustively at compile time via pattern matching, eliminating hidden crashes from unhandled asynchronous exceptions.

---

## Testing Strategy

We test behavior and state transitions, strictly avoiding UI implementation details (like animations or pixel values).

### Unit Testing

**Domain (Use Cases)**
- **Scenario: Success** – Returns `Result.success` with correct entity data.
- **Scenario: Failure** – Returns `Result.failure` without throwing.

**Data (Repository & Models)**
- **Scenario: JSON Parsing** – `fromJson` handles valid data and gracefully drops missing optional fields (`reference`, `description`).
- **Scenario: Repository Success** – Returns data when `LocalDataSource` succeeds.
- **Scenario: Repository Error Mapping** – Returns `CacheFailure` when `LocalDataSource` throws any exception.
- **Scenario: Initialization** – `_ensureReady` runs exactly once across multiple repository calls.

**Presentation (Cubits)**
- **Scenario: Load Success** – Emits `[Loading, Loaded]` with correctly initialized counter maps (all 0).
- **Scenario: Load Empty** – Emits `[Loading, Empty]` when category has no azkar.
- **Scenario: Increment Zikr** – Emits new `Loaded` state with updated counter map and synchronously returns `ZikrIncremented`.
- **Scenario: Complete Zikr** – Emits new `Loaded` state and synchronously returns `ZikrCompleted`.
- **Scenario: Ignore Zikr** – Returns `ZikrIgnored` if zikr ID doesn't exist or is already completed.
- **Scenario: Reading Settings (Load/Change/Save)** – `ReadingSettingsCubit` correctly loads data into `Loaded` state, updates size locally via `changeFontSize`, and sends updates through `saveSettings`.

### Widget Testing (UI)

- **Scenario: User Interaction** – Tapping `ZikrItemCard` triggers `incrementZikr` on the provided Cubit mock.
- **Scenario: Card State** – When Cubit emits a completed counter for a specific zikr, the card disables tap interactions.
- **Scenario: Exit Confirmation** – Tapping the back button while `hasStarted == true` and `isAllCompleted == false` shows the exit confirmation dialog.
- **Scenario: Font Size Slider Interaction** – The `FontSizeSection` displays default or loaded font size. Sliding correctly invokes `changeFontSize` and `saveSettings` without throwing any Semantics-related accessibility framework errors (ensured by `increasedValue` / `decreasedValue` checks).

---

## Architectural Extension Points

### High Priority: Data & Performance

- **Memory Caching Layer**
  - **Goal:** Avoid repeated Hive disk reads when users rapidly switch between identical categories.
  - **Where to change:** `AzkarLocalDataSourceImpl`. Implement an in-memory `Map<int, List<ZikrModel>>`. If the ID exists in the map, return it immediately; otherwise, read from Hive and cache it.

- **Progress Persistence**
  - **Goal:** Save counter state so users can resume a session if the app is killed.
  - **Where to change:** 
    - **Data:** Add `saveProgress(categoryId, counters)` to `IAzkarLocalDataSource` and implement in Hive.
    - **Domain:** Create `SaveAzkarProgressUseCase`.
    - **Presentation:** Call the use case inside `AzkarCubit.incrementZikr()`. Debounce the save operation to avoid writing to disk on every tap.

### Medium Priority: Features & Scaling

- **Remote API Syncing**
  - **Goal:** Download updated azkar without requiring an app store update.
  - **Where to change:** 
    - **Data:** Create `IAzkarRemoteDataSource` and `AzkarRemoteDataSourceImpl`.
    - **Data:** Modify `AzkarRepositoryImpl._ensureReady()` to fetch from the remote source and update the local Hive boxes if the remote version is newer.

- **Large Dataset Optimization (Pagination)**
  - **Goal:** Load massive categories in chunks to avoid memory spikes and initial rendering lag.
  - **Where to change:**
    - **Domain:** Update `IAzkarRepository` to accept `limit` and `offset` parameters: `getAzkarByCategory(categoryId, limit, offset)`.
    - **Presentation:** Update `AzkarCubit` to handle `LoadMore` events. Update `AzkarListView` to use a `ScrollController` listener that triggers `LoadMore` when near the bottom.

- **Search & Filtering**
  - **Goal:** Allow searching within a category by text or reference.
  - **Where to change:** 
    - **Domain:** Create `SearchAzkarUseCase(categoryId, query)`.
    - **Presentation:** Add a search field to `AzkarListView` and delegate query changes to `AzkarCubit` (or a dedicated search cubit) to emit filtered results.
