# Tap Rules — Pressables, 48 px Target, Semantics

Everything that can be tapped. Layout and scrolling are in
[`01_layout.md`](01_layout.md); widget inventory is in
[`02_widgets.md`](02_widgets.md); strings are in [`03_text.md`](03_text.md).

---

## 1. One owner

Every pressable surface uses `AppPressable`, or a button built on top of it.
It is the only widget that owns a tap and paints press feedback.

| Need | Use |
|---|---|
| Primary CTA | `AppPrimaryButton` |
| Secondary CTA | `AppSecondaryButton` |
| Icon-only | `AppIconButton` (tooltip optional; when present it is the semantic label) |
| Whole card / tile / row | `AppPressable` |
| Text-only action | `AppPressable` for now; `AppTextButton` only when a real one exists |

## 2. The effect — fade only

| Property | Value |
|---|---|
| Type | **opacity fade only** |
| What fades | cards/tiles/rows: the **content** (icon and text). Buttons: the **whole control** (fill/border and label) |
| What stays solid | card/tile/row surfaces. Buttons are the exception and fade as one control. |
| Added visuals | **none** — no border, background, shadow, outline, scale or movement |
| Fade in / out | `AppConstants.pressFadeIn70ms` / `pressFadeOut150ms` |
| Opacity while pressed | `AppConstants.opacityPressed` (0.55) |
| Hold | stays dimmed while the finger is down |
| Quick tap | stays visible for at least `pressMinVisible100ms`, then the action runs |
| Ripple / splash / highlight | **none** — the theme sets `NoSplash` as a safety net |

**Cards, tiles and rows must never become translucent.** Paint their background
and border **outside** `AppPressable`, and put the padding and content **inside**
it. A card that shows the screen behind it on press is not a valid effect.

**Buttons are the exception:** the whole button is one control, so its
fill/border and label fade together. Put the button's visual inside
`AppPressable` and keep the disabled dim outside.

**Counter cards are the other exception:** when the action changes visible
content — the zikr card increments its counter and progress circle — that change
is the feedback. Pass `fadeOpacity: AppConstants.opacityFull` so the content,
circle and surface all stay fully visible on press.

### Card

```dart
AppSectionCard(
  padding: EdgeInsets.zero,
  child: AppPressable(
    onPressed: onTap,
    child: Padding(
      padding: EdgeInsets.all(AppSize.p20),
      child: content,
    ),
  ),
)
```

### Button

```dart
Opacity(
  opacity: enabled ? AppConstants.opacityFull : AppConstants.opacityDisabled,
  child: AppPressable(
    onPressed: onPressed,
    child: Container(
      height: height,
      decoration: decoration, // fill and/or border fades with the label
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
        child: Center(child: Text(label)),
      ),
    ),
  ),
)
```

### Icon tile

```dart
Stack(
  alignment: Alignment.topCenter,
  children: [
    // Surface: solid circle, outside the fade.
    SizedBox(width: AppSize.w48, height: AppSize.h48, child: solidCircle),
    // Content: glyph + label, inside the fade.
    AppPressable(
      onPressed: onTap,
      child: Column(children: [iconBox, label]),
    ),
  ],
)
```

## 3. Target

**The visible surface is the target.** A card's icon, its label, and the gap
between them are one target — never split one card into two hit areas.

- Padding sits **inside** the tappable widget.
- Gaps **between** surfaces sit **outside** it — dead space never fires a tap.
- **Minimum target: 48×48 logical px**, unscaled (`AppConstants.minTapTarget`).
  `AppPressable` enforces it with a `ConstrainedBox`, so a 24px icon or a short
  label gets an invisible halo. The halo is hit area, not a new visual.
- Never shrink the floor with the device-scaled helpers: `AppSize.w48` scales
  down below 48 on small screens.
- `AppIconButton` centers the glyph in `max(AppSize.w48, 48)`.
- `AppPrimaryButton` / `AppSecondaryButton` use `max(AppSize.h48, 48)`.

## 4. Semantics

One action = one node.

- Give the surface a `semanticLabel` when the visible content is not enough on
  its own (`AppIconButton` uses its tooltip).
- Use `excludeChildSemantics: true` when the inner text is decorative or repeats
  the label — a category tile exposes the title once.
- Do **not** exclude child semantics when the surface contains nested actions
  (a zikr card with its own share button). Those actions must stay reachable.
- `AppPressable` owns `button`, `enabled`, `onTap` and `onLongPress`.

## 5. Forbidden

| Forbidden | Use instead |
|---|---|
| `GestureDetector` for a tap | `AppPressable` |
| `InkWell` / `InkResponse` | `AppPressable` |
| `FilledButton` / `OutlinedButton` / `IconButton` directly | `AppPrimaryButton` / `AppSecondaryButton` / `AppIconButton` |
| `ElevatedButton` | never — the design is flat |
| A new pressed border, background tint, shadow or scale | fade the existing visuals only (buttons fade whole; cards fade content) |

`GestureDetector` survives only for non-tap gestures (drag, pinch, double-tap),
and then it must set an explicit `behavior` and `Semantics`.

### Why not a raw `GestureDetector`?

`deferToChild` (the default) makes only the **painted** part tappable — padding
and gaps swallow the press. `opaque` fixes that but also makes dead space
tappable. `AppPressable` sets `opaque` **and** requires the padding to live
inside the surface, so the painted area and the target are the same thing.

## 6. Disabled

`onPressed: null` disables the tap: no fade, no action. Buttons dim the **whole**
control (fill/border and label together) at `AppConstants.opacityDisabled`
(0.45), so a disabled button never looks tappable. If `onLongPress` is set, the
surface stays enabled for the long press (e.g. share with long-press-to-copy).

## 7. Performance

- Idle cost is zero: no ticking controller, no scroll listener, no per-frame
  work. Animation controllers exist only while a press is in flight.
- A press rebuilds only `AppPressable`; the child instance is unchanged.
- Only the pressed surface repaints, and only its content — the solid surface
  behind it does not repaint.
- At most one surface is pressed at a time.

## 8. Checklist

- [ ] Every pressable is `AppPressable` (or an app button).
- [ ] Cards/tiles keep a solid surface and fade their content; buttons fade as a whole.
- [ ] Counter cards (zikr) do not fade: the counter and circle change is the feedback.
- [ ] No translucent card or tile on press (buttons fade their own fill, which is allowed).
- [ ] No ripple, splash, highlight, movement, or new visual.
- [ ] One card = one target; gaps between surfaces are not tappable.
- [ ] Target is at least 48×48, unscaled.
- [ ] One action = one semantic node; nested actions stay reachable.
- [ ] Disabled looks disabled and does not fire.
- [ ] No raw tap primitive outside `AppPressable`.
