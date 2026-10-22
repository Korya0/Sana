# Layout Rules — Screen Shell, Alignment, Direction

How a screen is laid out, and how it stays correct in an always-RTL app.

Colors, sizes and text styles come from
[`../design_system/01_theme.md`](../design_system/01_theme.md) and
[`../design_system/02_tokens.md`](../design_system/02_tokens.md).
Strings and wording are in [`03_text.md`](03_text.md).

---

## 1. Screen shell

**Every route-level screen uses `CustomScrollView`.** There is one template:

```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      const CommonSliverAppBar(title: AppStrings.screenTitle), // optional
      AppSliverList(
        padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
        itemCount: items.length,
        itemBuilder: (context, index) => ItemCard(item: items[index]),
      ),
      SliverToBoxAdapter(child: AppGap.h(AppSize.p32)),
    ],
  ),
)
```

**Without an app bar** — the safe area still lives **inside** the scrollable, as a
sliver. Never wrap the scroll view:

```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      SliverSafeArea(
        bottom: false, // the bottom gap comes from the last sliver
        sliver: AppSliverGrid.extent(
          padding: EdgeInsets.only(top: AppSize.stp),
          maxCrossAxisExtent: AppSize.categoryTileMaxExtent,
          itemCount: items.length,
          itemBuilder: (context, index) => ItemCard(item: items[index]),
        ),
      ),
      SliverToBoxAdapter(child: AppGap.h(AppSize.p32)),
    ],
  ),
)
```

### 🚫 Never wrap `CustomScrollView`

`SafeArea` and `Padding` **outside** the scroll view shrink the viewport itself.
The content is clipped at that inner edge, so it can never flow under the status
bar, and the padding becomes a fixed band that never scrolls — the scroll looks
"cut from the top".

| Forbidden | Use instead |
|---|---|
| `SafeArea(child: CustomScrollView(...))` | `SliverSafeArea(sliver: ...)` inside `slivers` |
| `Padding(child: CustomScrollView(...))` | `padding:` on the sliver — `AppSliverList` / `AppSliverGrid` / `SliverPadding` |
| `Container(padding: ...)` around `CustomScrollView` | same as above |
| Padding the `Scaffold` body | same as above |

**With an app bar:** no wrapper at all. `SliverAppBar` applies the top
`MediaQuery` inset itself; wrapping it in `SafeArea` double-pads and breaks the
collapse/floating behaviour.

| Surface | Top inset handled by |
|---|---|
| Screen with app bar | `CommonSliverAppBar` (automatic) |
| Screen without app bar | `SliverSafeArea` — first sliver |
| Dialog / bottom sheet | `SafeArea` **outside** is fine — there is no screen viewport to protect |

### The only scroll decision: section contract

There is no second scroll-view template. The scroll container is always
`CustomScrollView`; what changes is what each **section** returns.

| Section content | Returns | Placed in `slivers` as |
|---|---|---|
| Fixed content — header, text, form, one card | a plain `Widget` | `SliverToBoxAdapter(child: ...)` |
| Dynamic list | a sliver | `AppSliverList(...)` |
| Dynamic grid | a sliver | `AppSliverGrid.extent(...)` / `AppSliverGrid.count(...)` |
| Empty / error state in a full screen | a sliver | `SliverFillRemaining(hasScrollBody: false, ...)` |
| Group of slivers | a sliver | `SliverMainAxisGroup(slivers: [...])` |

**Every branch must return a sliver.** If a `switch` / `BlocBuilder` in a
`sliver:` slot returns a box on any branch, layout dies with
`RenderSliverPadding expected a child of type RenderSliver`.

| State | Wrap it in |
|---|---|
| Empty / error that fills the screen | `SliverFillRemaining(hasScrollBody: false, child: ...)` |
| Small box between sections | `SliverToBoxAdapter(child: ...)` |

### 🚫 Forbidden scroll widgets

| Forbidden | Use instead |
|---|---|
| `ListView` · `ListView.builder` · `ListView.separated` | `AppSliverList` |
| `GridView` · `GridView.builder` · `GridView.count` · `GridView.extent` | `AppSliverGrid` |
| `ListView` inside `SliverToBoxAdapter` | put the sliver directly in `slivers` |
| `shrinkWrap: true` + `NeverScrollableScrollPhysics` as a layout workaround | a sliver |
| `SingleChildScrollView` on a screen | `CustomScrollView` |

`SingleChildScrollView` survives in **one** place only: content-sized overlays
(dialogs), where the box must size itself to its child. A dialog is not a
screen; see **Exceptions** below.

### Why

- `CustomScrollView` is the only container that supports a sliver app bar
  (`floating` / `snap` / `pinned` / collapsing), pull-to-refresh, sticky
  headers and mixed sliver content in one scroll.
- Laziness comes from the **builder-based sliver**, not from the scroll view.
  `AppSliverList` / `AppSliverGrid` build only what is near the viewport;
  `SingleChildScrollView` + `Column` builds everything up front.

### Global rules

- Never set a background color on `Scaffold` or on a root container — the theme
  owns it.
- **Root Column → `.stretch`. Inner Columns → `.start` only.**
- Every scrolling sliver list ends with its own bottom gap, so the last item
  clears the screen edge — `AppGap.h(AppSize.p32)`.

### Exceptions

| Surface | Scroll widget | Why |
|---|---|---|
| Dialog / confirmation | `SingleChildScrollView` | the dialog sizes to its content; a viewport needs a bounded height |
| Bottom sheet | `Column` (short) or `CustomScrollView` (long) | `showModalBottomSheet` already bounds the height |

---

## 2. 🚫 `CrossAxisAlignment.end` is forbidden everywhere

Banned in both `Column` and `Row`. No exceptions.

| Context | Default | Allowed | Forbidden |
|---|---|---|---|
| Root screen Column | `.stretch` | `.stretch`, `.start`, `.center` | **`.end`** |
| Any inner Column | `.start` | `.start`, `.center` | **`.end`** |
| Any Row | `.center` | `.start`, `.center` | **`.end`** |

```dart
// ❌ FORBIDDEN
Column(crossAxisAlignment: CrossAxisAlignment.end, ...)
Row(crossAxisAlignment: CrossAxisAlignment.end, ...)
```

**Why:** in an RTL app `.end` is the physical left — the trailing edge, which is
almost never what the design wants. And inside any explicitly LTR subtree
(numbers, Latin text, time strings) `.end` silently becomes the physical right,
so the same line moves. `.start` / `.center` follow the writing direction of
their own subtree.

When Figma shows a **right**-aligned element → `CrossAxisAlignment.start` (in RTL
start *is* the right) or `MainAxisAlignment.start`. When it shows a
**left**-aligned element → `MainAxisAlignment.end`, `Align`, or a `Spacer` —
never `CrossAxisAlignment.end`.

---

## 3. 🚫 Row element order is REVERSED relative to Figma

Under RTL, Flutter's `Row` places its **first** child at the **right** edge.
Figma already shows the correct visual result, so copying the Figma array
literally produces a double flip.

- Visually **leftmost** in Figma → **last** child in Flutter.
- Visually **rightmost** in Figma → **first** child in Flutter.

```dart
// Figma (left → right): [السابق]  [التالي]
// ❌ WRONG
Row(children: [_PreviousWidget(), _NextWidget()])
// ✅ CORRECT
Row(children: [_NextWidget(), _PreviousWidget()])
```

**Exception:** inside `Directionality(textDirection: TextDirection.ltr, ...)` —
keep Figma's order.

The same applies to horizontally-ordered `Stack` children and `Positioned`.

---

## 4. Asymmetric spacing must be directional

Whenever horizontal spacing differs between the two sides, use
`EdgeInsetsDirectional`. A physical `left`/`right` pair silently means "leading"
in one directionality and "trailing" in the other.

```dart
// ❌ FORBIDDEN — asymmetric, so the sides swap
EdgeInsets.only(left: AppSize.p16, right: AppSize.p8)

// ✅ CORRECT
EdgeInsetsDirectional.only(start: AppSize.p16, end: AppSize.p8)
```

Same for alignment:

```dart
// ❌
Alignment.centerRight      // physical — flips meaning

// ✅
AlignmentDirectional.centerEnd
```

- `EdgeInsets.all(...)` and `EdgeInsets.symmetric(...)` are fine — they are
  symmetric by construction.
- `Stack` / `Positioned` only for genuine overlap (badges, overlays) — and even
  then, prefer `PositionedDirectional`.
- Build with `Column` / `Row` / `Expanded` / `Flexible` + `AppGap` first; reach
  for `Stack` only when two things must overlap.

---

## 5. 👆 Tap surfaces

Tap behaviour is a rule set of its own: see [`04_tap.md`](04_tap.md).

In short: every pressable is `AppPressable` (or an app button built on it);
cards keep a solid surface and fade their content, buttons fade as a whole;
the target is at least 48×48 and the whole visible surface is one target;
no ripple, splash, movement, or new visual.

---

## 6. `TextAlign` — use logical values

- Use `TextAlign.start`, `.center` or `.justify`.
- **Never** `TextAlign.right` / `TextAlign.left` copied from Figma — they are
  physical, and the same value means a different side once a subtree changes
  directionality.

---

## 7. Strings inside a widget

```dart
// ✅
Text(AppStrings.prayerTimes)

// ❌ FORBIDDEN
Text('مواقيت الصلاة')
```

No hardcoded Arabic in any widget. Wording, naming and hygiene are in
[`03_text.md`](03_text.md).

---

## 8. Gates

```bash
flutter analyze   # must print: No issues found!
```

### Pre-submit checklist

- [ ] No background color on `Scaffold` or a root container
- [ ] **Every route screen is `Scaffold → CustomScrollView`** (only dialogs may scroll differently)
- [ ] **No `ListView` / `GridView` anywhere** — dynamic lists use `AppSliverList`, grids use `AppSliverGrid`
- [ ] **No `SafeArea` / `Padding` / `Container` wrapping `CustomScrollView`** — use `SliverSafeArea` and `padding:` on the sliver
- [ ] Top spacing is a `SliverPadding` inside `slivers`, not a wrapper outside the scroll view
- [ ] Root Column is `.stretch`; inner Columns `.start` or `.center`
- [ ] **`CrossAxisAlignment.end` used nowhere**
- [ ] **Row children REVERSED relative to Figma's array order**
- [ ] Asymmetric horizontal padding uses `EdgeInsetsDirectional` + `start`/`end`
- [ ] No physical `left`/`right`; no `Alignment.centerRight`
- [ ] No `TextAlign.right` / `TextAlign.left`
- [ ] Tap surfaces follow [`04_tap.md`](04_tap.md) — fade only (cards: content; buttons: whole), 48×48 floor, one semantic node
- [ ] The scrolling list ends with its own bottom gap
- [ ] No hardcoded Arabic text
- [ ] Dynamic `Text` has `maxLines` + `overflow` (see [`02_widgets.md`](02_widgets.md) §5)
