# Daily Content Feature Architectural Violations Report

## 1. Cross-Feature Dependency Leak (Critical)
- **File:** `lib/features/daily_content/presentation/cubit/daily_content_cubit.dart`
- **Lines:** 7, 8 (Imports), 16, 24, 34, 43, 64-68, 79-82, 102-105 (Usages)
- **Rule Broken:** 
  - `CLAUDE.md` Section A.2: "No cross-feature imports — features are isolated vertical slices."
  - `CLAUDE.md` Section F: "DON'T import from one feature into another."
  - `PROJECT_CONTEXT.md` Layer Dependency Matrix: "Features: Cannot Depend On Other features (no cross-feature imports)."
- **Violation Details:** `DailyContentCubit` directly imports and relies on `IAsmaUlHusnaRepository` and `AsmaulHusnaModel` from the `asma_ul_husna` feature.
- **Fix:** Remove all dependencies on `asma_ul_husna` from `daily_content`. If multiple contents need to be aggregated on a single screen, the UI layer (Views/Widgets) should use multiple Cubits (via `MultiBlocBuilder` or separate `BlocBuilder`s) rather than one Cubit orchestrating another feature's repository.

## 2. Logic Leak to UI Layer (High)
- **File:** `lib/features/daily_content/presentation/views/daily_content_favorites_view.dart`
- **Line:** 149-151
- **Rule Broken:** `CLAUDE.md` Section C.9: "Move all data transformation or parsing logic (e.g. string formatting, Regex parsing) from the UI layer to the Data Layer (Models). Presentation widgets should be as simple and Stateless as possible, receiving 'ready-to-render' data from models."
- **Violation Details:** String truncation logic `(item.content.length > 30 ? '${item.content.substring(0, 30)}...' : item.content)` is performed directly inside the `build` method.
- **Fix:** Move this logic into `DailyContentModel` as a getter (e.g., `String get shortContent => content.length > 30 ? '${content.substring(0, 30)}...' : content;`) and call `item.shortContent` in the UI.

## 3. Typography `copyWith` Restriction (High)
- **File:** `lib/features/daily_content/presentation/widgets/card/daily_content_base_card.dart`
- **Line:** 176
- **Rule Broken:** `CLAUDE.md` Section C.10: "NEVER use `.copyWith` to modify `fontSize`, `fontWeight`, `color`, or `fontFamily`. Use it ONLY for secondary properties (e.g., `height` for line spacing)."
- **Violation Details:** Uses `.copyWith(color: AppColors.primary.withValues(alpha: 0.7))` to change the text color.
- **Fix:** Use an existing text style from `AppTextStyles` that has the correct color. If opacity is strictly needed on a standard color, wrap the `Text` widget with an `Opacity` widget instead of modifying the text style color inline.

## 4. Hardcoded Arabic Strings (High)
- **Files & Lines:** 
  - `lib/features/daily_content/presentation/widgets/card/daily_content_base_card.dart` (Line: 126) - `'شرح'`
  - `lib/features/daily_content/presentation/widgets/share_card/daily_content_share_card.dart` (Line: 30) - `title?.contains('حديث') == true`
  - `lib/features/daily_content/data/constants/religious_event_display_names.dart` (Lines: 7-25) - `'رأس السنة الهجرية'`, etc.
- **Rule Broken:** `CLAUDE.md` Section B.2: "All user-facing Arabic text MUST be centralized in a single strings constant. No inline Arabic strings allowed." & Section F: "DON'T hardcode Arabic strings — add them to centralized strings."
- **Violation Details:** Hardcoded Arabic strings are used directly in code and condition checks.
- **Fix:** Move all Arabic strings to `AppStrings` in `core/constants/app_strings.dart` and reference them via `AppStrings.stringName`. For the string comparison (`contains('حديث')`), use `AppStrings.hadith` or preferably rely on the model's `category` enum (`DailyContentType.hadith`) instead of matching strings.

## 5. Hardcoded Spacing and Magic Numbers (Medium)
- **Files & Lines:**
  - `daily_content_share_card.dart` (Lines: 55, 66, 77, 87) - `EdgeInsets.symmetric(horizontal: 24, vertical: 40)`, `SizedBox(height: 20)`, `SizedBox(height: 48)`
  - `daily_content_share_card.dart` (Lines: 46-50) - `right: -10, bottom: -20`, `size: 150`
  - `daily_content_favorites_view.dart` (Lines: 127-131) - `right: -10, bottom: -20`, `size: 150`
  - `daily_content_base_card.dart` (Lines: 49, 53) - `right: -10, bottom: -10`, `size: 140`
  - `daily_content_explanation_dialog.dart` (Line: 62-63) - `width: 6, height: 6`
- **Rule Broken:** `CLAUDE.md` Section F: "DON'T hardcode colors, spacing, or font sizes — use design tokens from core/theme/" & "DON'T use magic numbers — extract to named constants."
- **Violation Details:** Using raw double values for paddings, sizes, and positioning instead of standardizing through `AppSpacing` or extracting to local named constants.
- **Fix:** Replace all hardcoded spacing values (like `20`, `24`, `40`, `48`) with `AppSpacing` tokens (e.g., `AppSpacing.v20`, `AppSpacing.v24`). For purely aesthetic dimension numbers like `-10`, `150`, or `6`, extract them into local constant variables with semantic names.

## 6. Raw Exception Throwing inside Cubit (Medium)
- **File:** `lib/features/daily_content/presentation/cubit/daily_content_cubit.dart`
- **Lines:** 96, 100, 104
- **Rule Broken:** `CLAUDE.md` Section F: "DON'T throw raw exceptions..."
- **Violation Details:** The code uses `orElse: () => throw Exception(),` inside the Cubit when attempting to unwrap `ApiResult`.
- **Fix:** Remove the `throw Exception()`. Use exhaustive pattern matching (like `hadithRes is Success`) or safely unwrap the values since the code previously checks for failures using the `hasFailure` boolean.
