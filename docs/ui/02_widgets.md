# Widget Rules — Reuse, Decomposition, States, Overflow

How a screen is broken into widgets, how each one is structured, and how its
states and performance are handled.

Where a widget's file goes and what it is named is in
[`../architecture/01_naming.md`](../architecture/01_naming.md). Comments are in
[`../architecture/03_code_conventions.md`](../architecture/03_code_conventions.md).
Values come from [`../design_system/01_theme.md`](../design_system/01_theme.md)
and [`../design_system/02_tokens.md`](../design_system/02_tokens.md). Layout is
in [`01_layout.md`](01_layout.md).

---

## 1. 🚨 Reuse before you build

> **Before writing ANY custom widget or UI piece, check the core inventory in
> `lib/core/widgets/`.**

Re-implementing an existing core widget — a button, a card, a text field, a
divider, an empty state, an error view — is **strictly forbidden**.

| Purpose | Reuse |
|---|---|
| Buttons | `AppPrimaryButton`, `AppSecondaryButton`, `AppDeleteButton` |
| Cards | `AppSectionCard`, `AppSelectionCard`, `AppActionCard`, `AppCustomItemCard`, `DailyContentBaseCard` |
| Inputs & toggles | `AppTextField`, `AppToggleList` |
| Views | `AppErrorView`, `AppEmptyView` |
| Favorites | `CustomFavoriteToggleButton`, `NoFavoriteYet` |
| Dividers & gaps | `AppGap` |
| Layout & slivers | `CommonSliverAppBar`, `AppSliverList`, `AppSliverGrid` |
| Overlays | `AppDialog`, `CustomConfirmationDialog`, `AppBottomSheet`, `AppToast` |

```dart
// ❌ FORBIDDEN — the shared field already exists
Container(
  padding: EdgeInsets.all(AppSize.p16),
  child: TextField(...),
)

// ✅ CORRECT
AppTextField(controller: controller, hint: AppStrings.emailOrPhone)
```

Write a custom widget **only** after verifying that nothing fits, and when it is
genuinely specific to its screen — a widget used by one screen stays in that
screen's folder as a private class.

---

## 2. Screen anatomy

```
features/{feature}/presentation/views/{name}_view.dart            ← thin shell
features/{feature}/presentation/widgets/{section}_widget.dart     ← one per section
```

- A **view** is a shell: it assembles its sections, wires the state
  (`BlocProvider`) and navigation, and holds no layout of its own.
- Each **section** is its own widget file. Three sections on a screen means three
  files, not one long `build`.
- The shell's scroll container is always `CustomScrollView` — see
  [`01_layout.md`](01_layout.md) §1. A section either returns a sliver
  (`AppSliverList`, `AppSliverGrid`) or a box wrapped in `SliverToBoxAdapter`.
- Views never import other views — go through the router.

```dart
// feedback_issue_view.dart
class FeedbackIssueView extends StatelessWidget {
  const FeedbackIssueView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => sl<FeedbackCubit>(),
    child: const _FeedbackIssueContent(),
  );
}
```

---

## 3. Decomposition — private widget classes, never `_buildX()`

```dart
// ❌ Never
Widget _buildHeader() => Text(...)

// ✅ Always
class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget();
  @override
  Widget build(BuildContext context) => Text(...)
}
```

**Split when:** three or more widgets belong together · a pattern repeats within
the file · you catch yourself reaching for `_buildX()`.

Private classes are `_SomethingWidget`, live in their consumer's file, and are
not exported.

---

## 4. UI states

- Isolate each UI state — **loading, success, empty, error** — in its own
  widget, in the feature's `widgets/` folder.
- **Loading:** use `Skeletonizer` to build a skeleton that matches the shape of
  the success UI.
- **Error:** `AppErrorView` for a full-screen failure; `AppToast` for a minor
  one.
- **Empty:** `AppEmptyView`.
- State classes are sealed — the view switches on the state type and returns the
  matching widget.

---

## 5. Overflow prevention

```dart
// ❌ unbounded width in a Row → RenderFlex overflow
Row(children: [Icon(...), Text(title)])

// ✅
Row(children: [
  Icon(..., size: AppSize.icon16),
  AppGap.w(AppSize.p8),
  Expanded(
    child: Text(
      title,
      maxLines: AppConstants.maxOneLine,
      overflow: TextOverflow.ellipsis,
    ),
  ),
])
```

| Situation | Rule |
|---|---|
| Primary content (questions, descriptions, messages) | **No `maxLines` limit** |
| Compact badges, buttons, titles | `maxLines: AppConstants.maxOneLine` (or `maxTwoLines`) + `overflow: TextOverflow.ellipsis` |
| `Text` inside a `Row` | wrap in `Expanded` or `Flexible` |
| `Column` inside a `Row` | wrap in `Expanded` or `Flexible` |
| `Row` inside a `Row` | `mainAxisSize: MainAxisSize.min` |
| Unbounded list inside a `Column` | convert the screen to `CustomScrollView` and put `AppSliverList` in `slivers` |

`maxLines` + `overflow` is a safety net for compact UI, **never** a blanket rule
for primary content — primary content must be readable in full. An ellipsis on a
button label is a design failure; the fix is a shorter string (see
[`03_text.md`](03_text.md) §3).

---

## 6. Field anatomy

Every input follows the same three parts. `AppTextField` already owns its hint
style, radius and padding, so a field is never restyled.

| Part | Value |
|---|---|
| Label | `AppTextStyles.font14W700` + `context.color.textPrimary` |
| Label → field gap | `AppGap.h(AppSize.p12)` |
| Field | `AppTextField` |

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      AppStrings.details,
      style: AppTextStyles.font14W700(
        context,
      ).copyWith(color: context.color.textPrimary),
    ),
    AppGap.h(AppSize.p12),
    AppTextField(
      controller: controller,
      hint: AppStrings.writeDetails,
      validator: validateFeedbackIssue,
    ),
  ],
)
```

Validation rules live in `AppValidators` — see
[`../design_system/02_tokens.md`](../design_system/02_tokens.md) §4.

---

## 7. Build & performance discipline

- Prefer `const` constructors everywhere possible.
- **Never** create `TextEditingController`, `AnimationController` or `FocusNode`
  inside `build()`.
- Always `dispose()` controllers, focus nodes, streams and subscriptions.
- Prefer small, composed widgets to shrink the rebuild scope.
- Use `BlocBuilder` / `BlocSelector` on the smallest widget that needs the state
  — not at the top of the tree.
- **Opacity:** avoid the `Opacity` widget for simple elements (text, icons) — use
  a color with the alpha baked in. `Opacity` is for complex subtrees only.
- **Clipping:** round containers with `BoxDecoration(borderRadius)`; `ClipRRect`
  is for images and videos.
- **Lists:** always `AppSliverList` / `AppSliverGrid` inside `CustomScrollView` for
  dynamic or long content, so items are built lazily. `ListView` and `GridView`
  are forbidden — they create a nested viewport and lose laziness when wrapped.
- `RepaintBoundary` around complex, heavy animations.

---

## 8. Comments

Short lowercase comments above a non-obvious subtree — the full rule is in
[`../architecture/03_code_conventions.md`](../architecture/03_code_conventions.md).

---

## 9. Gates

```bash
flutter analyze   # must print: No issues found!
flutter test      # domain and data logic must pass
```

### Pre-submit checklist

- [ ] The core inventory was searched first — nothing was re-implemented
- [ ] The view is a thin shell; each section is its own widget file
- [ ] No `Widget _buildX()` — private widget classes only
- [ ] Private classes are `_SomethingWidget`, in their consumer's file
- [ ] Every state (loading, success, empty, error) has its own widget
- [ ] Primary text is unclipped; `maxLines` used only for compact labels
- [ ] Every `Text` in a `Row` → `Expanded` or `Flexible`
- [ ] Every `Column` in a `Row` → `Expanded` or `Flexible`
- [ ] Inner `Row` in a `Row` → `mainAxisSize: MainAxisSize.min`
- [ ] No controller or heavy object created in `build()`
- [ ] Every controller / focus node / stream is disposed
- [ ] `AppSliverList` / `AppSliverGrid` used for dynamic lists and grids
