# Audit Report: Hadith Search Feature Violations

This document contains a comprehensive, strict comparison of the `hadith_search` feature against the rules defined in `CLAUDE.md` and `PROJECT_CONTEXT.md`.

## 1. State Management (Cubit Dependencies)
**Violation:** `HadithFavoritesCubit` depends directly on `IHadithFavoritesRepository`.
**Location:** `lib/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_cubit.dart`
**Rule Broken:** `CLAUDE.md` Section C - 1 ("Cubits depend ONLY on use cases — never directly on repositories or data sources") & `PROJECT_CONTEXT.md` architecture diagrams.
**Required Action:** Create Use Cases for the favorites operations (e.g., `GetHadithFavoritesUseCase`, `ToggleHadithFavoriteUseCase`) and inject them into the Cubit instead of the Repository.

## 2. Architecture & Folder Structure Purity
**Violation:** Presence of a feature-level `utils/` folder containing `hadith_formatter.dart`.
**Location:** `lib/features/hadith_search/utils/hadith_formatter.dart`
**Rule Broken:** `CLAUDE.md` Section C - 4 (Feature Folder Structure) strictly allows only `data/`, `domain/`, and `presentation/` at the root of a feature.
**Required Action:** Move formatting and transformation logic inside the Data Layer (e.g., as part of Models or Data sources parsing) or Domain layer if appropriate, and delete the feature root `utils/` folder.

## 3. Data Transformation & Business Logic in UI
**Violation:** Formatting data (highlighting strings) and mapping logic (determining judgment colors) are executed inside the UI layer (`build` methods) or declared within UI components.
**Locations:**
- `lib/features/hadith_search/presentation/widgets/hadith_item_card.dart` (Lines 16-20: calling `HadithFormatter.highlightSearchQuery` and `getJudgmentColor` inside `build()`).
- `lib/features/hadith_search/presentation/widgets/share_card/hadith_share_card.dart` (Lines 19-37: declares `_getJudgmentColor` business logic inside the widget).
**Rule Broken:** `CLAUDE.md` Section C - 9 ("Move all data transformation or parsing logic... from the UI layer to the Data Layer") & Section F ("DON'T put business logic in widgets or build() methods").
**Required Action:** The parsed colors, highlighted texts, or judgments should be prepared in the Data/Domain layers (or at least mapped in the Cubit) so the UI widgets receive "ready-to-render" data.

## 4. Error Handling Contract (Domain Return Types)
**Violation:** The Favorites Repository contract does not use `ApiResult<T>` and handles errors by silently returning empty values instead of Failure objects.
**Locations:** 
- `lib/features/hadith_search/domain/repositories/i_hadith_favorites_repository.dart` (Returns `List<HadithEntity>` and `Future<bool>` instead of `ApiResult`).
- `lib/features/hadith_search/data/repos/hadith_favorites_repository.dart` (Lines 33-39: catches `Exception` and returns `[]` silently instead of `Failure.cache(...)`).
**Rule Broken:** `CLAUDE.md` Section C - 5 & Section E ("Domain layer: return ApiResult<T> from use cases and repositories", "Don't swallow errors silently").
**Required Action:** Refactor `IHadithFavoritesRepository` to return `ApiResult` types and emit proper `Failure` states.

## 5. Strict Responsive Sizing & Typography
**Violation 1: Font Overrides**
- Using `.copyWith(fontSize: 13)` in `lib/features/hadith_search/presentation/widgets/suggestions_grid.dart` (Line 148).
- **Rule Broken:** `CLAUDE.md` Section C - 10 ("NEVER use .copyWith to modify fontSize, fontWeight, color, or fontFamily.")

**Violation 2: Hardcoded Spacing/Sizes**
- `suggestions_grid.dart` (Line 54): `padding: const EdgeInsets.symmetric(vertical: 8)` (uses `8` instead of `AppSpacing`).
- `hadith_share_card.dart` (Lines 53, 54, 57, 62, 76, 78): Uses hardcoded doubles like `24`, `40`, `32`, `150`, `-10`, `-20`.
- **Rule Broken:** `CLAUDE.md` Section C - 10 & Section F ("DON'T hardcode colors, spacing, or font sizes — use design tokens from core/theme/").
**Required Action:** Replace all hardcoded sizes with properties from `AppSpacing` and use centralized text styles without overriding properties like `fontSize`.

## 6. Design Tokens (Hardcoded Colors)
**Violation:** Use of native Flutter Material colors directly instead of project design tokens.
**Location:** `lib/features/hadith_search/presentation/widgets/share_card/hadith_share_card.dart` (Lines 23, 34: `Colors.green.shade400`, `Colors.red.shade400`).
**Rule Broken:** `CLAUDE.md` Section F ("DON'T hardcode colors... use design tokens from core/theme/").
**Required Action:** Add necessary success/error colors to `AppColors` and reference them exclusively.

## 7. Text & String Management (Inline Arabic Strings)
**Violation:** Hardcoded, inline Arabic strings exist in the presentation and utilities layers.
**Locations:**
- `lib/features/hadith_search/presentation/widgets/suggestions_grid.dart` (Lines 18-42: Lists of words like `'الصلاة'`, `'الصيام'`, `'التوبة'`, etc.).
- `lib/features/hadith_search/presentation/widgets/skeletonizer_loading_hadith_view.dart` (Lines 15-22: Mock HTML data containing Arabic text like `'نص الحديث الشريف يظهر هنا...'`, `'الراوي:'`, etc.).
- `lib/features/hadith_search/utils/hadith_formatter.dart` (Lines 24-35: Evaluation strings like `'صحيح'`, `'جيد'`, `'حسن'`, etc.).
**Rule Broken:** `CLAUDE.md` Section B - 2 ("All user-facing Arabic text MUST be centralized in a single strings constant. No inline Arabic strings allowed.")
**Required Action:** Extract all Arabic text to `core/constants/app_strings.dart` and reference them dynamically.

---
**Summary:** The feature successfully implements many Clean Architecture concepts, but has critical leaks in UI-side business logic (transformations), state management (Cubit -> Repo injection), lack of strict adherence to UI tokens (hardcoded colors/sizes/fonts), and inline Arabic strings.
