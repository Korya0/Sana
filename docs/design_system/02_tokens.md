# Tokens & Constants — AppSize, AppConstants, Validators

**Single source of truth** for every number in `lib/core/`. Read it before
adding a pixel value, a limit or a regex.

Colors, text styles and assets are in [`01_theme.md`](01_theme.md).

| File | Owns |
|---|---|
| `core/constants/app_sizes.dart` | every pixel value in the app |
| `core/constants/app_constants.dart` | everything that is not a pixel — durations, limits, keys |
| `core/utils/app_validators.dart` | input rules: lengths, regexes and error messages |
| `core/utils/context_extension.dart` | `BuildContext` sugar |

---

## 1. 🚨 The one rule that matters most

> **Never write a number in a widget. Every pixel is `AppSize.*`; every other
> threshold is `AppConstants.*`.**

```dart
// ✅
height: AppSize.h48
maxLines: AppConstants.maxTwoLines

// ❌ FORBIDDEN
height: 48
maxLines: 2
```

---

## 2. `AppSize` — pixels only

### Hard rules

```dart
// ✅ every family is SCALED to the device
AppSize.p16   AppSize.h48   AppSize.w24   AppSize.r16   AppSize.f16   AppSize.icon24

// ❌ FORBIDDEN
EdgeInsets.all(16)
SizedBox(height: 48)
BorderRadius.circular(16)
TextStyle(fontSize: 16)
```

- **Only pixels live here.** A percentage, a ratio, an opacity or a duration is
  **not** a size — it goes in `AppConstants`.
- `AppSize` values are **getters, not constants** (they scale with
  `_shortestSide`). Two consequences:
  - They **cannot** be used as a `const` default or inside a `const` widget. Make
    the parameter nullable and resolve it in `build()`:
    ```dart
    // ✅
    final double? strokeWidth;
    ... BorderSide(width: strokeWidth ?? AppSize.borderWidth)
    ```
  - Never compute a token once and cache the result.
- `AppSize.init(context)` runs once at startup — `SanaApp` calls it in
  `MaterialApp`'s `builder`. Reading any token before that is a
  `LateInitializationError`.

### The scale families — full inventory

Every value is **scaled** by `_shortestSide / 375` and clamped into a
**0.8× … 1.3×** band, so a token can never collapse or explode on an extreme
device.

```
Icon      icon16  icon24  icon32  icon48
Padding   p4  p8  p12  p16  p20  p24  p32  p40  p48
Font      f12  f14  f16  f20  f24  f32
Height    h40  h48  h56
Width     w24  w40  w48
Radius    r4  r8  r12  r16  r24   + circularRadius (= 99, fully rounds)
```

| Family | Prefix | Feeds |
|---|---|---|
| Icon / element sizes | `icon16`…`icon48` | icon and element dimensions |
| Padding | `p4`…`p48` | the most-used family — **`AppGap` and every `EdgeInsets`** |
| Font sizes | `f12`…`f32` | `AppTextStyles` only — never `TextStyle(fontSize:)` |
| Heights | `h40`…`h56` | widget dimensions — `height:`, `minHeight:` |
| Widths | `w24`…`w48` | widget dimensions — `width:`, `minWidth:` |
| Radii | `r4`…`r24` | `BorderRadius.circular(AppSize.r16)` |

### Composite padding tokens

| Token | Value | Use |
|---|---|---|
| `AppSize.shp` | `EdgeInsets.symmetric(horizontal: p16)` | the screen's horizontal padding |
| `AppSize.stp` | `p16` | the top padding above a screen's content |
| `AppSize.sbp` | `p40` | the bottom inset of a screen or a scrolling list |

`AppSize.keyboardHeight(context)` reads the keyboard inset — use it instead of
`MediaQuery.viewInsetsOf` in a widget.

### Component metrics — role-named, not value-named

```
Borders    borderWidth (1) · dividerThickness (1)
Layout     contentMaxWidth (640, unscaled)
```

These carry no number in their name, because the number would mean nothing alone.

### Breakpoints

```dart
static const double bpMobile = 600;
static const double bpTablet = 900;
static const double bpDesktop = 1200;
```

`context.sizeClass` reads them and returns `compact` / `medium` / `expanded` /
`large`.

### 🚨 `AppGap` takes `p*` tokens — and only `p*`

```dart
// ✅ CORRECT
AppGap.h(AppSize.p16)   // vertical gap
AppGap.w(AppSize.p8)    // horizontal gap

// ❌ FORBIDDEN
SizedBox(height: 16)
SizedBox(width: 8)
AppGap.h(AppSize.h48)     // a height token in a gap
AppGap.w(AppSize.icon24)  // an icon token in a gap
```

**Memory rule:** `Gap = p*`. `Dimension = h*` / `w*`. Never swap. Nothing but a
`p*` token ever goes into an `AppGap`.

A `SizedBox` that **constrains a child** is correct and stays — it is not
spacing.

### Naming

- Scale families are **value-named** (`p16`, `h48`, `f24`, `icon24`, `r8`): the
  number *is* the value.
- Component metrics are **role-named** (`borderWidth`, `contentMaxWidth`): the
  number would mean nothing on its own.
- Never mix the two styles inside a group, and never repeat the value in a role
  name.

### Adding a size

1. Look for an existing token with that value first — `p16` already covers 16.
2. If nothing fits, add it to the family, in ascending order.
3. **Don't add speculative tokens** — add the token when the screen that needs
   it exists.

---

## 3. `AppConstants` — everything that isn't a pixel

- **Nothing here is a pixel.** Anything in px, dp or a corner radius belongs to
  `AppSize`.
- Durations carry their unit in the name: `animationFast200ms`,
  `locationTimeout5s`, `remoteConfigFetchInterval12h`.
- Purpose-named values are used in exactly one place: `splashDelay1500ms`,
  `apiTimeout`.
- **Never put API data here** — no URLs, ids or names. If the backend will send
  it, it is not a constant.

### Adding a constant

1. Confirm it isn't a pixel (→ `AppSize`) or API data (→ the feature).
2. Add it to the right group and keep the group ordered.
3. Reuse an existing constant instead of adding a near-duplicate.

---

## 4. `AppValidators` — input rules in one place

- All input rules live here, so a rule can never be enforced in one place and
  forgotten in another.
- Error messages come from `AppStrings` — never a literal string in a widget.
- A validator returns `String?` (the message) or `null`:

```dart
// ✅
validator: validateFeedbackIssue,

// ❌ NEVER
validator: (v) => v!.trim().isEmpty ? 'required' : null,
```

---

## 5. `ContextExtensions` — `BuildContext` sugar

| Member | Use for |
|---|---|
| `context.color` | every theme color |
| `context.image` | every theme-aware asset |
| `context.unfocus()` | dismiss the keyboard on submit |
| `context.preventTextScaling(child)` | opt out of text scaling — last resort only |
| `context.reduceMotion` | skip animations when the user asked for less motion |
| `context.sizeClass` / `context.isLandscape` | orientation and width-class layout decisions |
| `context.locale` / `isArabic` / `isRtl` | direction and locale checks |
| `context.isDark` | **not for widgets** — read `context.color.*` and let the theme decide |
| `Color.toHex()` | a hex string when one is really needed |

---

## 6. Gates

```bash
flutter analyze   # must print: No issues found!
```

Pre-submit checklist:

- [ ] No raw number in a widget — `AppSize.*` for pixels, `AppConstants.*` otherwise
- [ ] No `const` default or `const` widget uses an `AppSize` token
- [ ] Every `AppGap.h()` / `AppGap.w()` takes a `p*` token — never `h*`, `w*`, icon or font
- [ ] Empty spacing is `AppGap`, not `SizedBox`
- [ ] No new token without checking for an existing one with that value
- [ ] No API data in `app_constants.dart`
- [ ] Validator messages come from `AppStrings`, not a literal
- [ ] No `context.isDark` in a widget — use `context.color.*`
