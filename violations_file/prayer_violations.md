# Architectural Audit: Prayer Feature

**Status**: ❌ CRITICAL VIOLATIONS FOUND
**Auditor**: Strict Architectural Auditor
**Date**: 2026-04-28
**Feature Path**: `lib/features/prayer/`

---

## 1. Architectural & Layering Violations

### 1.1 Redundancy & Logic Split (Critical)
- **Files**: 
    - `lib/features/prayer/data/repos/prayer_repository.dart`
    - `lib/features/prayer/data/services/prayer_times_service.dart`
    - `lib/features/prayer/data/services/prayer_state_service.dart`
- **Violation**: Three different classes are responsible for "knowing" how to create or manipulate `PrayerTimes` objects. `PrayerStateService.resolveNextTime` (Line 59) even re-instantiates the `PrayerTimes` object with raw parameters, bypassing the repository. This creates multiple sources of truth for business logic.
- **Rule**: `CLAUDE.md` Section A.1.18: "SRP: Every widget, file, or class MUST have only one clearly defined responsibility."
- **Fix**: Centralize all `adhan` library interactions within `PrayerRepoImpl`. Services should receive "ready" data or domain models from the repository. Delete redundant calculation logic in services.

### 1.2 Cross-Feature Pollution (Critical)
- **File**: `lib/features/prayer/data/models/religious_event_model.dart` (Line 3)
- **Violation**: `import 'package:sana/features/daily_content/data/constants/religious_event_display_names.dart';`
- **Rule**: `CLAUDE.md` Section A.2.27: "No cross-feature imports — features are isolated vertical slices."
- **Fix**: Move the shared naming logic to `core/` if it's used by multiple features, or duplicate the constant if it's a simple mapping. Features MUST NOT depend on each other.

### 1.3 External Library Bleeding / Layer Contamination (High)
- **Files**: 
    - `lib/features/prayer/presentation/cubit/prayer_times_state.dart` (Lines 30-31)
    - `lib/features/prayer/data/repos/prayer_repository.dart` (Lines 11-13)
    - `lib/features/prayer/data/models/prayer_display_model.dart` (Lines 9, 14)
- **Violation**: The `adhan` library types (`Prayer`, `PrayerTimes`, `SunnahTimes`, `Coordinates`) are used in the Repository interface, Cubit State, and Presentation Models. The presentation layer is now hard-coupled to a third-party library.
- **Rule**: `CLAUDE.md` Section A.1.16: "Follow the project's architecture layer boundaries strictly: presentation → domain → data."
- **Fix**: Create internal Entities/Models (e.g., `PrayerType` enum, `PrayerTimesEntity`) and map `adhan` types to these internal types within the Data Layer. The Presentation layer should never see `package:adhan`.

### 1.4 Presentation Logic Leak (High)
- **File**: `lib/features/prayer/presentation/cubit/prayer_times_cubit.dart` (Lines 184-211)
- **Violation**: The method `_buildDisplayModels` performs data transformation (mapping, name fetching, logic for "next" prayer time).
- **Rule**: `CLAUDE.md` Section C.9: "Move all data transformation or parsing logic... from the UI layer to the Data Layer (Models)."
- **Fix**: Move this mapping logic to a factory constructor in `PrayerDisplayModel` or a dedicated mapper in the data layer.

### 1.5 Service Interface Violation (Medium)
- **Files**: 
    - `lib/features/prayer/data/services/religious_events_service.dart`
    - `lib/features/prayer/data/services/prayer_status_service.dart`
    - `lib/features/prayer/data/services/user_settings_service.dart`
    - `lib/features/prayer/data/services/prayer_state_service.dart`
    - `lib/features/prayer/data/services/prayer_times_service.dart`
- **Violation**: Classes are defined as concrete implementations without abstract interfaces.
- **Rule**: `CLAUDE.md` Section D Table: "Services (abstract) -> I prefix + PascalCase + Service". `PROJECT_CONTEXT.md` Section B.402: "Every core service follows Interface → Implementation".
- **Fix**: Create interfaces (e.g., `IReligiousEventsService`) and rename current classes to `...ServiceImpl`.

---

## 2. UI & Design System Violations

### 2.1 Hardcoded Arabic Strings (Critical)
- **Files**: 
    - `lib/features/prayer/presentation/views/prayer_times_settings_view.dart:L83` (`title: 'الموقع'`)
    - `lib/features/prayer/data/constants/prayer_name_provider.dart` (Lines 19-29: 'الفجر', 'الظهر', etc.)
    - `lib/features/prayer/presentation/widgets/prayer_sunnah_bottom_sheet.dart:L47` (`prayerName == 'العصر'`)
- **Violation**: Inline Arabic strings and direct string comparisons for logic.
- **Rule**: `CLAUDE.md` Section B.78: "All user-facing Arabic text MUST be centralized... No inline Arabic strings allowed."
- **Fix**: Move all strings to `AppStrings`. Use Enums for prayer identity comparisons, not localized strings.

### 2.2 Ad-hoc Decorations (High)
- **Files**: 
    - `lib/features/prayer/presentation/widgets/prayer_card_content.dart:L40-61`
    - `lib/features/prayer/presentation/widgets/prayer_sunnah_bottom_sheet.dart:L78-82`
- **Violation**: Manual `BoxDecoration` with hardcoded colors and radius.
- **Rule**: `PROJECT_CONTEXT.md` Section C.517: "Use featureCardDecoration()... for all feature-specific cards."
- **Fix**: Replace manual `BoxDecoration` with `featureCardDecoration()`.

### 2.3 Typography Purity Violation (High)
- **File**: `lib/features/prayer/presentation/widgets/prayer_card_content.dart:L67-79`
- **Violation**: Use of `.copyWith` to modify `color` and `fontSize` on a centralized style.
- **Rule**: `CLAUDE.md` Section C.139: "NEVER use .copyWith to modify fontSize, fontWeight, color, or fontFamily."
- **Fix**: Use appropriate pre-defined text styles from `AppTextStyles`.

### 2.4 Hardcoded Spacing & UI Magic Numbers (High)
- **Files**: 
    - `lib/features/prayer/presentation/views/prayer_times_settings_view.dart` (Multiple `SizedBox(height: 16/12/24)`)
    - `lib/features/prayer/presentation/widgets/prayer_timeline.dart:L18,24,25` (12, 4, 6)
    - `lib/features/prayer/presentation/widgets/wave_progress_widget.dart:L45,81,82` (0.55, 10.0, 6.0)
- **Violation**: Use of raw double values for spacing and UI scaling.
- **Rule**: `CLAUDE.md` Section C.137: "NEVER use hardcoded double values for the spacing property... Always use spacing tokens."
- **Fix**: Use `AppSpacing` tokens for all padding, margins, and gaps.

---

## 3. Engineering & Clean Code Violations

### 3.1 Data Transformation in UI (High)
- **Files**: 
    - `lib/features/prayer/presentation/widgets/prayer_timeline.dart:L28-33` (`DateFormat`)
    - `lib/features/prayer/presentation/widgets/prayer_card_content.dart:L31,75` (`replaceAll('\n', ' ')`)
- **Violation**: Logic for formatting time and cleaning strings is inside the `build()` method.
- **Rule**: `CLAUDE.md` Section C.131: "Move all data transformation or parsing logic... to the Data Layer (Models)."
- **Fix**: Add getters like `formattedTime` and `displayTime` to `PrayerDisplayModel`.

### 3.2 Magic Numbers in Business Logic (High)
- **Files**: 
    - `lib/features/prayer/data/repos/prayer_repository.dart:L27-28` (30.033333, 31.233334)
    - `lib/features/prayer/utils/prayer_time_status_calculator.dart` (15, 10, 20 minutes)
    - `lib/features/prayer/data/services/religious_events_service.dart` (366, 7, 29, 12)
- **Violation**: Hardcoded thresholds and coordinates.
- **Rule**: `CLAUDE.md` Section F.271: "DON'T use magic numbers — extract to named constants."
- **Fix**: Move these to `AppConstants` or feature-specific constants file.

### 3.3 Non-Exhaustive State Handling (High)
- **File**: `lib/features/prayer/presentation/widgets/prayer_timeline.dart:L13`
- **Violation**: Uses `if (state is ...)` which ignores other states.
- **Rule**: `CLAUDE.md` Section E.229: "Always handle all 4 UI states in presentation: initial, loading, success, error."
- **Fix**: Use a `switch(state)` expression to ensure compile-time exhaustiveness.

---

## 4. Performance Optimization Violations

### 4.1 Expensive Object Instantiation in `build()` (High)
- **File**: `lib/features/prayer/presentation/widgets/prayer_timeline.dart:L28-29`
- **Violation**: `DateFormat` objects are instantiated inside the `map()` function within the `build()` method. Since this happens for every prayer card in every rebuild, it creates significant overhead.
- **Rule**: `CLAUDE.md` Section C.119: "Avoid heavy work inside build() methods." Section C.121: "NEVER create ... expensive objects inside build()."
- **Fix**: Move `DateFormat` to static constants in the Model or a Utility class, or pre-format the time in the Model/Cubit.

### 4.2 GPU Intensive Widgets (High)
- **File**: `lib/features/prayer/presentation/widgets/prayer_card_content.dart:L37-38`
- **Violation**: Use of `BackdropFilter` with `ImageFilter.blur`. When used inside a grid (5 cards) and during animations (like `pressScale`), this causes a massive spike in GPU usage and potential frame drops on mid-to-low end devices.
- **Rule**: `CLAUDE.md` Section C.128: "Use ... RepaintBoundary for animations."
- **Fix**: Consider using a pre-rendered semi-transparent gradient or a `RepaintBoundary` to cache the static parts of the card. Evaluate if the blur is strictly necessary for the design tokens.

### 4.3 Missing Responsive Scaling (High)
- **File**: `lib/features/prayer/presentation/widgets/header/city_country_widget.dart:L38`
- **Violation**: Hardcoded `size: 14` for an icon without using the responsive scaling helper.
- **Rule**: `CLAUDE.md` Section C.136: "Explicit UI Scaling: Use .r(context) in the UI only for other dimensions (e.g., icons...)."
- **Fix**: Change to `size: 14.r(context)`.

### 4.4 Redundant Calculation & Object Creation (Medium)
- **File**: `lib/features/prayer/data/services/prayer_state_service.dart:L59`
- **Violation**: `resolveNextTime` re-instantiates a `PrayerTimes` object using coordinates and params, even though a valid `PrayerTimes` object was already calculated in the Cubit. This happens every time the state is updated or the timer ticks.
- **Rule**: `CLAUDE.md` Section F.272: "DON'T duplicate code — if you need it twice, move it to core/." (Applied here to execution logic/data).
- **Fix**: Pass the existing `PrayerTimes` object to `resolveNextTime` instead of re-creating it.

### 4.5 Typos Influencing Maintainability (Low)
- **File**: `lib/features/prayer/presentation/widgets/header/home_prayer_loadded.dart`
- **Violation**: Typo in filename and class name (`Loadded` instead of `Loaded`). While not a direct performance hit, it affects developer productivity and searchability.
- **Rule**: `CLAUDE.md` Section D Table: "PascalCase + Feature + State variant suffix".
- **Fix**: Rename file and class to `HomePrayerLoaded`.

---

## Audit Summary
The `prayer` feature suffers from **Architectural Bleeding** where the third-party `adhan` library has infected the presentation layer. There is also a significant amount of **Logic Duplication** between the Repository and various Services. From a **Performance** perspective, the instantiation of `DateFormat` in `build()` and the use of `BackdropFilter` without caching are the primary concerns. Most critically, **Inline Arabic strings** and **Cross-feature imports** violate the project's core isolation and centralization rules. A full refactor of the Data-to-Presentation mapping is required to sanitize the state.
