# Qibla Feature Architectural Violations Report

## Summary
The `qibla` feature follows the **Tier 1 (Full Clean Architecture)** structure as required. However, there are several violations related to **responsive scaling**, **dependency injection in build methods**, **naming conventions**, and **logic leaks** into the presentation layer. The most critical issue is the lack of `.r(context)` scaling for custom UI dimensions.

---

## 1. Critical Violations

### [Critical] Missing Responsive Scaling (Dimensions)
- **File**: `lib/features/qibla/presentation/widgets/compass/qibla_compass.dart`
- **Line**: 23, 34-35
- **Broken Rule**: Section C, 10: "Use `.r(context)` in the UI only for other dimensions (e.g., icons, custom container sizes, image heights)."
- **Violation**: The compass size (300.0) is used as a static double without the required `.r(context)` scaling. This will cause the compass to look disproportionate on different screen sizes.
- **Action**: Change `const size = QiblaConstants.compassSize;` to `final size = QiblaConstants.compassSize.r(context);` (and move it inside the `build` method).

---

## 2. High Severity Violations

### [High] Logic Leak & Improper DI Usage in Build
- **File**: `lib/features/qibla/presentation/widgets/loaded/qibla_compass_stream_widget.dart`
- **Line**: 18-28
- **Broken Rule**: Section A, 19: "UI/presentation layer has ZERO business logic"; Section C, 117: "Cubits, use cases, and repositories are resolved via `get_it`, not instantiated manually"; Section C, 7: "NEVER create ... expensive objects inside `build()`".
- **Violation**: 
    1. The widget directly accesses `FlutterCompass.events` and performs stream mapping logic. 
    2. It calls `sl<GetQiblaCompassStreamUseCase>()` inside the `build` method, creating a new stream instance on every widget rebuild (performance risk for a high-frequency compass UI).
- **Action**: 
    1. Move the stream initialization to the `QiblaCubit` or a dedicated Repository/Service.
    2. The Cubit should provide the mapped stream to the widget, or the UseCase should be injected into the widget via constructor (provided by the view).

### [High] State Naming Convention
- **File**: `lib/features/qibla/presentation/cubit/qibla_state.dart`
- **Line**: 13
- **Broken Rule**: Section D, 162: "State variants → `Feature` + `Initial/Loading/Success/Error`".
- **Violation**: The success state is named `QiblaLoaded` instead of `QiblaSuccess`.
- **Action**: Rename `QiblaLoaded` to `QiblaSuccess` and update all call sites.

---

## 3. Medium Severity Violations

### [Medium] Design System Violation (Typography Overrides)
- **File**: `lib/features/qibla/presentation/widgets/hint/qibla_hint_message.dart`
- **Line**: 27
- **Broken Rule**: Section C, 139: "NEVER use `.copyWith` to modify `fontSize`, `fontWeight`, `color`, or `fontFamily`." (Applies to ad-hoc overrides in general).
- **Violation**: Uses a text style method that accepts a `color` parameter (`AppTextStyles.font16W700(context, color: config.color)`), which is effectively an ad-hoc override of the design system's color tokens.
- **Action**: Add predefined styles in `AppTextStyles` for success/primary hint messages (e.g., `font16W700Success`, `font16W700Primary`) and use them instead of manual overrides.

### [Medium] Missing Responsive Scaling (Icons)
- **File**: `lib/features/qibla/presentation/widgets/qibla_header_info.dart`
- **Line**: 74
- **Broken Rule**: Section C, 10: "Use `.r(context)` in the UI only for other dimensions (e.g., icons...)".
- **Violation**: The icon size uses `AppSpacing.v20` (a spacing token) without `.r(context)` scaling.
- **Action**: Change to `size: 20.r(context)`.

### [Medium] Improper Folder Structure & SRP Violation
- **File**: `lib/features/qibla/data/qibla_constants.dart`
- **Line**: N/A
- **Broken Rule**: Section B, Folder Structure: "Data layer folders: `datasources/`, `models/`, `repos/`, `services/`, `constants/`". Section A, 18: SRP.
- **Violation**: 
    1. The constants file is placed directly in `data/` instead of `data/constants/`.
    2. It contains UI-specific constants (`compassSize`, `kaabaIconSize`) in the data layer, violating layer boundaries.
- **Action**: 
    1. Move the file to `lib/features/qibla/data/constants/qibla_constants.dart`.
    2. Extract UI-related constants to a presentation-layer constants file or use design tokens directly.

---

## 4. Low Severity Violations

### [Low] Magic Numbers in Skeletonizer
- **File**: `lib/features/qibla/presentation/widgets/skeletonizer_qibla_widget.dart`
- **Line**: 13-14
- **Broken Rule**: Section F, 271: "DON'T use magic numbers — extract to named constants".
- **Violation**: Hardcoded values `138` and `1377` used as dummy data for the skeleton loader.
- **Action**: Extract these to a `QiblaConstants` file (in presentation layer) or use zero/neutral values.
