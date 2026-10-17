# Design Theme — Colors, Typography, Icons, Assets

**Single source of truth** for colors, typography, icons and assets. Read it
before adding a color, a text style, an icon or an asset.

- Colors: `core/theme/colors/` · `core/theme/extensions/color_extension.dart`
- Typography: `core/theme/fonts/`
- Icons: `core/theme/icons/app_icons.dart`
- Assets: `core/constants/app_assets.dart` · `core/theme/extensions/assets_extension.dart`
- Numbers, spacing and gaps: [`02_tokens.md`](02_tokens.md)

The `core/theme/extensions/` folder holds the theme-aware layers (`MyColors`,
`MyAssets`): a value that differs between light and dark lives there and is read
through `BuildContext` sugar (`context.color`, `context.image`) — never by
branching on brightness.

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
color: context.isDark ? ColorsDark.primary : ColorsLight.primary,

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
context.isDark ? a : b        // in any widget or helper
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
fontQuran24W400primary  → 24 px · AmiriQuran · w400 · textAccent
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

`core/theme/fonts/app_fonts_family.dart` holds the family names and **one weight
enum per family**. Each enum lists only the weights that family ships, exposed as
`.weight` — an enum field, so it is written `CairoFontWeight.w500.weight`:

| Family | Weights | Used by |
|---|---|---|
| `AppFontsFamily.cairo` | `CairoFontWeight.w500.weight` · `w700.weight` | all UI text |
| `AppFontsFamily.amiriQuran` | `AmiriQuranFontWeight.w400.weight` | Quran text |

### 4.4 How a style is built

Every style derives from one of two private bases — `_app` (Cairo) or `_quran`
(AmiriQuran) — and changes only the size, the weight and the color:

```dart
static const TextStyle _app = TextStyle(fontFamily: AppFontsFamily.cairo);

// Primary
static TextStyle font16W500primary(BuildContext context) => _app.copyWith(
  fontSize: AppSize.f16,
  fontWeight: CairoFontWeight.w500.weight,
  color: context.color.textPrimary,
);
```

- The base carries the `fontFamily`; a style never sets it again.
- Size from `AppSize.f*`, weight from the family enum's `.weight`, color from
  `context.color.*`.
- The private bases are the only place a family is chosen — a family changes in
  one line, not in every style.

### 4.5 Before you add a style

1. **Does it already exist?** Use the existing style before adding a near-twin.
2. **Does the name match what it paints?** The size, weight and role in the name
   must be the truth — fix the name, never the values.
3. **Will it be used?** Don't add a style with no call site.

---

## 5. Icons

`core/theme/icons/app_icons.dart` is the single inventory of icon data. Widgets
read icons only through `AppIcons.*` — never `Icons.*` inline.

```dart
// ✅
Icon(AppIcons.success, size: AppSize.icon24, color: context.color.secondary)

// ❌ FORBIDDEN
Icon(Icons.check_circle_rounded, size: 24)
```

- Name a **concept**, never a glyph. If nothing fits, add the concept to the
  inventory first — a raw `Icons.*` never appears at a call site.
- **One concept, one icon.** Don't add `starGold` beside `starFilled`; extend the
  concept or colour it with `context.color.*`.
- **Size and colour are not part of an icon** — they are an `AppSize.icon*` token
  and a `context.color.*` value, chosen at the call site.
- Group the constants under a short label (`// Navigation`, `// Status`).
- Brand marks and the app logo are SVGs, not icons — see §6.
- The family is an implementation detail: the inventory is Material `IconData`
  today. Switching family must **not** rename a concept — wrap the glyph so
  callers keep asking for the concept.

When told "show X with icon Y", add `Y` to the inventory under its concept name
and read it as `AppIcons.Y`.

---

## 6. Assets

| Kind | Where | Read as |
|---|---|---|
| Identical in both themes | `AppAssets` (`core/constants/app_assets.dart`) | `AppAssets.*` |
| Differs per theme | `MyAssets` (`core/theme/extensions/assets_extension.dart`) | `context.image.*` |

`MyAssets` is the theme-aware layer for assets, exactly like `MyColors` is for
colors: one field per asset that changes between light and dark. It is created
empty and stays empty until the first theme-varying asset exists — an asset that
is the same in both themes belongs to `AppAssets`, never here.

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
2. Same in both themes → add a constant to `AppAssets`.
3. Differs per theme → add the field to `MyAssets` (all spots: constructor,
   field, `copyWith`, `lerp`, `MyAssets.light`, `MyAssets.dark`), then read it as
   `context.image.*`.
4. Check the existing constants first — reuse before adding.

---

## 7. Gates

```bash
flutter analyze   # must print: No issues found!
```

Re-check by hand after touching a theme file:

- [ ] Every color in a widget is `context.color.*` (or `AppColorsCommon.*`)
- [ ] No `Color(...)`, `Colors.*`, or hex literal outside `core/theme/colors/`
- [ ] No `context.isDark` ternary in any widget or helper
- [ ] No color duplicated across `ColorsLight` / `ColorsDark`
- [ ] A `MyColors` change touched all seven spots
- [ ] No inline `TextStyle` and no `copyWith` on a text style
- [ ] Every style derives from `_app` / `_quran`; weights read as `<Family>FontWeight.w*.weight`
- [ ] Icons are read as `AppIcons.*`, never `Icons.*` inline
- [ ] Every asset path is a constant or `context.image.*`
