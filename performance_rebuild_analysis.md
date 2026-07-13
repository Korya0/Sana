# Flutter Performance Rebuild Analysis Report

## Issue 1

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\main.dart`
**Widget Name:** `SanaApp`
**The Issue:** Misuse of State Management / High-level `BlocBuilder`.
The `BlocBuilder<AppCubit, AppState>` on line 69 wraps the entire `MaterialApp.router`. This means that any state change in `AppCubit` (specifically affecting `state.themeMode` on line 76) will cause the entire `MaterialApp.router` and all its descendants to rebuild. If `AppCubit` manages states other than just `themeMode` that change frequently, this will lead to unnecessary and widespread rebuilds of the application UI.
**Impact:** High. Rebuilding the entire `MaterialApp` is a very expensive operation and can severely impact perceived performance and animation smoothness.
**Proposed Solution:**
1.  **Refactor `AppCubit`:** If `AppCubit` handles multiple, unrelated states, consider splitting it into smaller, more focused Cubits/Blocs.
2.  **Use `BlocSelector` or `BlocListener`:** If only specific parts of `AppState` trigger rebuilds, use `BlocSelector` to narrow down the rebuild scope to only the widgets that depend on that specific state part. Use `BlocListener` for side effects without rebuilding.
3.  **Extract Theme Logic:** If `AppCubit` primarily manages `themeMode`, consider a dedicated `ThemeCubit` (or similar) that only provides theme-related state, and wrap the `MaterialApp`'s `themeMode` property with its `BlocBuilder`.

## Issue 2

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\main.dart`
**Widget Name:** `SanaApp`
**The Issue:** Complex widget tree within `MaterialApp.router`'s `builder` function.
The `builder` property of `MaterialApp.router` (lines 87-117) contains a significant widget tree including `SkeletonizerConfig`, `ResponsiveWrapper`, `MediaQuery`, `GestureDetector`, and a `Stack`. Although the main app content (`child!`) is passed through, any rebuild of the `MaterialApp.router` (as discussed in Issue 1) will cause all these widgets within the `builder` to be re-evaluated and potentially rebuilt. This approach can prevent `const` optimization and makes it harder to isolate rebuilds.
**Impact:** Medium. While some of these are utility widgets, their repeated re-evaluation on every `AppCubit` state change contributes to overall rebuild cost and can be avoided.
**Proposed Solution:**
1.  **Extract to `StatelessWidget`s:** Encapsulate the widget tree within the `builder` into a dedicated `StatelessWidget` (e.g., `_AppWrapper` or `AppShell`).
2.  **Apply `const`:** Once extracted, analyze if the new `StatelessWidget` can be marked `const`, or if its internal widgets (like `ResponsiveWrapper`, `MediaQuery` if their data is stable) can be `const`. This would allow Flutter to skip rebuilding them if their properties haven't changed.

## Issue 3

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\main.dart`
**Widget Name:** `SanaApp`
**The Issue:** Missing `const` keyword on `ResponsiveWrapper` and `MediaQuery`.
`ResponsiveWrapper` (line 97) and `MediaQuery` (line 103) are instantiated without the `const` keyword within the `builder` function. If their properties, such as `onOutsideTap` for `ResponsiveWrapper` or the `data` for `MediaQuery` (`context.noScalingMediaQuery`), remain stable across rebuilds of the `SanaApp` widget, the absence of `const` prevents Flutter from optimizing their rebuilds, forcing a new instance creation and potential rebuild on every parent rebuild.
**Impact:** Low to Medium. This adds unnecessary overhead on each rebuild cycle of `SanaApp`.
**Proposed Solution:**
1.  **Add `const`:** If the properties passed to `ResponsiveWrapper` and `MediaQuery` are truly constant or can be made constant, add the `const` keyword to their instantiations.
2.  **Memoize `MediaQueryData`:** If `context.noScalingMediaQuery` creates a new `MediaQueryData` object on every call, consider memoizing it or ensuring it's only created once if its values are static. This would allow `const MediaQuery` to be used effectively.

## Issue 4

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\asma_ul_husna\presentation\widgets\skeletonizer_loading_asma_ul_husna_view.dart`
**Widget Name:** `SkeletonizerLoadingAsmaUlHusnaView`
**The Issue:** Missing `const` for `AsmaUlHusnaCard` instantiation within `SliverChildBuilderDelegate`.
On line 34, `AsmaUlHusnaCard` is instantiated within `SliverChildBuilderDelegate`. Even though `SkeletonizerLoadingAsmaUlHusnaView` is a `StatelessWidget` and the data (`_dummyList`) is `static final`, the `AsmaUlHusnaCard` itself is not marked `const` at its instantiation site. The `onSharePressed` and `onCopyPressed` are empty function literals (closures), which are new objects on each build. This prevents `AsmaUlHusnaCard` from being a `const` widget, leading to its rebuild every time the `SliverList` rebuilds, even if its underlying data has not changed.
**Impact:** Medium. While this is a loading skeleton, repeated rebuilds of multiple `AsmaUlHusnaCard` instances can still consume unnecessary resources.
**Proposed Solution:**
1.  **Ensure `const` Constructor:** Verify that `AsmaUlHusnaCard` has a `const` constructor.
2.  **Make Callbacks `static const` or `null`:** For a skeleton loading state, the `onSharePressed` and `onCopyPressed` callbacks are likely not intended to be functional. Consider making them `static const` empty functions (e.g., `static const VoidCallback _emptyCallback = (){};`) or passing `null` if the `AsmaUlHusnaCard` constructor allows, to enable `const AsmaUlHusnaCard(...)` instantiation.

## Issue 5

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\asma_ul_husna\presentation\widgets\daily_asma_ul_husna_card.dart`
**Widget Name:** `DailyAsmaUlHusnaCard`
**The Issue:** Closures created on every build for `onSharePressed` and `onCopyPressed`.
Inside the `BlocBuilder` (lines 30-72), the `onSharePressed` and `onCopyPressed` callbacks for `DailyAsmaUlHusnaCardContent` are defined as anonymous functions (closures) on lines 35 and 51. These closures are new objects created on every rebuild of the `BlocBuilder`'s `builder` function, even if the `name` (AsmaUlHusnaEntity) hasn't changed. This prevents `DailyAsmaUlHusnaCardContent` from being a `const` widget and causes it to rebuild unnecessarily, even if its other properties are stable.
**Impact:** Medium. Repeated creation of closures and subsequent rebuilds of `DailyAsmaUlHusnaCardContent` can add noticeable overhead, especially in frequently updated sections of the UI.
**Proposed Solution:**
1.  **Memoize Callbacks:** If possible, memoize the callback functions outside the `build` method. This could involve using a `StatefulWidget` to define and hold the callbacks, or defining them as `static const` if they don't depend on local state.
2.  **Extract to `StatefulWidget`:** Consider making `DailyAsmaUlHusnaCard` a `StatefulWidget` and defining these callbacks once in its `State` class. They can then be passed down as stable references to `DailyAsmaUlHusnaCardContent`, potentially allowing `DailyAsmaUlHusnaCardContent` to be `const`.
3.  **Lift/Push Down Logic:** Re-evaluate if the logic within `onSharePressed` and `onCopyPressed` can be moved to a higher-level widget (if `DailyAsmaUlHusnaCard` were a StatefulWidget) or a more granular, smaller widget that encapsulates the action, reducing the rebuild scope.

## Issue 6

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\asma_ul_husna\presentation\widgets\daily_asma_ul_husna_card.dart`
**Widget Name:** `DailyAsmaUlHusnaCardContent`
**The Issue:** Missing `const` for `DailyContentBaseCard` instantiation and new closure for `onTap`.
On line 91, `DailyContentBaseCard` is instantiated without the `const` keyword. Additionally, the `onTap` callback (line 96) `() => AppNavigator.pushNamed(context, AppRoutes.asmaUlHusna)` is an anonymous function, creating a new closure on every build. These factors prevent `DailyContentBaseCard` from being a `const` widget, leading to its rebuild every time `DailyAsmaUlHusnaCardContent` rebuilds, even if its properties are semantically identical.
**Impact:** Low to Medium. Unnecessary rebuilds of `DailyContentBaseCard` contribute to overall rendering overhead.
**Proposed Solution:**
1.  **Ensure `const` Constructor:** Verify that `DailyContentBaseCard` has a `const` constructor.
2.  **Memoize `onTap`:** If the `onTap` callback does not depend on changing local state, define it as a `static const` function or a stable reference within a `StatefulWidget` (if `DailyAsmaUlHusnaCardContent` were `StatefulWidget`). For this specific navigation, it might be possible to create a `static const` callback if `context` can be accessed in a stable way, or by passing the `BuildContext` directly to a `static` method.
3.  **Add `const`:** If all properties passed to `DailyContentBaseCard` are stable and its constructor is `const`, add the `const` keyword to its instantiation: `const DailyContentBaseCard(...)`.

## Issue 7

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\asma_ul_husna\presentation\widgets\asma_ul_husna_share_card.dart`
**Widget Name:** `AsmaUlHusnaShareCard`
**The Issue:** Methods returning Widgets - `_buildBackgroundIcons`.
The `_buildBackgroundIcons` method (lines 63-86) is a private method within `AsmaUlHusnaShareCard` that returns a `Widget`. This pattern prevents `const` optimization for the `Stack` it returns and its child `Positioned` and `Icon` widgets. Every time `AsmaUlHusnaShareCard` rebuilds, `_buildBackgroundIcons` is called, causing all its internal widgets to be recreated, even if the background icons are static and do not change.
**Impact:** Low to Medium. While the performance impact for a single static element might seem minor, this pattern, if replicated for many UI components, contributes to unnecessary widget recreation and increased build times.
**Proposed Solution:** Extract `_buildBackgroundIcons` into a separate `StatelessWidget` (e.g., `_ShareCardBackgroundIcons`). Since the content of this widget appears static (or depends only on `BuildContext` for theme/sizing), the new widget could be marked `const`, thereby preventing its rebuild when the parent `AsmaUlHusnaShareCard` rebuilds.

## Issue 8

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\asma_ul_husna\presentation\widgets\asma_ul_husna_share_card.dart`
**Widget Name:** `AsmaUlHusnaShareCard` (and its sub-widgets)
**The Issue:** Missing `const` in various widget instantiations.
Numerous widgets within the `build` method of `AsmaUlHusnaShareCard`, `_ShareCardHeader`, and `_ShareCardDivider` are not marked `const` even when their properties are constant or derived from constant values. Examples include `Container`, `Padding`, `SizedBox`, `Text`, `Expanded`, and `Icon` widgets. The absence of `const` means Flutter cannot optimize these widgets, forcing them to be re-evaluated and potentially rebuilt on every parent rebuild.
**Impact:** Low. Individually, the impact is small. However, the cumulative effect across many small widgets can lead to noticeable performance degradation and increased CPU usage, especially in complex UIs or when a parent widget rebuilds frequently.
**Proposed Solution:** Systematically review all widget instantiations within these `build` methods. Apply the `const` keyword wherever possible, especially for widgets whose properties are stable. For widgets whose properties are derived from `context` (e.g., `AppSpacing.v24.r(context)`, `context.color.primary.withValues(...)`), ensure that the helper functions return `const` values or are memoized to allow `const` usage where appropriate.

## Issue 9

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\asma_ul_husna\presentation\widgets\asma_ul_husna_card.dart`
**Widget Name:** `AsmaUlHusnaCard` (StatefulWidget) and `_AsmaUlHusnaCardState`
**The Issue:** `setState` on `onExpansionChanged` causing rebuild of entire `AppToggleList` children.
On line 31, `setState(() => _isExpanded = expanded)` is called within the `onExpansionChanged` callback of `AppToggleList`. While `_isExpanded` primarily affects the `maxLines` and `overflow` properties of a `Text` widget and the `direction` of an `AppArrowIcon`, changing this state causes the *entire* `_AsmaUlHusnaCardState` to rebuild. This leads to the re-evaluation and potential rebuilding of all widgets within the `build` method, including those that do not depend on the `_isExpanded` state (e.g., `CombinedShareCopyButton`).
**Impact:** Medium. For a single card, rebuilding several widgets might be acceptable. However, in a list with many such cards, frequent expansions/collapses could lead to significant cumulative rebuild overhead.
**Proposed Solution:**
1.  **Localize State with `ValueListenableBuilder` or `AnimatedBuilder`:** Instead of using `setState` on the entire `State` object, use a `ValueNotifier<bool>` (and `ValueListenableBuilder`) or `AnimationController` (and `AnimatedBuilder`) to manage `_isExpanded`. Wrap only the widgets that truly depend on `_isExpanded` (the `Text` and `AppArrowIcon`) with these builders to limit the rebuild scope.
2.  **Extract Dependent Widgets:** Extract the `Text` widget (lines 46-57) and `AppArrowIcon` (lines 69-73) into separate `StatelessWidget`s. Pass `_isExpanded` to them as a parameter. While this still causes them to rebuild, it isolates the rebuild from other unaffected sibling widgets.

## Issue 10

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\asma_ul_husna\presentation\widgets\asma_ul_husna_card.dart`
**Widget Name:** `_AsmaUlHusnaCardState`
**The Issue:** Closures created on every build for `AppToggleList`'s `title` and `trailing`.
The `title` and `trailing` properties of `AppToggleList` (lines 33-59 and 60-75) are built directly within the `_AsmaUlHusnaCardState`'s `build` method. This results in new `Row` widgets, `SizedBox`s, `Text`s, `CombinedShareCopyButton`, and `AppArrowIcon` instances being created on every rebuild of `_AsmaUlHusnaCardState`. Even if their content (derived from `widget.name`) is stable, the widgets themselves are recreated, leading to unnecessary computation.
**Impact:** Medium. This adds overhead on every rebuild of the card, especially when the card's expansion state changes frequently.
**Proposed Solution:**
1.  **Extract to `StatelessWidget`s:** Create dedicated `StatelessWidget`s for the `title` and `trailing` content of `AppToggleList` (e.g., `_AsmaCardTitleWidget` and `_AsmaCardTrailingWidget`). Pass only the necessary data (`widget.name`, `widget.onSharePressed`, `widget.onCopyPressed`, `_isExpanded`) to these new widgets.
2.  **Apply `const` to Extracted Widgets:** If the newly extracted `StatelessWidget`s can be made `const` (by ensuring all their properties are stable and their constructors are `const`), this would prevent their rebuild when the parent `AsmaUlHusnaCard` expands/collapses.

## Issue 11

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\asma_ul_husna\presentation\widgets\asma_ul_husna_card.dart`
**Widget Name:** `_AsmaUlHusnaCardState`
**The Issue:** Missing `const` in various widget instantiations.
Numerous widgets within the `build` method of `_AsmaUlHusnaCardState` are not marked `const` even when their properties are constant or derived from constant values. Examples include `SizedBox` (line 35), `Text` (lines 37, 46, 79), `AppGap.w` (line 44, 68), `AppGap.h` (lines 78, 87), `CustomAppDivider` (line 77), and `CombinedShareCopyButton` (line 63). The absence of `const` prevents Flutter from optimizing these widgets, leading to their re-evaluation and potential rebuilding on every parent rebuild.
**Impact:** Low. Individually, the impact is small. However, the cumulative effect across many small widgets can lead to noticeable performance degradation and increased CPU usage, especially when the parent widget rebuilds frequently.
**Proposed Solution:** Systematically review all widget instantiations within the `build` method. Apply the `const` keyword wherever possible, especially for widgets whose properties are stable. For widgets whose properties are derived from `context` (e.g., `AppSpacing.w80.r(context)`, `context.color.textSecondary.withValues(...)`), ensure that the helper functions return `const` values or are memoized to allow `const` usage where appropriate.

## Issue 12

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\teaching_prayer\presentation\widgets\teaching_topic_details_bottom_sheet.dart`
**Widget Name:** `TeachingTopicDetailsBottomSheet` (StatelessWidget)
**The Issue:** Closures created on every build for `topic.points.map` and `span.spans.map`.
On line 72, `topic.points.map((point) { ... }).toList()` creates a new list of widgets (`Padding`, `RichText`, `TextSpan`) on every rebuild of `TeachingTopicDetailsBottomSheet`. Similarly, within each `RichText` (line 75), `point.spans.map((span) { ... }).toList()` (line 77) creates a new list of `TextSpan`s. Even though `sectionTitle` and `topic` are `final` properties, the recreation of these lists and their contained widgets occurs on every rebuild of the `BottomSheet` or its parent, leading to unnecessary widget tree re-evaluation and recreation.
**Impact:** Medium to High. This widget displays potentially extensive textual content. Repeated recreation of numerous `Padding`, `RichText`, and `TextSpan` widgets can be computationally expensive and impact scrolling performance or overall responsiveness, especially for longer topics.
**Proposed Solution:**
1.  **Extract `RichText` creation to a `StatelessWidget`:** Create a dedicated `StatelessWidget` (e.g., `_TeachingPointWidget`) that takes a `TeachingPrayerTopicPointEntity`, `defaultStyle`, and `highlightStyle` as parameters. The `map` operation for `TextSpan`s would then be encapsulated within this new widget's `build` method.
2.  **Memoize Child Widget List:** If the `topic.points` list and its content are truly immutable and stable across parent rebuilds, consider memoizing the result of `topic.points.map(...)` outside the `build` method. However, since `defaultStyle` and `highlightStyle` depend on `context`, they would need to be passed to the memoized list or recreated efficiently within the extracted `_TeachingPointWidget`.
3.  **Apply `const`:** If the extracted `_TeachingPointWidget` can have a `const` constructor and its properties are stable, then the `map` function could return `const _TeachingPointWidget(...)` instances, allowing Flutter to optimize their rebuilds.

## Issue 13

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\teaching_prayer\presentation\widgets\teaching_topic_details_bottom_sheet.dart`
**Widget Name:** `TeachingTopicDetailsBottomSheet` (StatelessWidget)
**The Issue:** Missing `const` in various widget instantiations.
Several widgets within the `build` method are not marked `const`, even when their properties are constant or derived from constant values. Examples include `ConstrainedBox` (line 29), `Column` (line 33), `Center` (lines 37, 47), `Text` (lines 38, 49), `Flexible` (line 57), `Container` (line 58), and `Padding` (line 73). The absence of `const` means Flutter cannot optimize these widgets, forcing their re-evaluation and potential rebuilding on every parent rebuild.
**Impact:** Low. The cumulative effect of not using `const` on many small widgets can contribute to unnecessary rendering overhead and slightly impact performance.
**Proposed Solution:** Systematically review all widget instantiations within the `build` method. Apply the `const` keyword wherever possible, especially for widgets whose properties are stable. Be mindful that properties derived from `context` (e.g., `MediaQuery.sizeOf(context).height`, `AppTextStyles.font14W500(context).copyWith(...)`, `context.color.textPrimary.withValues(...)`) can prevent direct `const` usage unless these style definitions or size calculations are themselves memoized or made `static const` where appropriate.

## Issue 14

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\teaching_prayer\presentation\widgets\teaching_section_card.dart`
**Widget Name:** `TeachingSectionCard` (StatelessWidget)
**The Issue:** Closures created on every build for `section.topics.map` and `onTap` for `_TopicChip`.
On line 42, `section.topics.map((topic) { ... }).toList()` creates a new list of `_TopicChip` widgets on every rebuild of `TeachingSectionCard`. For each `_TopicChip`, an anonymous `onTap` function is created (lines 45-53) which involves an `async` call to `showCustomBottomSheet` and instantiates a new `TeachingTopicDetailsBottomSheet`. This entire sequence (new list, new closures, new `TeachingTopicDetailsBottomSheet` instance) occurs on every rebuild of `TeachingSectionCard`, even if the underlying `section` data has not changed.
**Impact:** Medium to High. Frequent rebuilds of `TeachingSectionCard` (e.g., due to parent state changes) will lead to substantial resource consumption from the repeated creation of `_TopicChip` instances, their `onTap` callbacks, and new `TeachingTopicDetailsBottomSheet` objects. This can significantly affect UI responsiveness and overall performance, especially with many topics.
**Proposed Solution:**
1.  **Extract `_TopicChip` creation to a `StatelessWidget`:** Create a new `StatelessWidget` (e.g., `_TopicChipDisplay`) that takes `topic` and `sectionTitle` as parameters. This new widget would be responsible for building the `_TopicChip` and handling its `onTap` logic. This helps isolate the rebuilds.
2.  **Optimize `_TopicChip` and `onTap`:** Ensure `_TopicChip` itself can be `const` by verifying its constructor and ensuring its `onTap` callback is stable. If the `onTap` callback cannot be `const` directly due to its dependence on `context` and `topic`, consider making `_TopicChip` a `StatefulWidget` to manage the callback's lifecycle efficiently, or use a method that memoizes the callback creation.

## Issue 15

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\teaching_prayer\presentation\widgets\teaching_section_card.dart`
**Widget Name:** `TeachingSectionCard` (and its sub-widgets) and `_TopicChip`
**The Issue:** Missing `const` in various widget instantiations.
Many widgets within the `build` methods of `TeachingSectionCard` and `_TopicChip` are not marked `const`, even when their properties are constant or derived from constant values. Examples include `Container` (lines 15, 26, 77), `Column` (line 17), `Text` (lines 19, 90), `Wrap` (line 38), `Material` (line 72), `InkWell` (line 74), and `Padding` (line 78). The consistent absence of `const` prevents Flutter from performing compile-time optimizations, leading to these widgets being re-evaluated and potentially rebuilt on every parent rebuild, even if their visual representation is unchanged.
**Impact:** Low. While individual instances may have a small impact, the cumulative effect across numerous widgets throughout the application can lead to noticeable performance degradation and increased CPU cycles.
**Proposed Solution:** Systematically review all widget instantiations within the `build` methods of `TeachingSectionCard` and `_TopicChip`. Apply the `const` keyword wherever possible, especially for widgets whose properties are stable and do not depend on `BuildContext` in a way that creates new objects on every build. For properties derived from `context` (e.g., `AppTextStyles.font16W700(context).copyWith(...)`, `context.color.secondaryScaffoldBackgroundColor.withValues(...)`), consider optimizing these helper functions to return `const` values or memoize their results to enable broader `const` usage.

## Issue 16

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\teaching_prayer\presentation\widgets\teaching_prayer_success_widget.dart`
**Widget Name:** `TeachingPrayerSuccessWidget` (StatelessWidget)
**The Issue:** `AnimatedSliverList`'s `itemContentBuilder` creates new `TeachingSectionCard` instances.
On line 19, the `itemContentBuilder` lambda for `AnimatedSliverList` creates a new `TeachingSectionCard` instance for each `section` in the `sections` list. Although `AnimatedSliverList` efficiently handles list animations, the `itemContentBuilder` is invoked for each visible item whenever `TeachingPrayerSuccessWidget` rebuilds. Since `TeachingSectionCard` itself is not `const` (as identified in previous analysis for `teaching_section_card.dart`), new instances of `TeachingSectionCard` are created unnecessarily, even if the `section` data remains unchanged.
**Impact:** Medium. While `AnimatedSliverList` helps with overall list performance, the repeated creation of `TeachingSectionCard` instances, especially if `TeachingSectionCard` has its own internal rebuild inefficiencies (e.g., closures, missing `const` in its children), can lead to noticeable performance overhead when the parent `TeachingPrayerSuccessWidget` rebuilds.
**Proposed Solution:**
1.  **Ensure `TeachingSectionCard` has a `const` constructor:** The most impactful solution is to ensure `TeachingSectionCard` has a `const` constructor. This would allow `const TeachingSectionCard(key: ValueKey(section.id), section: section)` to be used within the `itemContentBuilder`, enabling Flutter to perform compile-time optimizations and skip rebuilds of individual cards if their `section` data (and `id`) has not changed.
2.  **Optimize `TeachingSectionCard` Internals:** Address the previously identified performance issues within `teaching_section_card.dart` (Issues 14 and 15) to minimize the internal rebuild costs of `TeachingSectionCard`. This will further reduce the impact of its recreation.

## Issue 17

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\teaching_prayer\presentation\widgets\teaching_prayer_success_widget.dart`
**Widget Name:** `TeachingPrayerSuccessWidget` (StatelessWidget)
**The Issue:** Missing `const` for `CustomScrollView`'s `slivers` content.
`CustomScrollView` (line 14) contains a `slivers` list, but `CommonSliverAppBar` (line 16) and `AnimatedSliverList` (line 17) are not marked `const` at their instantiation sites. `CommonSliverAppBar` is likely a stateless widget and could potentially be `const` if its properties are constant. While `AnimatedSliverList` handles dynamic data, ensuring `const` where possible, even for its initial setup, contributes to better overall performance.
**Impact:** Low. Individual missing `const` keywords contribute to minor overhead. The cumulative effect across the application is more significant.
**Proposed Solution:**
1.  **Add `const` to `CommonSliverAppBar`:** If `CommonSliverAppBar` has a `const` constructor and its `title` is a `const` string (e.g., `AppStrings.teachPrayer`), mark it `const CommonSliverAppBar(title: AppStrings.teachPrayer)`.
2.  **Ensure `AnimatedSliverList`'s `itemContentBuilder` returns `const` widgets:** As discussed in Issue 16, ensuring that the `itemContentBuilder` can return `const` `TeachingSectionCard` instances will significantly improve the performance of the list.

## Issue 18

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\asma_ul_husna\presentation\views\asma_ul_husna_view.dart`
**Widget Name:** `AsmaUlHusnaView` (StatelessWidget)
**The Issue:** `BlocBuilder` high in the tree and `state.when` leads to widespread rebuilds.
The `BlocBuilder<AsmaUlHusnaCubit, AsmaUlHusnaState>` (lines 33-64) is placed directly inside the `CustomScrollView`'s `slivers`. It uses `state.when` to conditionally render different sliver widgets (`SkeletonizerLoadingAsmaUlHusnaView`, `AnimatedSliverList`, or `SliverFillRemaining` with `AppErrorView`). This means that any state change in `AsmaUlHusnaCubit` (e.g., from `initial` to `loading`, then to `loaded`) will cause the entire `BlocBuilder` to rebuild, and consequently, the *entire* conditionally rendered sliver widget to be replaced/rebuilt. If `AsmaUlHusnaCubit` emits frequent updates for reasons other than major state transitions, this could lead to unnecessary and expensive full rebuilds of the entire content area.
**Impact:** High. Rebuilding large sections of a `CustomScrollView` that contains potentially many list items or complex error views is a computationally expensive operation and can significantly affect UI performance.
**Proposed Solution:**
1.  **Fine-grain `BlocBuilder` Usage:** If only specific parts of the UI depend on particular `AsmaUlHusnaState` values, consider using `BlocSelector` or `BlocBuilder` at a lower level in the widget tree to wrap only those specific widgets. This helps isolate rebuilds to only the necessary components.
2.  **Optimize `state.when` branches:** Ensure that the widgets returned by each branch of `state.when` (e.g., `SkeletonizerLoadingAsmaUlHusnaView`, `AppErrorView`) are `const` or as efficient as possible. While `AnimatedSliverList` requires dynamic data, its children should be optimized for `const` where applicable.

## Issue 19

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\asma_ul_husna\presentation\views\asma_ul_husna_view.dart`
**Widget Name:** `AsmaUlHusnaView` (StatelessWidget)
**The Issue:** Closures created on every build for `AsmaUlHusnaCard`'s `onSharePressed` and `onCopyPressed`.
Within `AnimatedSliverList`'s `itemContentBuilder` (lines 40-52), the `onSharePressed` and `onCopyPressed` callbacks for `AsmaUlHusnaCard` are defined as anonymous functions (closures). These closures are new objects created on every call to `itemContentBuilder` for each visible item in the list. Since these callbacks depend on `context` and the specific `name` (`AsmaUlHusnaEntity`) of the item, they cannot be `const`. However, recreating new closures for every list item on every rebuild of the `AnimatedSliverList` (or its parent `BlocBuilder`) contributes to unnecessary work and causes the `AsmaUlHusnaCard` instances to rebuild, even if their data (`name`) has not changed.
**Impact:** Medium. This is a common anti-pattern in Flutter lists. For lists with many items, the cumulative effect of creating numerous new closure objects and forcing `AsmaUlHusnaCard` rebuilds can lead to noticeable performance overhead and increased CPU usage.
**Proposed Solution:**
1.  **Extract `AsmaUlHusnaCard` with callbacks to a `StatelessWidget`:** Create a new `StatelessWidget` (e.g., `_AsmaCardWithShareActions`) that encapsulates `AsmaUlHusnaCard` and its `onSharePressed` and `onCopyPressed` logic. This new widget can then manage its own callbacks more efficiently, potentially making them stable references or methods within its `State` if it were `StatefulWidget`.
2.  **Optimize `AsmaUlHusnaCard` constructor:** Ensure `AsmaUlHusnaCard` itself has a `const` constructor. If the callbacks can be made stable references (e.g., by making the extracted wrapper widget a `StatefulWidget` to manage its own callbacks, or by memoizing them effectively), then `const AsmaUlHusnaCard(...)` instantiation could be achieved, preventing unnecessary rebuilds of the card itself.

## Issue 20

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\teaching_prayer\presentation\views\teaching_prayer_view.dart`
**Widget Name:** `TeachingPrayerView` (StatelessWidget)
**The Issue:** `BlocBuilder` high in the tree and `switch` statement leading to widespread rebuilds.
The `BlocBuilder<TeachingPrayerCubit, TeachingPrayerState>` (lines 18-43) is placed directly as the `body` of the `Scaffold`. It uses a `switch` statement (line 20) to conditionally render different widgets based on the `TeachingPrayerState` (`Skeletonizer` with `TeachingPrayerSuccessWidget`, `AppErrorView`, or `TeachingPrayerSuccessWidget`). This means any state change in `TeachingPrayerCubit` will cause the *entire* `BlocBuilder` to rebuild, and in turn, the *entire* conditionally rendered widget to be replaced/rebuilt. If `TeachingPrayerCubit` emits frequent state updates (e.g., for progress indicators or minor changes not directly related to these major UI states), it could lead to significant unnecessary work.
**Impact:** High. Rebuilding the entire `Scaffold` body and its complex children (`Skeletonizer`, `TeachingPrayerSuccessWidget` with its lists, or `AppErrorView`) is computationally expensive and can significantly affect UI performance.
**Proposed Solution:**
1.  **Fine-grain `BlocBuilder` Usage:** If possible, move the `BlocBuilder` lower in the widget tree to wrap only the specific parts of the UI that absolutely need to react to state changes from `TeachingPrayerCubit`. For example, if only the list of sections within `TeachingPrayerSuccessWidget` needs to update, place the `BlocBuilder` around `AnimatedSliverList` instead of the entire `Scaffold` body.
2.  **Optimize `switch` branches:**
    *   **`Skeletonizer` branch (lines 21-32):** If the dummy sections used for the skeleton are truly static, they could be declared as `static const List<TeachingPrayerSectionEntity> _dummySections = ...;` to avoid recreating the list on every rebuild.
    *   **`AppErrorView` branch (lines 33-38):** The `onRetry` callback creates a new closure on every rebuild. See Issue 21 for a more detailed solution.
    *   **`TeachingPrayerSuccess` branch (lines 39-40):** The `TeachingPrayerSuccessWidget(sections: sections)` is instantiated without `const`. Ensure `TeachingPrayerSuccessWidget` has a `const` constructor and its internal widgets are also optimized for `const` where possible (refer to Issues 16 and 17).

## Issue 21

**File Path:** `D:\flutter\flutter_Projects\muslim_app\lib\features\teaching_prayer\presentation\views\teaching_prayer_view.dart`
**Widget Name:** `TeachingPrayerView` (StatelessWidget)
**The Issue:** Missing `const` and closure creation in `AppErrorView`'s `onRetry` callback.
In the `TeachingPrayerError` state (lines 33-38), `AppErrorView` is instantiated with an `onRetry` callback defined as an anonymous function (`() => unawaited(context.read<TeachingPrayerCubit>().loadSections())`). This closure is a new object created on every rebuild of the `BlocBuilder`, even if the error message or other parts of the `AppErrorView` are static. This prevents `AppErrorView` from being a `const` widget (if it could be otherwise) and contributes to unnecessary widget recreation and re-evaluation.
**Impact:** Low to Medium. While an error view might not rebuild as frequently as active content, the unnecessary creation of a closure and prevention of `const` optimization adds overhead. If the error state is entered and exited frequently, the impact would be more noticeable.
**Proposed Solution:**
1.  **Make `AppErrorView` `const` and take a stable callback:** If `AppErrorView` can be made `const`, ensure its constructor is `const` and that its `onRetry` parameter accepts a `VoidCallback`. This `VoidCallback` should ideally be a stable, non-recreating reference.
2.  **Pass a stable callback to `AppErrorView`:** Consider defining the `onRetry` callback as a private method within a `StatefulWidget` (if `TeachingPrayerView` were `StatefulWidget`) or as a `static` method if it doesn't require a dynamically captured `context`. Alternatively, if `AppErrorView` is intended to be a simple, non-rebuilding widget, the `context.read<TeachingPrayerCubit>().loadSections()` call could potentially be wrapped in a `MemoizedCallback` (from a utility library) if available, to provide a stable reference to `AppErrorView`.
