# Azkar Home Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the user-selected package D1:A, D2:A, D3:A, D4:B, D5:A (+ keep the options-sheet entry), D6:A, D7:A, D8:B+C, D9:A on the Azkar/Tasbeeh home screen.

**Architecture:** The tasbeeh area becomes one `AppSectionCard` (counter/start/error states inside it), the azkar area becomes a section header with a visible manage button plus a grid or an in-place state card. The grid keeps circles (no tiles) at 52/24/12px, and gains a one-shot 40 ms staggered entrance. The counter ring gets a one-shot pulse when the recent card appears. No shared core widget is modified.

**Tech Stack:** Flutter 3.47, flutter_bloc, go_router, existing design tokens (`AppSize`, `ColorsLight`, `AppTextStyles`), flutter_test.

**Spec:** `chat.md` (§2 layout, §3 decisions, §4 exact values, §5 must-fix list, §6 copy).

## Global Constraints

- Decisions: D1:A (no app-bar change), D2:A, D3:A, D4:B, D5:A + keep the sheet row, D6:A, D7:A, D8:B+C, D9:A.
- Do not modify shared components: `AppSectionCard`, `AppSectionHeader`, `AppTextButton`, `AppButton`, `AppSliverGrid`, `CommonSliverAppBar`.
- All colors from `context.color`, all sizes from `AppSize`, all styles from `AppTextStyles`, all copy from `AppStrings`.
- No new dependencies. No new localization files.
- Arabic RTL: first `Row` child renders right-most; keep button order as specified.
- Keep `AzkarHomeOptionsBottomSheet` exactly as is (the duplicate manage entry is intentional).
- Run `flutter analyze` and the azkar test suite before claiming a task done.

## Review Focus

1. **Narrow widths (320–360 px):** 4-column grid with a 52 circle + two 12 px lines must not overflow; `childAspectRatio` must leave room at the narrowest 4-column width (76 px @360 → height ≥ 94).
2. **Section failure:** header + manage button stay usable, retry reloads only categories, and the tasbeeh card keeps working.
3. **Empty state:** the create action opens the custom-azkar form and the list reloads on return.
4. **Reduce motion:** with `disableAnimations`, staggered tiles are fully visible immediately and the ring does not pulse.
5. **Return from the counter screen:** grid does not stay at opacity 0 after reload, and the ring pulse plays once, not repeatedly.

---

### Task 1: Category circle + grid geometry (D4:B, D6:A grid spacing)

**Files:**
- Modify: `lib/core/constants/app_sizes.dart` (add `w52`, `h52`)
- Modify: `lib/core/constants/app_constants.dart:27` (`0.9` → `0.78`)
- Modify: `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_category_card.dart`
- Modify: `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_categories_grid.dart:144-145`
- Test: `test/features/azkar/presentation/widgets/azkar_category_card_test.dart`

**Interfaces:**
- Produces: `AppSize.w52`, `AppSize.h52`; `AzkarCategoryCard` keeps its exact constructor `({required String title, required VoidCallback onTap, AzkarCategoryType? type, VoidCallback? onLongPress})`.

- [ ] **Step 1: Add failing assertions to `azkar_category_card_test.dart`**

```dart
testWidgets('uses a 52 circle, a 24 icon and a two-line 12 title', (tester) async {
  await _pump(
    tester,
    title: 'أذكار الاستيقاظ',
    type: AzkarCategoryType.morning,
    onTap: () {},
  );

  final icon = tester.widget<Icon>(find.byIcon(AppIcons.morning));
  expect(icon.size, AppSize.icon24);
  expect(find.byType(AppMarqueeText), findsNothing);

  final title = tester.widget<Text>(find.text('أذكار الاستيقاظ'));
  expect(title.style?.fontSize, 12);
  expect(title.maxLines, 2);
  expect(title.textAlign, TextAlign.center);
});
```

- [ ] **Step 2: Run it and confirm it fails**

Run: `flutter test test/features/azkar/presentation/widgets/azkar_category_card_test.dart`
Expected: FAIL (icon is 32, `AppMarqueeText` present, title style is 11).

- [ ] **Step 3: Implement**

In `app_sizes.dart`, next to `w48`:
```dart
static double get w52 => _scaled(52);
static double get h52 => _scaled(52);
```

In `azkar_category_card.dart`: drop the `Stack` and `AppMarqueeText`. Build:
```dart
AppPressable(
  onPressed: onTap,
  onLongPress: onLongPress,
  semanticLabel: title,
  excludeChildSemantics: true,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: AppSize.w52,
        height: AppSize.h52,
        decoration: BoxDecoration(
          color: context.color.secondaryScaffoldBackgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: context.color.borderBrand.withValues(
              alpha: AppConstants.opacitySubtle,
            ),
            width: AppSize.borderWidth,
          ),
        ),
        child: Center(
          child: Icon(
            type?.icon ?? AppIcons.adhkar,
            size: AppSize.icon24,
            color: context.color.iconPrimary,
          ),
        ),
      ),
      AppGap.h(AppSize.p8),
      Flexible(
        child: Text(
          title,
          maxLines: AppConstants.maxTwoLines,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.font12W700Primary(context),
        ),
      ),
    ],
  ),
)
```
Remove now-unused imports (`app_marquee_text.dart`, `app_gap.dart` stays used).

In `azkar_categories_grid.dart`, set `mainAxisSpacing: AppSize.p12`, `crossAxisSpacing: AppSize.p8`, and keep `childAspectRatio: AppConstants.azkarCategoryTileAspectRatio`.

- [ ] **Step 4: Run tests and analyze**

Run: `flutter test test/features/azkar/presentation/widgets/azkar_category_card_test.dart test/features/azkar/presentation/views/azkar_tasbeeh_home_view_test.dart`
Run: `flutter analyze lib/features/azkar lib/core/constants`
Expected: PASS, no new analyzer issues.

- [ ] **Step 5: Commit**

```bash
git add lib/core/constants lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar test/features/azkar/presentation/widgets/azkar_category_card_test.dart
git commit -m "feat(azkar): circle category tiles at 52 with fixed 12px labels"
```

---

### Task 2: Section header, manage entry, in-place error/empty (D5:A, D7:A)

**Files:**
- Modify: `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_section_widget.dart`
- Modify: `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_categories_grid.dart`
- Modify: `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_categories_skeleton.dart`
- Test: `test/features/azkar/presentation/widgets/azkar_section_widget_test.dart`

**Interfaces:**
- Consumes: `AppSectionHeader(title:, trailing:)`, `AppTextButton(label:, onPressed:, padding:)`, `AppStateView(icon:, title:, message:, action:)`, `OpenCustomAzkarForm.andReload(context, reload:)`, `AppRoutes.customAzkarView`.
- Produces: `AzkarSectionWidget` keeps its const constructor and remains a single sliver.

- [ ] **Step 1: Add failing tests to `azkar_section_widget_test.dart`**

```dart
testWidgets('shows the section title and the manage entry in every state', (
  tester,
) async {
  final cubit = _cubit(categories: const []);
  await cubit.loadCategories();
  await _pump(tester, cubit);

  expect(find.text(AppStrings.azkarHeader), findsOneWidget);
  expect(find.text(AppStrings.manageCustomAzkar), findsOneWidget);
});

testWidgets('renders the error inside a card, not a full-screen fill', (
  tester,
) async {
  final repository = _FakeAzkarRepository(categories: const [], failure: true);
  final cubit = AzkarCategoriesCubit(
    GetAzkarCategoriesUseCase(repository),
    GetCustomCategoriesUseCase(_FakeCustomCategoryRepository()),
    GetZikrsByCategoryUseCase(_FakeAzkarRepository(categories: const [])),
  );
  await cubit.loadCategories();
  await _pump(tester, cubit);

  expect(find.byType(AppSectionCard), findsOneWidget);
  expect(find.text(AppStrings.azkarLoadError), findsOneWidget);
  expect(find.text(AppStrings.tryAgain), findsOneWidget);
  expect(find.text(AppStrings.manageCustomAzkar), findsOneWidget);
});

testWidgets('offers a create action in the empty state', (tester) async {
  final cubit = _cubit(categories: const []);
  await cubit.loadCategories();
  await _pump(tester, cubit);

  expect(find.text(AppStrings.azkarCategoriesEmpty), findsOneWidget);
  expect(find.text(AppStrings.createCustomAzkar), findsOneWidget);
});
```

- [ ] **Step 2: Run and confirm failure**

Run: `flutter test test/features/azkar/presentation/widgets/azkar_section_widget_test.dart`
Expected: FAIL (no header/manage text, no `AppSectionCard`, empty uses `AppEmptyView`).

- [ ] **Step 3: Implement**

`azkar_section_widget.dart` becomes:
```dart
@override
Widget build(BuildContext context) => SliverPadding(
  padding: AppSize.shp,
  sliver: SliverMainAxisGroup(
    slivers: [
      SliverToBoxAdapter(
        child: AppSectionHeader(
          title: AppStrings.azkarHeader,
          trailing: AppTextButton(
            label: AppStrings.manageCustomAzkar,
            padding: EdgeInsets.symmetric(horizontal: AppSize.p8),
            onPressed: () => unawaited(_openManage(context)),
          ),
        ),
      ),
      BlocBuilder<AzkarCategoriesCubit, AzkarCategoriesState>(
        builder: (context, state) => switch (state) {
          AzkarCategoriesLoaded(:final categories) => AzkarCategoriesGrid(
            categories: categories,
          ),
          AzkarCategoriesEmpty() => SliverToBoxAdapter(
            child: AppSectionCard(
              child: AppStateView(
                icon: AppIcons.adhkar,
                title: AppStrings.azkarCategoriesEmpty,
                action: AppPrimaryButton(
                  label: AppStrings.createCustomAzkar,
                  onPressed: () => unawaited(_create(context)),
                ),
              ),
            ),
          ),
          AzkarCategoriesError(:final message) => SliverToBoxAdapter(
            child: AppSectionCard(
              child: AppStateView(
                icon: AppIcons.error,
                title: AppStrings.azkarLoadError,
                message: message,
                action: AppPrimaryButton(
                  label: AppStrings.tryAgain,
                  onPressed: () => unawaited(
                    context.read<AzkarCategoriesCubit>().loadCategories(),
                  ),
                ),
              ),
            ),
          ),
          AzkarCategoriesInitial() || AzkarCategoriesLoading() =>
            const AzkarCategoriesSkeleton(),
        },
      ),
    ],
  ),
);
```
with private helpers:
```dart
Future<void> _openManage(BuildContext context) async {
  await context.pushNamed(AppRoutes.customAzkarView);
  if (context.mounted) unawaited(context.read<AzkarCategoriesCubit>().loadCategories());
}

Future<void> _create(BuildContext context) => OpenCustomAzkarForm.andReload(
  context,
  reload: () => context.read<AzkarCategoriesCubit>().loadCategories(),
);
```

In `azkar_categories_grid.dart`: delete the `SliverPadding`, `SliverMainAxisGroup` and the `AppSectionHeader`; return `AppSliverGrid.extent(...)` directly (still a sliver). Remove `context.color`/header imports if unused.

`azkar_categories_skeleton.dart` needs no structural change (it wraps the now header-less grid).

- [ ] **Step 4: Run tests and analyze**

Run: `flutter test test/features/azkar/presentation/widgets/azkar_section_widget_test.dart test/features/azkar/presentation/views/azkar_tasbeeh_home_view_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar test/features/azkar/presentation/widgets/azkar_section_widget_test.dart
git commit -m "feat(azkar): visible manage entry and in-place section states"
```

---

### Task 3: One-shot staggered entrance (D8:B)

**Files:**
- Modify: `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_categories_grid.dart`
- Modify: `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_categories_skeleton.dart`
- Test: `test/features/azkar/presentation/widgets/azkar_categories_grid_test.dart` (create)

**Interfaces:**
- Produces: `AzkarCategoriesGrid({required List<AzkarCategoryEntity> categories, bool animate = true, Key? key})`; skeleton passes `animate: false`.

- [ ] **Step 1: Write the failing test**

```dart
testWidgets('staggers tiles by 40ms once and settles fully visible', (tester) async {
  await _pump(tester, animate: true);

  expect(_opacityOf(tester, 0), 0);
  expect(_opacityOf(tester, 2), 0);

  await tester.pump(const Duration(milliseconds: 40));
  expect(_opacityOf(tester, 0), greaterThan(0));

  await tester.pumpAndSettle();
  expect(_opacityOf(tester, 0), 1);
  expect(_opacityOf(tester, 1), 1);
  expect(_opacityOf(tester, 2), 1);
});

testWidgets('shows every tile immediately when animations are disabled', (
  tester,
) async {
  await _pump(tester, animate: true, disableAnimations: true);
  expect(_opacityOf(tester, 0), 1);
  expect(_opacityOf(tester, 2), 1);
});

double _opacityOf(WidgetTester tester, int index) => tester
    .widget<Opacity>(find.byKey(ValueKey('azkar_tile_fade_$index')))
    .opacity;
```

`_pump` mounts `CustomScrollView(slivers: [AzkarCategoriesGrid(categories: _categories, animate: animate)])` inside a 390×844 `MediaQuery(data: MediaQueryData(disableAnimations: true))` when requested.

- [ ] **Step 2: Run and confirm failure**

Run: `flutter test test/features/azkar/presentation/widgets/azkar_categories_grid_test.dart`
Expected: FAIL (stateless widget, no fade keys).

- [ ] **Step 3: Implement the stagger**

Convert the grid to `StatefulWidget` with `SingleTickerProviderStateMixin`:
```dart
static const _staggerMs = 40;
static const _fadeMs = 200;

late final AnimationController _controller;

@override
void initState() {
  super.initState();
  _controller = AnimationController(
    vsync: this,
    duration: Duration(
      milliseconds: _fadeMs + _staggerMs * widget.categories.length,
    ),
  );
  if (widget.animate) {
    _controller.forward();
  } else {
    _controller.value = 1;
  }
}

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (context.reduceMotion) _controller.value = 1;
}
```
Wrap each item:
```dart
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    final elapsed = _controller.value * _controller.duration!.inMilliseconds;
    final t = ((elapsed - index * _staggerMs) / _fadeMs).clamp(0.0, 1.0);
    final eased = Curves.easeOut.transform(t);
    return Opacity(
      key: ValueKey('azkar_tile_fade_$index'),
      opacity: eased,
      child: Transform.translate(
        offset: Offset(0, (1 - eased) * AppSize.p8),
        child: child,
      ),
    );
  },
  child: AzkarCategoryCard(...),
)
```
Add `import 'package:sana/core/utils/context_extension.dart';`.

In `azkar_categories_skeleton.dart`, pass `animate: false`.

- [ ] **Step 4: Run tests**

Run: `flutter test test/features/azkar/presentation/widgets/azkar_categories_grid_test.dart test/features/azkar/presentation/widgets/azkar_section_widget_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar test/features/azkar/presentation/widgets/azkar_categories_grid_test.dart
git commit -m "feat(azkar): one-shot 40ms staggered grid entrance"
```

---

### Task 4: Tasbeeh card shell, recent state and ring pulse (D2:A, D8:C, §4.1)

**Files:**
- Modify: `lib/core/constants/app_strings.dart:120` (`allTasbeeh` → `'كل التسابيح'`)
- Modify: `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_home_card.dart`
- Modify: `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_recent_item.dart`
- Delete: `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_action_button.dart`
- Modify: `lib/features/azkar/presentation/views/azkar_tasbeeh_home_view.dart` (wrap the card in a sliver adapter)
- Test: `test/features/azkar/presentation/widgets/tasbeeh_recent_item_test.dart` (create), `test/features/azkar/presentation/views/azkar_tasbeeh_home_view_test.dart`

**Interfaces:**
- Produces: `TasbeehHomeCard` returns a box widget (not a sliver) whose root is `AppSectionCard`; `TasbeehRecentItem` keeps its constructor.
- Consumes: `AppButton(label:, onPressed:, variant:, expand:)`, `AppButtonVariant`, `AppStrings.remainingCountOfTotal`, `context.reduceMotion`.

- [ ] **Step 1: Write the failing recent-item test**

```dart
testWidgets('shows the 64 ring, the remaining line and two 48 buttons', (
  tester,
) async {
  await _pump(
    tester,
    item: TasbeehItemEntity(
      id: '1',
      text: 'سبحان الله وبحمده، سبحان الله العظيم',
      currentCount: 33,
      targetCount: 100,
      lastUsedAt: DateTime(2026),
    ),
  );

  final ring = tester.getSize(find.byType(TasbeehCounter));
  expect(ring.width, AppSize.h64);
  expect(find.text(AppStrings.remainingCountOfTotal(67, 100)), findsOneWidget);
  expect(find.text(AppStrings.continueTasbeeh), findsOneWidget);
  expect(find.text(AppStrings.allTasbeeh), findsOneWidget);

  final buttons = find.byType(AppButton);
  expect(buttons, findsNWidgets(2));
  for (final button in buttons.evaluate()) {
    expect(tester.getSize(find.byWidget(button.widget)).height, AppSize.h48);
  }

  await tester.tap(find.text(AppStrings.continueTasbeeh));
  expect(continued, 1);
});

testWidgets('hides the progress line for a free counter', (tester) async {
  await _pump(tester, item: itemWithoutTarget);
  expect(find.textContaining('متبقي'), findsNothing);
});

testWidgets('plays one ring pulse and settles', (tester) async {
  await _pump(tester, item: itemWithTarget);
  final pulse = find.byKey(const ValueKey('tasbeeh_counter_pulse'));
  expect(tester.widget<ScaleTransition>(pulse).scale.value, 1);
  await tester.pump(const Duration(milliseconds: 80));
  expect(tester.widget<ScaleTransition>(pulse).scale.value, greaterThan(1));
  await tester.pumpAndSettle();
  expect(tester.widget<ScaleTransition>(pulse).scale.value, 1);
});
```

- [ ] **Step 2: Run and confirm failure**

Run: `flutter test test/features/azkar/presentation/widgets/tasbeeh_recent_item_test.dart`
Expected: FAIL (48 ring, 33px action buttons, no pulse key).

- [ ] **Step 3: Implement the card shell**

`TasbeehHomeCard.build`:
```dart
BlocProvider<TasbeehCubit>(
  create: ...,
  child: BlocBuilder<TasbeehCubit, TasbeehState>(
    builder: (context, state) {
      final cubit = context.read<TasbeehCubit>();
      final recentItem = state is TasbeehLoaded && state.items.isNotEmpty
          ? state.recentItems.first
          : null;
      return AppSectionCard(
        padding: EdgeInsets.all(AppSize.p16),
        child: switch (state) {
          TasbeehLoaded() when recentItem == null => TasbeehPresetGrid(...),
          TasbeehLoaded() => TasbeehRecentItem(...),
          TasbeehError(:final message) => AppStateView(
            icon: AppIcons.error,
            title: AppStrings.tasbeehLoadError,
            message: message,
            action: AppPrimaryButton(
              label: AppStrings.tryAgain,
              onPressed: () => unawaited(cubit.loadItems()),
            ),
          ),
          TasbeehInitial() || TasbeehLoading() => const TasbeehPresetGridSkeleton(),
        },
      );
    },
  ),
)
```
Delete the `SliverPadding`, `SliverMainAxisGroup` and `AppSectionHeader('المسبحة')`.

`TasbeehRecentItem` becomes stateful only for the pulse. Keep the existing layout helpers but replace the body:
```dart
Row(
  children: [
    ScaleTransition(
      key: const ValueKey('tasbeeh_counter_pulse'),
      scale: _pulse,
      child: TasbeehCounter(
        currentCount: item.currentCount,
        targetCount: item.targetCount,
        dimension: AppSize.h64,
        strokeWidth: AppSize.progressStrokeWidthLarge,
        numberStyle: AppTextStyles.font16W700Brand(context),
      ),
    ),
    AppGap.w(AppSize.p12),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.text, maxLines: AppConstants.maxTwoLines, overflow: TextOverflow.ellipsis, style: AppTextStyles.font16W700Primary(context)),
          if (item.targetCount != null) ...[
            AppGap.h(AppSize.p4),
            Text(
              AppStrings.remainingCountOfTotal(
                (item.targetCount! - item.currentCount).clamp(0, 1 << 30),
                item.targetCount!,
              ),
              style: AppTextStyles.font12W500Secondary(context),
            ),
          ],
        ],
      ),
    ),
  ],
),
AppGap.h(AppSize.p16),
Row(children: [
  Expanded(child: AppButton(label: AppStrings.continueTasbeeh, onPressed: onContinue, expand: true)),
  AppGap.w(AppSize.p8),
  Expanded(child: AppButton(label: AppStrings.allTasbeeh, onPressed: onOpenAll, variant: AppButtonVariant.secondary, expand: true)),
]),
```
Pulse animation in `initState`: `TweenSequence` 1→1.05→1 over `AppConstants.animationSlower500ms`; in `didChangeDependencies` set `_controller.value = 1` when `context.reduceMotion`. Dispose the controller.

Delete `tasbeeh_action_button.dart` and its import.

In `azkar_tasbeeh_home_view.dart`, replace `const TasbeehHomeCard(),` with:
```dart
const SliverToBoxAdapter(child: TasbeehHomeCard()),
```

- [ ] **Step 4: Update the home-view test**

Delete the "keeps the spacing below the tasbeeh card title" test and add:
```dart
testWidgets('renders the tasbeeh content inside one card', (tester) async {
  await _pump(tester);
  expect(find.byType(AppSectionCard), findsOneWidget);
  expect(find.text(AppStrings.tasbeehTitle), findsNothing);
});
```

- [ ] **Step 5: Run tests and analyze**

Run: `flutter test test/features/azkar/presentation/widgets/tasbeeh_recent_item_test.dart test/features/azkar/presentation/views/azkar_tasbeeh_home_view_test.dart`
Run: `flutter analyze lib/features/azkar`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/core/constants/app_strings.dart lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh lib/features/azkar/presentation/views test/features/azkar
git commit -m "feat(azkar): tasbeeh card with 48px actions and one ring pulse"
```

---

### Task 5: Start state inside the card (D3:A, §4.2)

**Files:**
- Modify: `lib/core/constants/app_strings.dart` (add `startTasbeeh = 'ابدأ بتسبيحة'`)
- Modify: `lib/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart`
- Modify: `lib/features/azkar/presentation/widgets/tasbeeh/tasbeeh_preset_grid_skeleton.dart`
- Modify: `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_home_card.dart`
- Test: `test/features/azkar/presentation/widgets/tasbeeh_preset_grid_test.dart`

**Interfaces:**
- Produces: `TasbeehPresetGrid` unchanged signature; renders 3 preset icons + a bordered custom tile.
- Consumes: `AppIcons.tasbih`, `AppIcons.sparkle`, `AppIcons.repentance`, `AppIcons.add`, `context.color.surfaceSelected`, `context.color.iconSecondary`, `context.color.dividerColor`.

- [ ] **Step 1: Add failing assertions**

```dart
testWidgets('gives every preset its own icon and a 12px two-line label', (
  tester,
) async {
  await _pumpGrid(tester);

  expect(find.byIcon(AppIcons.tasbih), findsOneWidget);
  expect(find.byIcon(AppIcons.sparkle), findsOneWidget);
  expect(find.byIcon(AppIcons.repentance), findsOneWidget);
  expect(find.byIcon(AppIcons.add), findsOneWidget);
  expect(find.byType(AppMarqueeText), findsNothing);

  final label = tester.widget<Text>(find.text(AppStrings.tasbeehPresets.first));
  expect(label.style?.fontSize, 12);
  expect(label.maxLines, 2);
});
```

- [ ] **Step 2: Run and confirm failure**

Run: `flutter test test/features/azkar/presentation/widgets/tasbeeh_preset_grid_test.dart`
Expected: FAIL (four `add` icons, marquee present).

- [ ] **Step 3: Implement the preset grid**

```dart
static const _presetIcons = <IconData>[
  AppIcons.tasbih,
  AppIcons.sparkle,
  AppIcons.repentance,
];
```
Row of 4 `Expanded`; each tile:
```dart
AppPressable(
  onPressed: onTap,
  semanticLabel: label,
  excludeChildSemantics: true,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: AppSize.w48,
        height: AppSize.h48,
        decoration: BoxDecoration(
          color: context.color.surfaceSelected,
          shape: BoxShape.circle,
          border: isCustom
              ? Border.all(color: context.color.dividerColor, width: AppSize.borderWidth)
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            size: AppSize.icon24,
            color: isCustom ? context.color.iconSecondary : context.color.iconPrimary,
          ),
        ),
      ),
      AppGap.h(AppSize.p8),
      Flexible(
        child: Text(
          label,
          maxLines: AppConstants.maxTwoLines,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.font12W700Primary(context),
        ),
      ),
    ],
  ),
)
```
Pass `isCustom: label == AppStrings.customTasbeeh`.

Add the title in `TasbeehHomeCard`'s start branch:
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Text(AppStrings.startTasbeeh, style: AppTextStyles.font14W700Primary(context)),
    AppGap.h(AppSize.p12),
    TasbeehPresetGrid(...),
  ],
)
```
`TasbeehPresetGridSkeleton` becomes `Skeletonizer(child: IgnorePointer(child: Column(title + grid)))` with no outer `SingleChildScrollView`/padding (the card provides both).

- [ ] **Step 4: Run tests**

Run: `flutter test test/features/azkar/presentation/widgets/tasbeeh_preset_grid_test.dart test/features/azkar/presentation/views/azkar_tasbeeh_home_view_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/core/constants/app_strings.dart lib/features/azkar/presentation/widgets test/features/azkar
git commit -m "feat(azkar): start state with distinct preset icons and copy"
```

---

### Task 6: Home rhythm and top spacing (D6:A)

**Files:**
- Modify: `lib/features/azkar/presentation/views/azkar_tasbeeh_home_view.dart`
- Modify: `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_section_widget.dart` (only if extra padding is needed)
- Test: `test/features/azkar/presentation/views/azkar_tasbeeh_home_view_test.dart`

**Interfaces:**
- Produces: top content padding `p16`, gap `p24` between card and azkar section, bottom `p40`.

- [ ] **Step 1: Add failing spacing test**

```dart
testWidgets('keeps p16 above the card and p24 between the sections', (
  tester,
) async {
  await _pump(tester);

  final cardTop = tester.getTopLeft(find.byType(AppSectionCard).first).dy;
  final headerTop = tester.getTopLeft(find.text(AppStrings.azkarHeader)).dy;
  final cardBottom = tester.getBottomLeft(find.byType(AppSectionCard).first).dy;

  expect(headerTop - cardBottom, closeTo(AppSize.p24, 1));
  expect(cardTop, greaterThan(0));
});
```
(Measure from the scroll view's top padding via `tester.getTopLeft(find.byType(CustomScrollView))` if the header pushes the card; assert `cardTop - scrollTop` equals `p16` when the app bar is excluded.)

- [ ] **Step 2: Run and confirm failure**

Run: `flutter test test/features/azkar/presentation/views/azkar_tasbeeh_home_view_test.dart`
Expected: FAIL (the gap is `p16` and top is `p8`).

- [ ] **Step 3: Implement layout**

In `azkar_tasbeeh_home_view.dart`, slivers become:
```dart
CommonSliverAppBar(...unchanged...),
SliverPadding(
  padding: EdgeInsetsDirectional.only(
    start: AppSize.p16,
    end: AppSize.p16,
    top: AppSize.p16,
  ),
  sliver: const SliverToBoxAdapter(child: TasbeehHomeCard()),
),
SliverToBoxAdapter(child: AppGap.h(AppSize.p24)),
const AzkarSectionWidget(),
SliverToBoxAdapter(child: AppGap.h(AppSize.p40)),
```
Do not add horizontal padding to `AzkarSectionWidget` at the view level; it already applies `AppSize.shp`.

- [ ] **Step 4: Run the full azkar suite**

Run: `flutter test test/features/azkar`
Run: `flutter analyze`
Expected: PASS with no new issues.

- [ ] **Step 5: Commit**

```bash
git add lib/features/azkar/presentation/views lib/features/azkar/presentation/widgets test/features/azkar
git commit -m "feat(azkar): align home rhythm to the 16/24 scale"
```

---

## Self-Review

- **Coverage:** D1/D9 require no code (confirmed). D2 → Task 4. D3 → Task 5. D4 → Task 1. D5 → Task 2 (sheet untouched). D6 → Tasks 1, 5, 6. D7 → Task 2 + Task 4 error state. D8 → Tasks 3 + 4. Must-fix items 1–8 → Tasks 1, 2, 4, 5, 6.
- **Types:** `TasbeehHomeCard` changes from sliver to box (Task 4) and the view adapter is in the same task. `AzkarCategoriesGrid` gains `animate` (Task 3) and the skeleton passes it in the same task. `AppSize.w52/h52` are defined in Task 1 before use.
- **Known risk:** `AppSectionCard` is used inside tests as a proxy for "the tasbeeh card"; Task 2 adds a second `AppSectionCard` for error/empty states. Task 6's test must use `.first` (tasbeeh card comes first in the scroll view).
- **Out of scope:** changing `AppMarqueeText` (core widget kept, just unused here), the options-sheet manage row, dark-theme values (tokens handle it).
