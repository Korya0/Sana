# Asma Ul Husna Feature - Hyper-Strict Architectural Audit Report

This document contains a line-by-line, rigorous architectural audit of the `asma_ul_husna` feature against the project's Tier 2 Clean Architecture standards, UI guidelines, and strict DI/layer rules.

## 🔴 CRITICAL VIOLATIONS

### 1. Cross-Feature Import (Layer Bleeding)
* **File:** `lib/features/asma_ul_husna/presentation/widgets/asma_ul_husna_name_of_the_day_card.dart`
* **Lines:** 10-12
* **Rule Broken:** `CLAUDE.md` - Section A, Rule 2 & Section F (`DON'T import from one feature into another — features are isolated`).
* **Description:** The `asma_ul_husna` feature directly imports `DailyContentCubit`, `DailyContentState`, and `DailyContentBaseCard` from the `daily_content` feature. This entirely shatters the vertical slice isolation principle.
* **Required Fix:** Move `asma_ul_husna_name_of_the_day_card.dart` out of the `asma_ul_husna` feature and into the `daily_content/presentation/widgets/` directory. Alternatively, refactor the widget to be a "dumb" UI component that accepts only the `AsmaulHusnaModel` via constructor, pushing the state observation up to its parent in `daily_content`.

### 2. Typography Rules Violation (`.copyWith` restrictions)
* **File:** `lib/features/asma_ul_husna/presentation/widgets/share_card/asma_ul_husna_share_card.dart`
* **Lines:** 79-82, 89-94, 137-140
* **Rule Broken:** `CLAUDE.md` - Section C, Rule 10 & Section F (`NEVER use .copyWith to modify fontSize, fontWeight, color, or fontFamily`).
* **Description:** The code uses `.copyWith` to arbitrarily override `fontSize` and `color` on centralized text styles (e.g., `fontSize: 34`, `fontSize: 18`, `color: AppColors.textPrimary`).
* **Required Fix:** Remove all `.copyWith` overrides for `fontSize` and `color`. Create the missing definitive typography styles inside `core/theme/fonts/app_text_styles.dart` and reference them natively.

## 🟠 HIGH VIOLATIONS

### 3. Ad-Hoc UI Decoration & Hardcoded Colors
* **File:** `lib/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart`
* **Lines:** 50-64
* **Rule Broken:** `CLAUDE.md` - Section B, Rule 1 (`Never create ad-hoc decorations`) & `PROJECT_CONTEXT.md` Section C (`Use featureCardDecoration()`).
* **Description:** An inline custom `BoxDecoration` is created with a hardcoded shadow color (`Colors.black.withValues(...)`).
* **Required Fix:** Strip the entire `BoxDecoration` block. Apply `featureCardDecoration()` from `core/common/decorations/feature_card_decoration.dart`. If dynamic borders are needed for the `_isExpanded` state, wrap or modify via strict theme extensions, not ad-hoc box shadows.

### 4. Hardcoded Arabic UI Strings
* **File:** `lib/features/asma_ul_husna/presentation/widgets/skeletonizer_loading_asma_ul_husna_view.dart`
* **Lines:** 18-20
* **Rule Broken:** `CLAUDE.md` - Section B, Rule 2 (`All user-facing Arabic text MUST be centralized... No inline Arabic strings allowed`).
* **Description:** Dummy Arabic strings (`'الله'`, `'معنى مختصر للاسم الحسنى'`) are hardcoded directly into the Dart file for the skeleton loader.
* **Required Fix:** Extract these skeleton placeholder texts into `AppStrings` (`core/constants/app_strings.dart`) and reference them statically.

### 5. Hardcoded Spacing and Dimensions (No Tokens)
* **File:** `lib/features/asma_ul_husna/presentation/widgets/share_card/asma_ul_husna_share_card.dart`
* **Lines:** 49, 74, 84, 104, 132, 145 
* **Rule Broken:** `CLAUDE.md` - Section F (`DON'T hardcode colors, spacing, or font sizes — use design tokens`).
* **Description:** The layout relies heavily on naked numbers (`EdgeInsets.symmetric(horizontal: 24, vertical: 48)`, `SizedBox(height: 24)`, `width: 40`).
* **Required Fix:** Replace all raw integer/double spacing values with `AppSpacing` tokens (e.g., `AppSpacing.h24`, `AppSpacing.v48`).

## 🟡 MEDIUM VIOLATIONS

### 6. Error Swallowing in Data Source Layer
* **File:** `lib/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart`
* **Lines:** 35-44
* **Rule Broken:** `CLAUDE.md` - Section E (`Catch at the outermost boundary only — don't swallow errors in nested functions`).
* **Description:** The `getNames()` method catches JSON parsing exceptions, logs them, and safely returns an empty list `[]`. This completely hides the crash from the repository layer, forcing the repository to misinterpret a catastrophic parsing failure as a simple `MissingData` scenario.
* **Required Fix:** Remove the empty list return logic inside the `catch` block. `rethrow` the exception so the repository layer (`asma_ul_husna_repository.dart`) can correctly catch it and return an `ApiResult.failure(Failure.cache(...))`.

### 7. Code Generation Legacy (Freezed)
* **File:** `lib/features/asma_ul_husna/presentation/cubit/asma_ul_husna_state.dart`
* **Rule Broken:** `CLAUDE.md` - Section C, Rule 2 (`No Code Generation. No Freezed. Use Dart 3+ native features instead`).
* **Description:** The state management relies on `freezed` for `AsmaUlHusnaState`. While existing files have a grandfather clause, strict adherence requires modernizing it.
* **Required Fix:** Rewrite `AsmaUlHusnaState` using Dart 3 `sealed class` and exhaustive pattern matching. Remove the `.freezed.dart` part files to achieve complete feature purity.

## 🟢 LOW VIOLATIONS

### 8. Unresponsive Container Constraints
* **File:** `lib/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart`
* **Lines:** 80-81
* **Rule Broken:** `CLAUDE.md` - Section C, Rule 10 (`Strict Responsive Sizing & Typography`).
* **Description:** Container sizes for the ID circle are explicitly declared as `width: 32` and `height: 32` without responsiveness.
* **Required Fix:** Update dimensions to use explicit UI scaling context: `width: 32.r(context)` and `height: 32.r(context)`.

---
**Audit Summary:** 
The feature correctly implements the simplified Tier 2 Clean Architecture structure (successfully omitting a redundant Domain layer as specified in `PROJECT_CONTEXT.md`). However, it suffers heavily from severe UI hygiene issues (naked hardcoding, typography hacks) and a critical feature-isolation violation (`asma_ul_husna_name_of_the_day_card.dart`) that compromises the entire modularity of the project. Fix the Layer Bleeding immediately.
