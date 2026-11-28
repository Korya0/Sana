# Azkar

> **Last reviewed:** 2026-11-28  
> **Status:** In development

## Purpose & Scope
- **Goal:** Let users browse built-in azkar categories, read and count zikr in a reader, adjust reading font size, count with the hardware volume buttons on Android, and create/manage custom categories or overrides of built-in ones.
- **Out of scope:** No cloud sync or accounts. Reader zikr counters are in-memory per session; tasbeeh counts and targets are saved locally. Volume-button counting is Android-only for now; on other platforms the setting is visible but disabled, and iPhone support is deferred.

## Sources of Truth
- `lib/features/azkar/presentation/cubits/azkar/azkar_cubit.dart`
- `lib/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart`
- `lib/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart`
- `lib/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart`
- `lib/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart`
- `lib/features/azkar/data/data_sources/versioned_list_store.dart`
- `lib/core/router/features/azkar_tasbeeh_router.dart`

## Glossary
| Term | Meaning |
|---|---|
| Category (تصنيف/قسم) | An azkar collection. `AzkarCategoryEntity` (`key`, `title`, `cardTitle`, `isCustom`, `isModified`). |
| Zikr (ذكر) | A single item with target `count`. `ZikrEntity` (`id`, `text`, `count`, `description?`, `isUserAdded`). `canBeDeleted => isUserAdded`. |
| Custom category | User-created category stored with id prefixed `custom_` (`customCategoryIdPrefix`). |
| Override | Modified built-in category saved under the original built-in key (no `custom_` prefix) in custom storage; shown as `isModified`. |
| Restore | Delete the stored override/custom record so reading falls back to bundled original. |

## Architecture & Flow
```mermaid
flowchart TB
  subgraph Presentation
    V[Views/Widgets] --> C[Cubits: Categories, Azkar, CustomAzkar, AzkarTasbeehSettings]
  end
  subgraph Domain
    C --> UC[Use Cases] --> IR[Repository Interfaces]
  end
  subgraph Data
    IR --> RImpl[Repository Impl]
    RImpl --> ADS[AzkarLocalDataSourceImpl\nbundled assets/json/azkar/*]
    RImpl --> CDS[CustomCategoryLocalDataSourceImpl\nKeyValueStore: custom_azkar, custom_azkar_unreadable]
    RImpl --> RS[AzkarTasbeehSettingsRepositoryImpl\nKeyValueStore: reading_font_size,\nreading_haptic_feedback, reading_volume_button_count]
  end
```

`AzkarRepositoryImpl.getZikrsByCategory` resolves content by preferring a stored custom/override record for the key; otherwise it loads bundled asset JSON.

```mermaid
flowchart LR
  Req[getZikrsByCategory key] --> Q{custom/override exists?}
  Q -->|Yes| S[Return stored azkar]
  Q -->|No| B[Load bundled asset JSON]
```

## State & UI (only if non-obvious)
- **Categories:** `AzkarCategoriesCubit` merges built-in + custom, marks built-ins `isModified` when an override exists for the same key, and lists custom (`custom_`) first.
- **Reader completion/exit:** auto-close triggers only when the session becomes fully completed with the same azkar list instance — not when edits make it appear complete. Exit confirms only if progress started and not all items completed.
- **Volume buttons (Android):** `VolumeCounterBinding` attaches only while the setting is on, a counter is ready, the route is current, and the app is resumed. `MainActivity.dispatchKeyEvent` consumes keys and sends one event per physical press (`repeatCount == 0`). Reader counts the first incomplete zikr; tasbeeh counts the selected item. Volume down stops at zero.
- **Home gauge:** display-only — no tap counting, no fingerprint cue. The centered "متابعة التسبيح" chip (label + left-pointing arrow) opens the counter screen. (D-032)
- **Tasbeeh cycling:** reaching a target starts a new cycle at one on the next tap; free counting caps at 9999.
- **Reading settings:** save failure emits `Error` carrying persisted settings so the UI can revert and show a toast. (`widgets/common/font_size_section.dart`)
- **Feedback:** skeleton loading only for full-page loads. Success toasts for one-shot mutations whose result is not otherwise visible (category save/delete/reset, session completion). Every failed user-initiated operation shows an error toast; failed counter increments revert silently. (D-008)
- **Counters:** `CounterRing` drives both zikr and tasbeeh counters. Null target = count freely to 9999; non-null target shows remaining and completes on reaching it.
- **Form fields:** `AppTextAreaField` fixed-height box (`minHeight ?? AppSize.h75`), scrolls internally — never grows with content. Character counters use `text.characters.length` matching the enforced formatter limit. Every target-count field shares `AppConstants.targetCountMaxDigits = 4`.
- **Routes:** reader `/azkar/:categoryKey`, custom form `/custom-zikr-form`, manage list `/custom-azkar-list`, azkar tab in shell. (`app_routes.dart`, `azkar_tasbeeh_router.dart`)

## Data & Storage
- **Bundled source:** `assets/json/azkar/categories.json` and `assets/json/azkar/<key>.json` via `AzkarLocalDataSourceImpl`.
- **Custom/overrides store** (`AppStorageKeys.customAzkar`, `CustomCategoryLocalDataSourceImpl`): versioned JSON envelope `{ "version": 1, "items": [...] }`; reads accept legacy list or missing version; uses in-memory cache and a serialized write queue; skips corrupted items (with logging) and best-effort backs up unreadable raw payload to `custom_azkar_unreadable` (not overwritten if present). The envelope, cache, write queue and backup logic live once in `VersionedListStore<T>` (`data_sources/versioned_list_store.dart`); each data source supplies keys and JSON mapping.
- **Reading settings:** `AppStorageKeys.readingFontSize` (`double`, default 20, clamped 14–32), `reading_haptic_feedback` (`bool`, default true), and `reading_volume_button_count` (`bool`, default true on first open) in `azkar_tasbeeh_settings_repository_impl.dart` / `azkar_tasbeeh_settings_entity.dart`.
- **Tasbeeh items:** `AppStorageKeys.tasbeehItems` stores each item's text, count, optional target, and last-used time in the same `VersionedListStore` envelope (`TasbeehLocalDataSourceImpl`).
- **IDs/rules:** custom category ids prefixed `custom_`, classified through the `isCustomCategoryId` extension (`azkar_constants.dart`). Zikr `is_user_added` is the single source of truth for user-added items: written explicitly by `toJson()` (true or false), read back with a `false` default when absent; `canBeDeleted => isUserAdded`. (`azkar_constants.dart`, `zikr_model.dart`, `zikr_entity.dart`)

## Edge Cases & Limitations
- **Corrupt/unexpected custom storage:** falls back to an empty usable state while preserving unreadable raw backup; partially corrupt items are skipped to avoid silent data loss on later writes. (`custom_azkar_local_data_source_impl.dart`)
- **Legacy `is_user_added` absence:** custom storage written before `toJson()` emitted the flag reads those zikr as not user-added (not deletable). No migration added — app not yet in production and `schemaVersion` is unchanged.
- **Concurrent writes:** serialized via a write queue to prevent lost updates.
- **Duplicate/late actions:** submit/exit/dialog guards, `PopScope(canPop: false)` in reader, and `isClosed` checks after async work to avoid duplicate handling or emits after dispose.
- **Load/save/delete failures:** mapped to `CacheFailure` with user-facing messages (`AppStrings.azkarLoadError/azkarSaveError/azkarDeleteError`); UI shows error/toast and allows retry; a failed save keeps the form open.
- **Built-in edit constraints:** built-in name locked and non-deletable original items limited to target-count edits; user-added/deletable items are editable/removable. (`custom_zikr_form_view.dart`)
- **Deep link without title extra:** title resolved from built-in categories or the stored custom record as fallback. (`azkar_cubit.dart`)
- **Volume-button guards:** interception is disabled when the setting is off, when no counter is ready (reader fully completed or no selected tasbeeh), when another route covers the screen, when the app is not resumed, and when a settings sheet is open. The native side also stops intercepting in `onPause`. (`volume_counter_binding.dart`, `MainActivity.kt`)
- **Volume-button press handling:** one count per physical press; key auto-repeat and key-up are consumed while interception is active, so holding a button does not add or remove multiple counts. Volume down on a zero count does nothing and plays no haptic. (`MainActivity.kt`, `haptic_feedback.dart`)
- **Limitation:** counter progress is session-only (not persisted).
- **No scrolling on fitting state screens:** error/empty states in tasbeeh, custom list and zikr list pass `SliverLayoutBuilder.remainingPaintExtent` as `AppErrorView`/`AppEmptyView.fillHeight`; the home-section states pass `fillHeight: 0` because they are content-sized inside a card. Previously the full-screen `minHeight` made these screens scroll by 56–352px (`docs/ui/05_scroll.md`).
- **Loading skeleton:** `ZikrListSkeleton` is a fixed-height placeholder list; at `320x640` with a 47px top inset it can still scroll 34px. Accepted as a transient placeholder that mirrors the scrollable loaded list, not a state-screen defect.

## Decisions

### D-001: Prefer stored override/custom over bundled azkar per key
- **Decision:** Return azkar from the stored record for the same `categoryKey` when present; otherwise load bundled asset JSON.
- **Reason:** Enables editing built-in categories or adding custom ones without modifying assets, while making restore a simple delete. [Inferred]
- **Rejected alternatives:** Modifying asset files or performing complex runtime merges (more complexity and less safety). [Inferred]
- **Date:** 2026-11-15
- **Status:** Unconfirmed

### D-002: Distinguish custom vs built-in override by key/prefix
- **Decision:** User-created categories use ids prefixed with `custom_`, while built-in overrides are stored under the original built-in key.
- **Reason:** One storage mechanism supports both cases with clear behavior differences (`isCustom`, restore, and display ordering). [Inferred]
- **Rejected alternatives:** Separate storage/models per type (duplication and sync complexity). [Inferred]
- **Date:** 2026-11-15
- **Status:** Unconfirmed

### D-003: Keep built-in category names app-owned
- **Decision:** Keep built-in category titles as defined by the app even when an override exists, and normalize names in listing/management.
- **Reason:** Preserves the official identity of built-in categories while allowing content customization. [Inferred]
- **Rejected alternatives:** Allowing user data to rename built-in categories. [Inferred]
- **Date:** 2026-11-15
- **Status:** Unconfirmed

### D-004: Versioned resilient custom storage (cache + serialized writes + backup)
- **Decision:** Store a versioned envelope (`version/items`) that accepts legacy formats, with in-memory cache, a write queue, and skip/backup handling for corrupted data.
- **Reason:** Provides backward compatibility, better data safety, and fewer lost updates from concurrent writes. [Inferred]
- **Rejected alternatives:** Unversioned raw writes or hard-failing on first corruption (less resilient, higher data-loss risk). [Inferred]
- **Date:** 2026-11-15
- **Status:** Unconfirmed

### D-005: Session-only counter progress with clamped apply-on-edit
- **Decision:** Keep reading counters in memory only, and when applying edits preserve progress by clamping counters to new targets.
- **Reason:** Simplifies persistence while avoiding loss of current-session progress during edits. [Inferred]
- **Rejected alternatives:** Persisting detailed per-zikr progress permanently (added complexity and sync/state cases). [Inferred]
- **Date:** 2026-11-15
- **Status:** Unconfirmed

### D-006: One shared implementation per UI pattern, thin public wrappers
- **Decision:** Keep `CounterRing`, `AppFormSheet`, `AppStateView`, `AppButton` and `VersionedListStore<T>` as the single implementations. Public names (`ZikrCounter`, `TasbeehCounter`, `ZikrFormBottomSheet`, `TasbeehItemFormBottomSheet`, `AppEmptyView`, `AppErrorView`, `AppPrimaryButton`, `AppSecondaryButton`) stay as wrappers so call sites keep their intent.
- **Reason:** Removes duplicated logic without touching call sites, which keeps tests and screen code stable.
- **Rejected alternatives:** Rewriting every call site to the new names (wider diff, no behavioural gain).
- **Date:** 2026-11-16
- **Status:** Confirmed

### D-007: `isUserAdded` is the only source of truth for deletability
- **Decision:** Use the explicit `is_user_added` flag alone to decide whether a zikr is deletable (`canBeDeleted => isUserAdded`). `toJson()` always writes the flag; reading defaults to `false` when it is absent. The `id > 100000` heuristic was removed.
- **Reason:** The flag is written for every user-added zikr, so the id-based fallback was redundant and ambiguous; an explicit boolean is accurate and avoids misclassifying a large-id built-in item. [Confirmed]
- **Rejected alternatives:** Keeping the `id > 100000` fallback (ambiguous, can misclassify). [Confirmed]
- **Date:** 2026-11-17
- **Status:** Active

### D-008: Skeleton loading, scoped success, always-on failure feedback
- **Decision:** Full-page/list loading is shown only as a skeleton that mirrors the loaded layout pixel-for-pixel; no spinner and no loading toast. Success toasts are limited to one-shot mutations whose result is not otherwise visible (category save/delete/reset, session completion); copy and counter increments never show one. Every failed user-initiated operation shows an error toast, except a failed full-page load (rendered as `AppErrorView` with retry) and a failed counter increment (silently reverted because the count change is visible and per-tap toasts would be noisy).
- **Reason:** A skeleton keeps the screen shape stable while data loads; limiting success messages avoids noise on high-frequency or self-evident actions while keeping failures explainable. [Confirmed]
- **Rejected alternatives:** `CircularProgressIndicator` for page loads (layout jump), a success toast for every action (noise, and copy already has system confirmation). [Confirmed]
- **Date:** 2026-11-17
- **Status:** Active

### D-009: Keep azkar management in the app-bar options sheet
- **Status:** Superseded by D-020.

### D-010: Keep home cards still and labels single-line
- **Status:** Superseded by D-018 and D-022.

### D-011: Cap tasbeeh counting at four digits
- **Decision:** Limit target counts and free counting to 9999, and collapse repeated whitespace in saved custom tasbeeh text.
- **Reason:** Keeps counts and custom labels readable and bounded without changing existing azkar target limits.
- **Rejected alternatives:** Three-digit targets or unbounded free counts.
- **Date:** 2026-11-17
- **Status:** Confirmed

### D-012: Keep the home All sheet focused on tasbeeh items
- **Decision:** Hide reading settings from the All sheet opened by the home card, while keeping them in the tasbeeh screen's app-bar sheet.
- **Reason:** The home All action is for choosing and managing tasbeeh; reading settings remain available in their established screen-level options.
- **Rejected alternatives:** Showing reading settings in the home All sheet or removing them from the tasbeeh screen.
- **Note:** The home All entry was removed by D-032; the sheet itself is still used from the counter screen.
- **Date:** 2026-11-17
- **Status:** Confirmed

### D-013: Use the shared All sheet to select a tasbeeh on the counter screen
- **Decision:** Tapping the selected-item control opens the same All sheet used from home, without reading settings; selecting an item switches the current counter in place.
- **Reason:** Reuses the All sheet the developer selected and keeps the counter screen's options sheet available for reading settings.
- **Rejected alternatives:** Inline selection list and previous/next controls.
- **Date:** 2026-11-18
- **Status:** Confirmed

### D-014: Center the tasbeeh and bound custom text
- **Decision:** Center the zikr and counter as a group, limit custom tasbeeh text to 500 characters, and show reset with an icon and label.
- **Reason:** Keeps the reading area balanced while making the reset action explicit.
- **Rejected alternatives:** Allowing unbounded custom text or showing reset as an icon alone.
- **Date:** 2026-11-18
- **Status:** Confirmed

### D-015: Keep reset beside the tasbeeh selector
- **Decision:** Place a filled primary reset button next to the selected-item control, with its icon above a single-line label and matching height and corner radius.
- **Reason:** Keeps related tasbeeh controls together and leaves the reading area for the zikr and counter.
- **Rejected alternatives:** Placing reset below the counter.
- **Date:** 2026-11-18
- **Status:** Confirmed

### D-016: Continue counting in a new cycle after the target
- **Decision:** Once a target is reached, the next tap starts the next cycle at one; free counting remains capped at 9999.
- **Reason:** Allows repeated rounds without requiring an explicit reset after every completion.
- **Rejected alternatives:** Ignoring taps after completion.
- **Date:** 2026-11-18
- **Status:** Confirmed

### D-017: Custom-azkar management is the only home options entry
- **Decision:** Remove "إنشاء أذكار" from the home options sheet and keep "إدارة الأذكار" only. The management screen carries its create action in the app bar when the list has items, while the empty state keeps a body button as the only create action.
- **Reason:** The management checklist is the single place for custom azkar, so a second entry duplicated the same destination; placing creation in management keeps it one tap away without duplicating controls.
- **Rejected alternatives:** Keeping both create entries.
- **Note:** Reading settings rows were added back to the home options sheet as shared tiles; they are not a create entry.
- **Date:** 2026-11-18
- **Status:** Confirmed

### D-018: Saved-tasbeeh card drops the remaining line and the marquee
- **Status:** Superseded by D-021 (title now two lines, not one line).

### D-019: Screens declare whether they can go back
- **Decision:** `CommonSliverAppBar.showBack` overrides the implicit navigator check. Shell tab roots that keep an app bar (the tasbeeh home) pass `false`; the azkar home has no app bar (see D-020); pushed screens keep the navigator check.
- **Reason:** `Navigator.canPop()` reports the nested navigator's whole stack, not whether this screen has a screen behind it. Inside a shell branch it turns true while a bottom sheet or dialog is open **[Inferred]** (and can keep restored pages), so a tab root could show a back arrow with nowhere to go. It is also a one-time check that does not react to later route changes, so the wrong value can stick after its cause is gone. Declaring the intent per screen is deterministic.
- **Rejected alternatives:** Inferring back visibility solely from `Navigator.canPop()` everywhere.
- **Date:** 2026-11-18
- **Status:** Confirmed

### D-020: Home has no app bar; options live in the section header
- **Decision:** Remove the azkar home app bar and its unused title string, move the options icon to the end of the azkar section header (opposite the "الأذكار" title), and keep the tasbeeh card above the azkar categories. `CommonSliverAppBar` now uses `titleSpacing`/`actionsPadding` aligned to the screen gutter, so the remaining app bars match the content.
- **Reason:** The app bar repeated the section title and spent vertical space on a single action. Keeping the action beside the section it configures makes it visible without an app bar, and the screen now opens on the tasbeeh card. [Confirmed]
- **Rejected alternatives:** Keeping the app bar for the options action, or hiding options behind a category long-press. [Confirmed]
- **Date:** 2026-11-18
- **Status:** Confirmed

### D-021: Tasbeeh home uses a bead-arc gauge
- **Decision:** Replace the circular progress ring and the preset tiles with one shared bead-arc gauge (`TasbeehBeadCounter`): 27 beads fill with progress, the count sits inside the arc, and the empty state shows `0` with "اختر سبحة للبدء". The saved card title uses up to two lines, and both states keep two 48 px actions.
- **Reason:** The arc reads as a rosary and keeps the count inside the same shape, so the saved and empty states share one component instead of two divergent layouts.
- **Rejected alternatives:** The 64 px progress ring, two-line titles inside the arc, or a separate saved/empty layout.
- **Date:** 2026-11-18
- **Status:** Confirmed
- **Note:** The empty-state `0` is superseded by D-028; the bead-arc gauge itself stands.

### D-022: Light motion inside the tasbeeh home gauge only
- **Decision:** The saved-tasbeeh gauge fills bead by bead over about 1.4 s (the leading bead fades in), and its count counts up from zero to the saved value over 1.5 s. The tasbeeh card and its buttons stay still, and all motion is skipped under `context.reduceMotion`. A free tasbeeh at zero shows an inactive bead gauge; after the first count the arc is full. The azkar grid keeps no entrance animation — skeleton loading only.
- **Reason:** Motion is limited to the gauge's own data, so it adds polish without animating the actions or the grid, and the count change stays readable.
- **Rejected alternatives:** Animating the card or its action buttons, a grid entrance animation, looping motion, or keeping the full free-mode arc at zero.
- **Date:** 2026-11-18
- **Status:** Active

### D-023: Count with an Android-native volume-key bridge
- **Decision:** Intercept volume keys in `MainActivity.dispatchKeyEvent` only while the Dart `VolumeCounterBinding` keeps the native flag enabled, and send one event per physical press over the `sana/volume_buttons` `MethodChannel`. Count the first incomplete reading zikr and the selected tasbeeh item. Mirror tap haptics for volume up; volume down plays one light haptic only on an actual decrement. Show the setting disabled on non-Android platforms.
- **Reason:** Android must consume the key before the system changes device volume, and a small owned bridge avoids a third-party dependency while keeping the enable/disable lifetime explicit. [Confirmed]
- **Rejected alternatives:** Flutter `HardwareKeyboard` (cannot stop the system volume change), third-party volume-button packages (limited iOS support, clone-at-pod-install risk, or unnecessary dependency), and iOS native support for now (deferred to a later platform task).
- **Date:** 2026-11-19
- **Status:** Confirmed
- **Note:** The default was later changed by D-024; all other parts of this decision stand.

### D-024: Enable volume counting by default on Android
- **Decision:** Default `AzkarTasbeehSettingsEntity.volumeButtonCountEnabled` to `true`, so Android users get counting from the first open. A stored `false` from an explicit opt-out still wins, and non-Android platforms keep showing the switch off and disabled.
- **Reason:** The developer wants the feature active immediately on Android rather than requiring users to discover and enable a hidden setting. [Confirmed]
- **Rejected alternatives:** Keeping the original off-by-default behavior.
- **Date:** 2026-11-19
- **Status:** Confirmed

### D-025: Tap decrements, long press resets
- **Status:** Superseded by D-034 (two visible actions instead of hidden gestures).

### D-026: Home gauge counts in place
- **Status:** Superseded by D-032 (gauge is display-only; "متابعة التسبيح" is the only home action).

### D-028: Start-state gauge is a prompt only, not a control
- **Decision:** When no tasbeeh is saved, the start gauge shows "اختر سبحة للبدء" without a `0` count and is not tappable. The count and tap behavior appear only when a saved tasbeeh exists; the empty state offers Astaghfirullah and the custom action.
- **Reason:** The developer wants the start state to read as a prompt, with no number that suggests counting has begun and no tap target that implies an item is selected. [Confirmed]
- **Rejected alternatives:** Keeping the `0` above the prompt, or keeping the gauge tappable to start Astaghfirullah.
- **Date:** 2026-11-19
- **Status:** Confirmed

### D-029: One header row controls every bottom sheet
- **Decision:** Put each sheet's title at the start beside a close (`X`) icon, or a back icon when the sheet opens from another sheet. Form sheets move their text Save action to the end of the header, drop the bottom Save/Cancel buttons, and keep Save disabled until the fields are valid.
- **Reason:** The developer wants save and dismiss in one predictable place at the top, matching the edit-azkar screen and the font-size sheet. [Confirmed]
- **Rejected alternatives:** Keeping the bottom Save/Cancel pair, a centered sheet title, or an always-enabled Save.
- **Date:** 2026-11-19
- **Status:** Confirmed

### D-030: Reusable validation at UI, domain and storage boundaries
- **Decision:** `AppValidators` enforces required, minimum Arabic-letter count, character class and duplicate rules; cubits recheck before saving, and storage models sanitize/clamp on read.
- **Reason:** The developer wants no field accepting a one-character or punctuation-only value, and no invalid data entering from sources outside the UI. [Confirmed]
- **Rejected alternatives:** UI-only validation, or per-field ad hoc rules.
- **Date:** 2026-11-19
- **Status:** Confirmed

### D-031: Start card uses a prompt action and three preset buttons
- **Decision:** In the empty tasbeeh card, the gauge reserves no space for a hidden count; the prompt is a brand-colored text button "السبحة المخصصة" with an add icon that opens the custom-tasbeeh sheet, and three compact light-bordered chips centered offer أستغفر الله، الحمد لله، سبحان الله.
- **Reason:** The developer wants no invisible count taking space and a simpler set of quick-start actions. [Confirmed]
- **Rejected alternatives:** Keeping the hidden number slot, a separate custom button below the prompt, or a filled primary preset button.
- **Date:** 2026-11-19
- **Status:** Confirmed

### D-032: Home card keeps one centered Continue action
- **Decision:** Remove the "All" button from the saved-tasbeeh home card and center "Continue"; shift the saved gauge content slightly down. The empty state is untouched.
- **Reason:** The developer wants fewer controls on the home card and a single clear next action. [Confirmed]
- **Rejected alternatives:** Keeping the All button, or moving the empty-state gauge.
- **Date:** 2026-11-20
- **Status:** Confirmed

### D-034: Visible two-part count adjust control
- **Decision:** Replace the single reset icon in both reading and tasbeeh cards with a shared control: minus = decrement one, refresh with a `0` badge = full reset.
- **Reason:** The developer wants each action visible and self-explanatory instead of a hidden tap/long-press difference. [Confirmed]
- **Rejected alternatives:** One icon with two gestures, or a dialog.
- **Date:** 2026-11-20
- **Status:** Confirmed

## Screenshots

Full gallery: [`screenshots/azkar/`](../../../screenshots/azkar/). Each frame is named after the screen/state and suffixed `_light` or `_dark`.

### Azkar + tasbeeh home

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Tasbeeh initial — light</b><br><img src="../../../screenshots/azkar/azkar_tasbeeh_home/tasbeeh_initial_light.jpeg" width="200"></td>
      <td align="center"><b>Tasbeeh initial — dark</b><br><img src="../../../screenshots/azkar/azkar_tasbeeh_home/tasbeeh_initial_dark.jpeg" width="200"></td>
      <td align="center"><b>Tasbeeh loaded — light</b><br><img src="../../../screenshots/azkar/azkar_tasbeeh_home/tasbeeh_loaded_light.jpeg" width="200"></td>
      <td align="center"><b>Tasbeeh loaded — dark</b><br><img src="../../../screenshots/azkar/azkar_tasbeeh_home/tasbeeh_loaded_dark.jpeg" width="200"></td>
    </tr>
  </table>
</div>

### Home options sheet

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Home options — light</b><br><img src="../../../screenshots/azkar/azkar_home_options_sheet/home_options_sheet_light.jpeg" width="200"></td>
    </tr>
  </table>
</div>

### Category actions sheet (long press)

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Custom zikr / delete — light</b><br><img src="../../../screenshots/azkar/azkar_category_actions_bottom_sheet/category_actions_custom_delete_light.jpeg" width="200"></td>
      <td align="center"><b>Custom zikr / delete — dark</b><br><img src="../../../screenshots/azkar/azkar_category_actions_bottom_sheet/category_actions_custom_delete_dark.jpeg" width="200"></td>
      <td align="center"><b>Built-in / restore — light</b><br><img src="../../../screenshots/azkar/azkar_category_actions_bottom_sheet/category_actions_builtin_restore_light.jpeg" width="200"></td>
      <td align="center"><b>Built-in / restore — dark</b><br><img src="../../../screenshots/azkar/azkar_category_actions_bottom_sheet/category_actions_builtin_restore_dark.jpeg" width="200"></td>
      <td align="center"><b>Category actions — dark</b><br><img src="../../../screenshots/azkar/azkar_category_actions_bottom_sheet/category_actions_sheet_dark.jpeg" width="200"></td>
    </tr>
  </table>
</div>

### Font size & reading settings sheets

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Font size — light</b><br><img src="../../../screenshots/azkar/font_size_bottom_sheet/font_size_sheet_light.jpeg" width="200"></td>
      <td align="center"><b>Font size — dark</b><br><img src="../../../screenshots/azkar/font_size_bottom_sheet/font_size_sheet_dark.jpeg" width="200"></td>
      <td align="center"><b>Reading settings — light</b><br><img src="../../../screenshots/azkar/reading_settings_bottom_sheet/reading_settings_sheet_light.jpeg" width="200"></td>
      <td align="center"><b>Reading settings — dark</b><br><img src="../../../screenshots/azkar/reading_settings_bottom_sheet/reading_settings_sheet_dark.jpeg" width="200"></td>
    </tr>
  </table>
</div>

### Custom tasbeeh form & list sheets

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Custom tasbeeh sheet — light</b><br><img src="../../../screenshots/azkar/custom_tasbeeh_form_sheet/custom_tasbeeh_sheet_light.jpeg" width="200"></td>
      <td align="center"><b>Custom tasbeeh sheet — dark</b><br><img src="../../../screenshots/azkar/custom_tasbeeh_form_sheet/custom_tasbeeh_sheet_dark.jpeg" width="200"></td>
      <td align="center"><b>Tasbeeh list — light</b><br><img src="../../../screenshots/azkar/tasbeeh_list_bottom_sheet/tasbeeh_list_sheet_light.jpeg" width="200"></td>
      <td align="center"><b>Tasbeeh list — dark</b><br><img src="../../../screenshots/azkar/tasbeeh_list_bottom_sheet/tasbeeh_list_sheet_dark.jpeg" width="200"></td>
    </tr>
  </table>
</div>

### Tasbeeh screen

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Tasbeeh loaded — light</b><br><img src="../../../screenshots/azkar/tasbeeh_view/tasbeeh_loaded_light.jpeg" width="200"></td>
      <td align="center"><b>Tasbeeh loaded — dark</b><br><img src="../../../screenshots/azkar/tasbeeh_view/tasbeeh_loaded_dark.jpeg" width="200"></td>
    </tr>
  </table>
</div>

### Zikr reader

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Reading mode — light</b><br><img src="../../../screenshots/azkar/zikr_list_view/reading_mode_light.jpeg" width="200"></td>
      <td align="center"><b>Reading mode — dark</b><br><img src="../../../screenshots/azkar/zikr_list_view/reading_mode_dark.jpeg" width="200"></td>
    </tr>
  </table>
</div>

### Add zikr sheet

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Add zikr — light</b><br><img src="../../../screenshots/azkar/add_zikr_form_sheet/add_zikr_sheet_light.jpeg" width="200"></td>
      <td align="center"><b>Add zikr — dark</b><br><img src="../../../screenshots/azkar/add_zikr_form_sheet/add_zikr_sheet_dark.jpeg" width="200"></td>
    </tr>
  </table>
</div>

### Custom azkar list

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Empty — light</b><br><img src="../../../screenshots/azkar/custom_azkar_list/empty_light.jpeg" width="200"></td>
      <td align="center"><b>Empty — dark</b><br><img src="../../../screenshots/azkar/custom_azkar_list/empty_dark.jpeg" width="200"></td>
      <td align="center"><b>With items — light</b><br><img src="../../../screenshots/azkar/custom_azkar_list/with_items_light.jpeg" width="200"></td>
      <td align="center"><b>With items — dark</b><br><img src="../../../screenshots/azkar/custom_azkar_list/with_items_dark.jpeg" width="200"></td>
    </tr>
  </table>
</div>

### Custom azkar form (create / edit / reorder)

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Create — dark</b><br><img src="../../../screenshots/azkar/custom_azkar_form/create_form_dark.jpeg" width="200"></td>
      <td align="center"><b>Edit — light</b><br><img src="../../../screenshots/azkar/custom_azkar_form/edit_form_light.jpeg" width="200"></td>
      <td align="center"><b>Edit existing — light</b><br><img src="../../../screenshots/azkar/custom_azkar_form/edit_existing_light.jpeg" width="200"></td>
      <td align="center"><b>Edit — dark</b><br><img src="../../../screenshots/azkar/custom_azkar_form/edit_form_dark.jpeg" width="200"></td>
      <td align="center"><b>Reorder hint — light</b><br><img src="../../../screenshots/azkar/custom_azkar_form/reorder_hint_light.jpeg" width="200"></td>
      <td align="center"><b>Reorder hint — dark</b><br><img src="../../../screenshots/azkar/custom_azkar_form/reorder_hint_dark.jpeg" width="200"></td>
    </tr>
  </table>
</div>
