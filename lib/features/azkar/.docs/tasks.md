# Tasks: Reading Experience (Phase 2)

**Input**: Design documents from `lib/features/azkar/.docs/details.md` (F01–F04)

**Prerequisites**: details.md (F01 Requirements, F02 PRD, F03 Architecture, F04 Database Design)

**Tests**: Not explicitly requested — test tasks are omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

**Project Rules**: Follows `.agent/CLAUDE.md`, `CLAUDE_DATA.md`, `PROJECT_CONTEXT.md` conventions. Uses Tier 1 architecture (presentation → domain → data) as specified in `details.md` architecture section. Reading settings use `ILocalStorageService` (Hive) per `PROJECT_CONTEXT.md` Section D rule.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Feature root**: `lib/features/azkar/`
- **Data layer**: `lib/features/azkar/data/`
- **Domain layer**: `lib/features/azkar/domain/`
- **Presentation layer**: `lib/features/azkar/presentation/`
- **DI registration**: `lib/core/di/azkar_di.dart`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add required dependencies and storage key constants for the reading settings feature

- [x] T001 Add `wakelock_plus` package to `pubspec.yaml` for screen wake lock functionality (verify latest stable version with user before adding)
- [x] T002 Create reading settings storage key constants in `lib/features/azkar/data/constants/reading_settings_constants.dart` with keys: `azkar_font_size`, `azkar_keep_screen_awake`, `azkar_screen_reader_enabled` and default/min/max font size values

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core data and domain layer infrastructure for ReadingSettings that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T003 Create `ReadingSettingsModel` data class in `lib/features/azkar/data/models/reading_settings_model.dart` with fields: `fontSize` (double), `keepScreenAwake` (bool), and `screenReaderEnabled` (bool), containing a default factory, `copyWith`, and helper methods for JSON serialization/deserialization to work with local storage
- [x] T004 Create `IReadingSettingsRepository` abstract interface in `lib/features/azkar/domain/repositories/i_reading_settings_repository.dart` with methods: `Future<Result<ReadingSettingsModel>> getReadingSettings()` and `Future<Result<void>> updateReadingSettings(ReadingSettingsModel settings)`
- [x] T005 Implement `ReadingSettingsRepositoryImpl` in `lib/features/azkar/data/repositories/reading_settings_repository_impl.dart` depending directly on `ILocalStorageService` (injected via constructor) to read/write settings, wrapping calls in try/catch, logging the exception ONCE using `AppLogger.error` (at the source), and returning `Result.success` or `Result.failure(CacheFailure(...))`
- [x] T006 Create `ReadingSettingsCubit` and sealed `ReadingSettingsState` in `lib/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart` and `lib/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart` with states: `ReadingSettingsInitial`, `ReadingSettingsLoaded`, `ReadingSettingsError` — Cubit depends directly on `IReadingSettingsRepository` and exposes methods: `loadSettings()`, `changeFontSize(double)`, `toggleScreenAwake()`, `toggleScreenReader()`, `saveSettings()`
- [x] T007 Register new Reading Settings dependencies in `lib/core/di/azkar_di.dart`: `IReadingSettingsRepository` (binding to `ReadingSettingsRepositoryImpl`) and `ReadingSettingsCubit` (as factory or lazy singleton)

**Checkpoint**: Foundation ready — user story implementation can now begin in parallel

---

## Phase 3: User Story 1 — Font Size Control (Priority: P1) 🎯 MVP

**Goal**: User can customize Azkar text size via a slider in a Bottom Sheet, with real-time preview and persistent saving. Font size is scoped to the Azkar section only.

**Independent Test**: Open Azkar reading page → tap settings icon in App Bar → Bottom Sheet opens → drag font size slider → text updates immediately → close and reopen app → font size is preserved

### Implementation for User Story 1

- [x] T008 [P] [US1] Create `ReadingSettingsBottomSheet` main container widget in `lib/features/azkar/presentation/views/reading_settings/reading_settings_bottom_sheet.dart` — hosts all sections, wraps with `BlocProvider` using existing `ReadingSettingsCubit`, includes bottom sheet drag handle and title
- [x] T009 [P] [US1] Create `FontSizeSection` widget in `lib/features/azkar/presentation/views/reading_settings/font_size_section.dart` — contains a `Slider` between min and max font size, a preview text area showing "اللهم بك أصبحنا..." with the current font size applied, uses `BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>` to reactively display, calls `cubit.changeFontSize()` on slider `onChanged` and `cubit.saveSettings()` on slider `onChangeEnd`
- [x] T010 [US1] Add settings icon button to `CommonSliverAppBar` actions in `lib/features/azkar/presentation/views/azkar_list_view.dart` — on tap, opens `ReadingSettingsBottomSheet` via `showModalBottomSheet`
- [x] T011 [US1] Apply dynamic font size from `ReadingSettingsCubit` state to Azkar text content in `lib/features/azkar/presentation/widgets/zikr_item_card.dart` — wrap relevant text widgets with `BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>` and use `fontSize` from state
- [x] T012 [US1] Provide `ReadingSettingsCubit` at the `AzkarListView` level (alongside existing `AzkarCubit`) in `lib/features/azkar/presentation/views/azkar_list_view.dart` — use `MultiBlocProvider` to provide both cubits, load settings on init via `cubit.loadSettings()`

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently — font size can be changed, previewed, saved, and restored

---

## Phase 4: User Story 2 — Keep Screen Awake (Priority: P2)

**Goal**: User can enable/disable a toggle to prevent screen sleep during Azkar reading. The preference is saved and the screen stays active only while inside the Azkar reading page.

**Independent Test**: Open Azkar reading page → open settings → enable Keep Screen Awake toggle → close settings → screen remains active during reading → leave page → screen returns to normal behavior → reopen app → toggle state is restored

### Implementation for User Story 2

- [x] T013 [P] [US2] Create `ScreenAwakeSection` widget in `lib/features/azkar/presentation/views/reading_settings/screen_awake_section.dart` — contains a `SwitchListTile` with label and description, reads state from `ReadingSettingsCubit`, calls `cubit.toggleScreenAwake()` on toggle change
- [x] T014 [US2] Implement wakelock activation/deactivation lifecycle in `lib/features/azkar/presentation/views/azkar_list_view.dart` — read `keepScreenAwake` preference and enable/disable `WakelockPlus` accordingly; use a lifecycle-aware approach (e.g., using `RouteObserver` or page-level visibility triggers) to ensure `WakelockPlus.disable()` is called whenever the user navigates away from the reading page, restoring default system sleep behavior
- [x] T015 [US2] Add `ScreenAwakeSection` to `ReadingSettingsBottomSheet` in `lib/features/azkar/presentation/views/reading_settings/reading_settings_bottom_sheet.dart` as the second section after Font Size

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently — font size and screen awake are functional

---

## Phase 5: User Story 3 — Screen Reader Support (Priority: P3)

**Goal**: User can enable/disable screen reader accessibility support. All interactive elements have proper Semantics labels. If the device doesn't support screen reader, the toggle is disabled with an explanatory message.

**Independent Test**: Open Azkar reading page → open settings → enable Screen Reader toggle → Azkar content is readable by TalkBack/VoiceOver → buttons have meaningful labels → toggle on unsupported device shows disabled state with message

### Implementation for User Story 3

- [ ] T016 [P] [US3] Create `ScreenReaderSection` widget in `lib/features/azkar/presentation/views/reading_settings/screen_reader_section.dart` — contains a `SwitchListTile` for enabling/disabling, reads state from `ReadingSettingsCubit`, calls `cubit.toggleScreenReader()`, shows disabled state with message "قارئ الشاشة غير متوفر على جهازك" when device does not support it
- [ ] T017 [US3] Implement device screen reader compatibility check in `ReadingSettingsCubit` using platform channel or a dedicated accessibility service wrapper (do NOT pass `BuildContext` or use `MediaQuery` in Cubit to maintain layer separation) and update state to disable toggle accordingly.
- [ ] T018 [US3] Add comprehensive `Semantics` widgets to Azkar reading UI in `lib/features/azkar/presentation/widgets/zikr_item_card.dart` — wrap Azkar text with `Semantics(label:...)`, ensure counter button has `Semantics(button: true, label: 'عدد التكرار')`, ensure all interactive elements have `excludeSemantics` or `MergeSemantics` as appropriate for screen reader navigation
- [ ] T019 [US3] Add `Semantics` labels to Bottom Sheet controls: slider in `font_size_section.dart`, toggles in `screen_awake_section.dart` and `screen_reader_section.dart` — ensure toggle states are announced
- [ ] T020 [US3] Add `ScreenReaderSection` to `ReadingSettingsBottomSheet` in `lib/features/azkar/presentation/views/reading_settings/reading_settings_bottom_sheet.dart` as the third section after Screen Awake

**Checkpoint**: All user stories should now be independently functional — font size, screen awake, and screen reader accessibility all work

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T021 [P] Add Arabic strings for all reading settings UI text to `AppStrings` in `lib/core/constants/app_strings.dart` — section titles ("حجم الخط", "إبقاء الشاشة مفتوحة", "قارئ الشاشة"), slider labels ("صغير", "كبير"), error messages ("تعذر حفظ إعدادات القراءة"), and accessibility labels
- [ ] T022 [P] Style the `ReadingSettingsBottomSheet` using project design tokens: `context.color` for colors, `AppSpacing` for padding/margins, `AppTextStyles` for typography, `CustomAppDivider()` for section separators
- [ ] T023 Handle error states in `ReadingSettingsCubit` — if storage read/write fails, emit `ReadingSettingsError` state, show `AppToast` with fallback message, use last known good settings; do NOT call `AppLogger.error` here (the repository has already logged the error)
- [ ] T024 Verify no cross-feature imports exist — reading settings code must NOT import from other features; shared code must use `core/` utilities only
- [ ] T025 Verify `package:` imports are used for ALL files (no relative imports per project rules)
- [ ] T026 Final integration test — open each Azkar category (Morning, Evening, Ruqyah), verify all reading settings apply consistently across categories with the same shared font size setting
