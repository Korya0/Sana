# Tokens & Constants — AppSize, AppConstants, Validators, Formatters

**Single source of truth** for every number in `lib/core/`. Read it before
adding a pixel value, a limit or a regex.

Colors, text styles and assets are in [`01_theme.md`](01_theme.md).

| File | Owns |
|---|---|
| `core/constants/app_sizes.dart` | every pixel value in the app |
| `core/constants/app_constants.dart` | everything that is not a pixel — durations, limits, keys |
| `core/utils/app_validators.dart` | input rules: lengths, regexes and error messages |
| `core/utils/app_date_formatter.dart` | dates |
| `core/utils/context_extension.dart` | `BuildContext` sugar |

> Target names. Today the pixel tokens live in `core/constants/app_spacing.dart`
> (`AppSpacing`).

---

## 1. 🚨 The one rule that matters most

> **Never write a number in a widget. Every pixel is `AppSize.*`; every other
> threshold is `AppConstants.*`.**

```dart
// ✅
height: AppSize.h40
maxLines: AppConstants.maxTwoLines

// ❌ FORBIDDEN
height: 40
maxLines: 2
```

---

## 2. `AppSize` — pixels only

### Hard rules

```dart
// ✅ every family, one spelling
AppSize.p16   AppSize.h40   AppSize.w16   AppSize.r16   AppSize.f16   AppSize.icon24

// ❌ FORBIDDEN
EdgeInsets.all(16)
SizedBox(height: 40)
BorderRadius.circular(16)
TextStyle(fontSize: 16)
```

- **Only pixels live here.** A percentage, a ratio, an opacity or a duration is
  **not** a size — it goes in `AppConstants`.

### The scale families — full inventory

```
Icon     icon8  icon12  icon14  icon16  icon18  icon20  icon22  icon24  icon28
         icon32  icon40  icon64  icon80
Padding  p2  p4  p6  p8  p10  p12  p14  p16  p18  p20  p24  p32  p40  p48
Font     f12  f14  f16  f20  f22  f24  f26  f34
Height   h20  h22  h24  h40  h70  h76  h160
Width    w20  w22  w24  w40  w80  w200
Radius   r4  r8  r12  r16  r20
```

| Family | Prefix | Feeds |
|---|---|---|
| Icon / element sizes | `icon*` | icon and element dimensions |
| Padding | `p*` | the most-used family — every `EdgeInsets` and every gap |
| Font sizes | `f*` | `AppTextStyles` only — never `TextStyle(fontSize:)` |
| Heights | `h*` | widget dimensions — `height:`, `minHeight:` |
| Widths | `w*` | widget dimensions — `width:`, `minWidth:` |
| Radii | `r*` | `BorderRadius.circular(AppSize.r16)` |

### 🚨 `AppGap` takes `p*` tokens — and only `p*`

```dart
// ✅ CORRECT
AppGap.h(AppSize.p16)   // vertical gap
AppGap.w(AppSize.p8)    // horizontal gap

// ❌ FORBIDDEN
SizedBox(height: 16)
SizedBox(width: 8)
AppGap.h(AppSize.h16)   // a height token in a gap
AppGap.w(AppSize.w8)    // a width token in a gap
```

**Memory rule:** `Gap = p*`. `Dimension = h*` / `w*`. Never swap.

A `SizedBox` that **constrains a child** is correct and stays — it is not
spacing.

### Naming

- Scale families are **value-named** (`p16`, `h40`): the number *is* the value.
- Component metrics are **role-named** (`dividerThickness`, `seekBarRadius`):
  the number would mean nothing on its own.
- Never mix the two styles inside a group, and never repeat the value in a role
  name.

### Responsiveness — `.r(context)`

Tokens are plain `const` values. For an adjustable dimension that is **not** a
token, scale it with `.r(context)` (width ÷ 375, clamped 0.8×–1.4×):

```dart
// ✅
final size = 320.r(context);

// ❌ FORBIDDEN
final size = 320 * MediaQuery.of(context).size.width / 375;
```

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

## 5. `AppDateFormatter` — dates

- **Never hand-format a date.** Use the extensions here
  (`GregorianFormatting` on `DateTime`, e.g. `toGregorianFull(locale)`).
- No `DateFormat(...)` outside this file.

---

## 6. `ContextExtensions` — `BuildContext` sugar

| Member | Use for |
|---|---|
| `context.color` | every theme color |
| `context.image` | every theme-aware asset |
| `context.unfocus()` | dismiss the keyboard |
| `context.noScalingMediaQuery` | opt out of text scaling — last resort only |
| `context.isDarkMode` | **not for widgets** — read `context.color.*` and let the theme decide |
| `Color.toHex()` | a hex string when one is really needed |

---

## 7. Gates

```bash
flutter analyze   # must print: No issues found!
```

Pre-submit checklist:

- [ ] No raw number in a widget — `AppSize.*` for pixels, `AppConstants.*` otherwise
- [ ] Every `AppGap.h()` / `AppGap.w()` takes a `p*` token — never `h*` or `w*`
- [ ] Empty spacing is `AppGap`, not `SizedBox`
- [ ] No new token without checking for an existing one with that value
- [ ] No API data in `app_constants.dart`
- [ ] Validator messages come from `AppStrings`, not a literal
- [ ] No hand-formatted date outside `app_date_formatter.dart`
- [ ] No `context.isDarkMode` in a widget — use `context.color.*`
