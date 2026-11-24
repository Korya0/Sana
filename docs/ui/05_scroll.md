# Scroll Rules — No Unnecessary Scrolling

How to keep every screen scrollable only when it actually needs to be.

This rule extends [`01_layout.md`](01_layout.md) (screen shell, forbidden scroll widgets) with the invariant that caught a real defect in the Qibla state screens: a screen that fits its viewport must not scroll.

Colors, sizes and text come from [`../design_system/01_theme.md`](../design_system/01_theme.md) and [`../design_system/02_tokens.md`](../design_system/02_tokens.md).

---

## 1. The invariant

**Every route screen, sheet, dialog and visible state has `ScrollPosition.extentAfter == 0` in its fitting configuration.**

"Fitting configuration" means: the supported phone viewports (`320×640` and `400×900`), with and without a top safe-area inset of 47 px, and with text scaler `1.5`. If all content is visible, dragging must not move anything and the app bar must not scroll away.

A scrollable with extra extent is a bug even when it is "only" the app-bar height. In Qibla it measured `56.0` px without safe area and `103.0` px with a 47 px top inset — exactly `kToolbarHeight` and `kToolbarHeight + inset`. The user could drag the header off a screen that had nothing to scroll.

---

## 2. One scroll container per screen

`CustomScrollView` is the only screen scroll container (see [`01_layout.md`](01_layout.md) §1).

🚫 **Never put a scrollable box widget inside a sliver**, directly or indirectly:

```dart
// ❌ FORBIDDEN — nested scroll containers
SliverFillRemaining(
  hasScrollBody: false,
  child: SingleChildScrollView(
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
      child: Center(child: content),
    ),
  ),
)
```

This applies to indirect nesting too: `AppStateView`, `AppEmptyView` and `AppErrorView` all contain a `SingleChildScrollView`. Placing any of them inside `SliverFillRemaining` / `SliverToBoxAdapter` reproduces the Qibla bug.

| Context | Allowed |
|---|---|
| Route screen | `CustomScrollView` + slivers only |
| Full-screen empty/error state | `SliverFillRemaining(hasScrollBody: false)` with a **non-scrolling** child |
| Content-sized dialog | `SingleChildScrollView` (the dialog must size to its child) |
| Bottom sheet | short `Column` or `CustomScrollView`; `showModalBottomSheet` already bounds height |

The parent sliver already gives its child a bounded height. A second scroll view adds an independent scroll position, and its content height leaks into the outer sliver's `scrollExtent`.

---

## 3. Viewport floor rule

When a widget needs a minimum height so content can be vertically centred, derive it from the **space the parent actually has**, not from the screen. At the sliver level, `SliverLayoutBuilder` exposes `remainingPaintExtent` — the viewport minus the app bar:

```dart
// ✅ CORRECT — read the real extent at the sliver, pass it down explicitly
SliverLayoutBuilder(
  builder: (context, sliverConstraints) {
    final fillHeight = sliverConstraints.remainingPaintExtent;
    return SliverFillRemaining(
      hasScrollBody: false,
      child: MyStateContent(fillHeight: fillHeight), // forwards to AppStateView
    );
  },
)

// in AppStateView — screen height stays the default for non-sliver callers
BoxConstraints(minHeight: fillHeight ?? MediaQuery.sizeOf(context).height)
```

| Placement | Floor used | Result |
|---|---|---|
| Inside `SliverFillRemaining` | `remainingPaintExtent` passed explicitly | content fits exactly → `extentAfter == 0` |
| As a `Scaffold` body | `MediaQuery.sizeOf(context).height` (default) | centred, scrolls only for long content |

`MediaQuery.sizeOf(context).height` is **only** the default for non-sliver callers. Using it unconditionally inside a sliver double-counts the app bar and creates the extra scroll.

🚫 **Do not use `LayoutBuilder` for this.** `SliverFillRemaining(hasScrollBody: false)` asks its child for intrinsic dimensions (`getMaxIntrinsicHeight`) to size the sliver, and `LayoutBuilder` refuses to run its callback for intrinsic measurement — the screen crashes with `LayoutBuilder does not support returning intrinsic dimensions`. Read the extent at the **sliver** level and pass it down as a value instead.

---

## 4. App bar rule

A screen with no scrollable content must not use a `floating`/`snap` `CommonSliverAppBar` that can be dragged away. If the screen may scroll for legitimate long content, pin the app bar (`isPinned: true`) so navigation stays reachable. The app bar's height is `kToolbarHeight + MediaQuery.paddingOf(context).top`; any scroll extent equal to that value is the signature of this bug.

---

## 5. Mandatory regression test

Every screen or state that uses a scroll container needs a test asserting the invariant. Measure the real `ScrollPosition`, not the widget tree:

```dart
testWidgets('screen does not scroll when content fits', (tester) async {
  await pumpScreen(tester); // real screen, real state

  final positions = find.byType(Scrollable).evaluate().map(
        (element) => (element.widget as Scrollable).controller?.position,
      );
  for (final position in positions) {
    if (position != null) {
      expect(
        position.extentAfter,
        0.0,
        reason: 'screen must not scroll when all content fits',
      );
    }
  }
});
```

Run the same assertion in all four viewport configurations:

```dart
// in the test, before pumpWidget:
tester.view.physicalSize = size; // 320×640 and 400×900
tester.view.devicePixelRatio = 1;
tester.view.padding = const FakeViewPadding(left: 0, top: 47, right: 0, bottom: 34);
addTearDown(tester.view.reset);
```

Also keep a positive test with deliberately tall content that asserts `extentAfter > 0`, so a future "fix" that removes legitimate scrolling is caught.

---

## 6. Pre-submit checklist

- [ ] No `SingleChildScrollView` reachable from a sliver, including via `AppStateView` / `AppEmptyView` / `AppErrorView`.
- [ ] Every `minHeight` inside a scrollable derives from incoming constraints; screen height only as unbounded fallback.
- [ ] `extentAfter == 0` at both phone widths, with and without the 47 px top inset, and at text scaler 1.5.
- [ ] A positive "long content still scrolls" test exists.
- [ ] A screen that cannot scroll has a pinned or non-floating app bar.
- [ ] Temporary measurement tests were deleted; no probe files left under `test/`.

## 7. Gates

```bash
flutter test    # all tests, including the new extent assertions
flutter analyze # must print: No issues found!
```
