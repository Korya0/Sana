# Layout Rules — Screen Shell, Alignment, Direction, Hit Testing

How a screen is laid out, and how it stays correct in an always-RTL app.

Colors, sizes and text styles come from
[`../design_system/01_theme.md`](../design_system/01_theme.md) and
[`../design_system/02_tokens.md`](../design_system/02_tokens.md).
Strings and wording are in [`03_text.md`](03_text.md).

---

## 1. Screen shell

**With an app bar** — the default; `CommonSliverAppBar` lives in the sliver list:

```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      const CommonSliverAppBar(title: AppStrings.screenTitle),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(AppSize.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [...],
          ),
        ),
      ),
    ],
  ),
)
```

**Without an app bar:**

```dart
Scaffold(
  body: SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.all(AppSize.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [...],
      ),
    ),
  ),
)
```

- Never set a background color on `Scaffold` or on a root container — the theme
  owns it.
- **Root Column → `.stretch`. Inner Columns → `.start` only.**
- Every scrolling sliver list ends with its own bottom gap, so the last item
  clears the screen edge — `AppGap.h(AppSize.p32)`.

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

## 5. 👆 Hit testing — choose `HitTestBehavior` intentionally

`GestureDetector` and friends default to `HitTestBehavior.deferToChild`, which
only makes the **painted** part of the child tappable. Pick the behavior that
matches the real tap target.

| Behavior | Use when |
|---|---|
| `HitTestBehavior.opaque` | The child's painted box already covers the full tap target — a filled row, an icon, a chip |
| `HitTestBehavior.translucent` | The tap target is **larger** than the painted child — a full-width row whose gaps and separators should still respond |
| `HitTestBehavior.deferToChild` | The painted child *is* the whole target and you want the default — leave it alone |

```dart
// ✅ a full-width tappable row: the gap between icon and title must also tap
GestureDetector(
  behavior: HitTestBehavior.translucent,
  onTap: item.onTap,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [Flexible(child: title), trailing],
  ),
)
```

Choosing `translucent` when `opaque` would do makes invisible dead zones
tappable. Choosing the default when the target is larger than the paint makes
parts of a row silently unresponsive. When in doubt: *is there screen area the
user will aim at that this widget does not paint?* If yes → `translucent`.

Wrap pointer-only custom widgets in `Semantics(button: true, ...)` when they have
no text or icon the screen reader can read.

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
- [ ] Root Column is `.stretch`; inner Columns `.start` or `.center`
- [ ] **`CrossAxisAlignment.end` used nowhere**
- [ ] **Row children REVERSED relative to Figma's array order**
- [ ] Asymmetric horizontal padding uses `EdgeInsetsDirectional` + `start`/`end`
- [ ] No physical `left`/`right`; no `Alignment.centerRight`
- [ ] No `TextAlign.right` / `TextAlign.left`
- [ ] `HitTestBehavior` chosen deliberately, not left to chance
- [ ] The scrolling list ends with its own bottom gap
- [ ] No hardcoded Arabic text
- [ ] Dynamic `Text` has `maxLines` + `overflow` (see [`02_widgets.md`](02_widgets.md) §5)
