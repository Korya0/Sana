# Design Theme — Colors, Typography, Assets, Decorations

**Single source of truth** for colors, typography, assets and the shared
decorations. Read it before adding a color, a text style or an asset.

- Colors: `core/theme/colors/` · `core/theme/extensions/color_extension.dart`
- Typography: `core/theme/fonts/`
- Assets: `core/constants/app_assets.dart` · `core/theme/extensions/assets_extension.dart`
- Decorations: `core/common/decorations/` · `core/common/widgets/custom_app_divider.dart`
- Numbers, spacing and gaps: [`02_tokens.md`](02_tokens.md)

---

## 1. The mental model — 3 layers

```
AppColorsCommon            theme-independent. One value, identical in light AND dark.
        │
        ├── ColorsLight    one literal per token (light palette)
        ├── ColorsDark     one literal per token (dark palette)
        │        │
        │        └──► MyColors   ← THE theme-aware layer
        │              MyColors.light / MyColors.dark
        │              widgets read it through:  context.color.*
        │
        └──► used directly when the value must not change with the theme
```

A widget must **never** branch on brightness — that is exactly what the
extension exists to prevent:

```dart
// ❌ FORBIDDEN
color: context.isDarkMode ? ColorsDark.primary : ColorsLight.primary,

// ✅ CORRECT
color: context.color.primary,
```

## 2. 🚨 The rule that prevents the bug

> **Identical in both themes → `AppColorsCommon`.
> Differs between themes → `ColorsLight` + `ColorsDark`, exposed through
> `MyColors`. Never both.**

## 3. Colors

### 3.1 Hard rules

```dart
// ✅
color: context.color.primary      // theme-dependent
color: AppColorsCommon.white      // theme-independent (once it exists)

// ❌ FORBIDDEN — no exceptions
Color(0xFFD4AF37)
Colors.white / Colors.black / Colors.grey
context.isDarkMode ? a : b        // in any widget or helper
```

### 3.2 The palettes — `ColorsLight` · `ColorsDark`

One literal per token, the **same keys** in both files (`core/theme/colors/`):

| Token | Use for |
|---|---|
| `scaffoldBackgroundColor` | the screen background |
| `secondaryScaffoldBackgroundColor` | cards and secondary surfaces |
| `primary` | the brand gold |
| `secondary` | the brand green |
| `error` | error states |
| `textPrimary` | primary text |
| `textSecondary` | secondary text |
| `textAccent` | accent text — aliases `primary` |

### 3.3 `MyColors` — the theme-aware layer

`core/theme/extensions/color_extension.dart`. Read as `context.color.*`:

| Group | Tokens |
|---|---|
| Backgrounds | `scaffoldBackgroundColor`, `secondaryScaffoldBackgroundColor` |
| Brand | `primary`, `secondary` |
| Text | `textPrimary`, `textSecondary`, `textAccent` |
| Status | `error` |
| Subtle | `primarySubtle`, `scaffoldBackgroundSubtle` |

### 3.4 How to add a color

1. **Does it differ between light and dark?**
   - No → add it to `AppColorsCommon` only (see §3.5).
   - Yes → continue.
2. Add the field to `MyColors` — **all seven spots**: constructor param, field,
   `copyWith` param, `copyWith` body, `lerp` body, `MyColors.light`,
   `MyColors.dark`.
3. Add the literal to `ColorsLight` **and** `ColorsDark`.
4. Reference a duplicate literal to the canonical token instead of retyping it
   (`static const textAccent = primary;`).

### 3.5 `AppColorsCommon` — theme-independent

A color identical in both themes is **not** a theme token. It belongs to
`AppColorsCommon`, in a dedicated common-colors file — never to the light/dark
palettes, and never duplicated in both. Create the class with the first such
color.

---

## 4. Typography — `AppTextStyles`

### 4.1 Naming pattern

```
font{size}W{weight}{ColorRole}
font12W500              → 12 px · Cairo · w500
font14W700White         → 14 px · Cairo · w700 · white
fontQuran22W400primary  → 22 px · AmiriQuran · w400 · textAccent
```

`Quran` marks the AmiriQuran family; everything else is Cairo. `ColorRole` is
optional and names the color the style paints.

### 4.2 Hard rules

```dart
// ✅
style: AppTextStyles.font16W500(context)

// ❌ FORBIDDEN
TextStyle(fontSize: 16, color: ...)
someStyle.copyWith(fontSize: 16)
fontFamily: 'AnyFont'
```

- No inline `TextStyle`, no `fontFamily` in UI code.
- Never use `.copyWith` on a style in UI code — the style's job is to be read as
  is.

### 4.3 Families and weights

| Family | Weights | Used by |
|---|---|---|
| `AppFontsFamily.cairo` | `CairoFontWeight.w500` · `w700` | all UI text |
| `AppFontsFamily.amiriQuran` | `AmiriQuranFontWeight.w400` | Quran text |

### 4.4 Before you add a style

1. **Does it already exist?** Use the existing style before adding a near-twin.
2. **Does the name match what it paints?** The size, weight and role in the name
   must be the truth — fix the name, never the values.
3. **Will it be used?** Don't add a style with no call site.

---

## 5. Assets

| Kind | Where | Read as |
|---|---|---|
| Identical in both themes | `AppAssetsConstants` · `AppImageConstants` · `AppSvgConstants`, by asset type | `AppAssets.*` |
| Differs per theme | `MyAssets` in `core/theme/extensions/assets_extension.dart` | `context.image.*` |

> Until that split exists, identical assets live in the single `AppAssets` class
> (`core/constants/app_assets.dart`).

```dart
// ✅
Image.asset(AppAssets.logo)
SvgPicture.asset(context.image.appLogo)   // theme-aware

// ❌ FORBIDDEN
Image.asset('assets/svgs/logo.svg')       // raw path string
```

- Do not duplicate an asset or a constant.

### How to add an asset

1. Put the file under `assets/images/`, `assets/svgs/`, `assets/audio/` or
   `assets/json/`.
2. Same in both themes → add a constant to `AppAssets` (later:
   `AppAssetsConstants` / `AppImageConstants` / `AppSvgConstants`).
3. Differs per theme → add both paths and expose them through `MyAssets`.
4. Check the existing constants first — reuse before adding.

---

## 6. Shared decorations

- `featureCardDecoration()` — feature cards.
- `customAppCardDecoration(context)` — highlighted cards.
- `CustomAppDivider()` — all dividers.
- Never build an inline decoration when a shared one exists.

---

## 7. Gates

```bash
flutter analyze   # must print: No issues found!
```

Re-check by hand after touching a theme file:

- [ ] Every color in a widget is `context.color.*` (or `AppColorsCommon.*`)
- [ ] No `Color(...)`, `Colors.*`, or hex literal outside `core/theme/colors/`
- [ ] No `context.isDarkMode` ternary in any widget or helper
- [ ] No color duplicated across `ColorsLight` / `ColorsDark`
- [ ] A `MyColors` change touched all seven spots
- [ ] No inline `TextStyle` and no `copyWith` on a text style
- [ ] Every asset path is a constant or `context.image.*`
- [ ] A shared decoration was reused instead of a new inline one
