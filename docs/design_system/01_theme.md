# Design Theme — Colors, Typography, Icons & Assets

**Single source of truth.** Read this file before adding or changing any color, text style, icon, or asset.

- Colors: `core/theme/colors/` · `core/theme/extensions/color_extension.dart`
- Typography: `core/theme/fonts/`
- Icons: `core/theme/icons/app_icons.dart`
- Assets: `core/constants/app_assets.dart` · `core/theme/extensions/assets_extension.dart`
- Sizes and spacing: [`02_tokens.md`](02_tokens.md)

## 1. Core Rules

- Reuse existing tokens before creating new ones.
- Theme-dependent values must be accessed through `context.color.*` or `context.image.*`.
- Theme-independent colors belong in `AppColorsCommon`.
- Never branch on brightness inside widgets.
- Never use raw `Color(...)`, `Colors.*`, hex values, or asset paths in UI code.
- Keep light and dark palettes synchronized.
- **Every color token must have a short comment explaining where and when to use it.**
- Never change approved color values without explicit approval.

```dart
// Correct
color: context.color.textPrimary;
color: AppColorsCommon.white;

// Forbidden
color: Color(0xFFD4AF37);
color: context.isDark ? ColorsDark.primary : ColorsLight.primary;
```

## 2. Color Naming & Usage

### Brand colors

- `primary`: Primary brand color for the current theme.
- `secondary`: Secondary brand color for the current theme.

**Important:** `secondary` is a brand color, not the secondary text or icon color.

### Required tokens

| Group | Tokens | Usage |
|---|---|---|
| Backgrounds | `scaffoldBackgroundColor`, `secondaryScaffoldBackgroundColor` | Screen background and cards/default surfaces |
| Brand | `primary`, `secondary` | Main and secondary brand colors |
| Text | `textPrimary`, `textSecondary`, `textDisabled`, `textBrand`, `textBrandSecondary` | Main, supporting, disabled, and brand-colored text |
| Icons | `iconPrimary`, `iconSecondary`, `iconDisabled`, `iconBrand`, `iconBrandSecondary` | Default, supporting, disabled, and brand-colored icons |
| Surfaces | `surfaceBrand`, `surfaceBrandSecondary`, `surfaceSelected`, `surfaceDisabled` | Brand, selected, and disabled backgrounds |
| Borders | `borderBrand`, `dividerColor` | Brand borders and neutral dividers |
| Actions | `actionPrimary`, `actionSecondary` | Primary and secondary interactive backgrounds |
| Text on actions | `textOnPrimary`, `textOnSecondary` | Foreground text on the corresponding action backgrounds |

Do not add `textTertiary`, `iconTertiary`, `textAccent`, `textInverse`, or `iconInverse` unless explicitly required.

### Color usage rules

- `textPrimary`: Main readable text.
- `textSecondary`: Supporting text, regardless of the brand's secondary color.
- `textDisabled`: Text for disabled elements.
- `textBrand`: Text using `primary`.
- `textBrandSecondary`: Text using `secondary`.
- `iconPrimary`: Default icon color; currently green in both themes.
- `iconSecondary`: Supporting icon color.
- `iconDisabled`: Icons for disabled elements.
- `iconBrand`: Icons using `primary`.
- `iconBrandSecondary`: Icons using `secondary`.
- `surfaceBrand` / `surfaceBrandSecondary`: Use only when a surface intentionally needs a brand background.
- `surfaceSelected` / `surfaceDisabled`: Selected and disabled backgrounds.
- `borderBrand`: Borders for highlighted brand elements.
- `dividerColor`: Neutral separators.
- `actionPrimary` / `actionSecondary`: Primary and secondary action backgrounds.
- `textOnPrimary` / `textOnSecondary`: Text colors chosen for sufficient contrast on the corresponding action backgrounds.

**Contrast:** Always verify text and icon contrast against the actual background. If an approved color has insufficient contrast, report the issue and propose an alternative; do not silently change the palette.

## 3. Theme Architecture

```text
AppColorsCommon  → Shared colors, identical in both themes
ColorsLight      → Light palette
ColorsDark       → Dark palette
MyColors         → Theme-aware color extension
context.color.*  → Widget access

AppAssets        → Assets shared by both themes
MyAssets         → Theme-dependent assets
context.image.*  → Widget access
```

When adding a theme-dependent color, update both palettes and every required `MyColors` location: constructor, field, `copyWith`, `lerp`, `MyColors.light`, and `MyColors.dark`.

Use identical token names in both palettes. Never duplicate common colors in the light and dark palettes.

## 4. Approved Color Values

### Light

```dart
static const Color scaffoldBackgroundColor = Color(0xFFF5F6F8);
static const Color secondaryScaffoldBackgroundColor = Color(0xFFFFFFFF);

static const Color primary = Color(0xFF3D9A4B);
static const Color secondary = Color(0xFF246B3B);
```

### Dark

```dart
static const Color scaffoldBackgroundColor = Color(0xFF000000);
static const Color secondaryScaffoldBackgroundColor = Color(0xFF1C1C1E);

static const Color primary = Color(0xFFD4AF37);
static const Color secondary = Color(0xFF18624B);
```

These values are approved. Keep them unchanged unless explicitly instructed otherwise.

### Common colors

`AppColorsCommon` contains only colors intentionally shared between themes, including:

- `successColor`
- `warningColor`
- `errorColor`
- `infoColor`

Define each shared value once. Do not duplicate it in `ColorsLight` and `ColorsDark`.

## 5. Typography — AppTextStyles

- File location: `core/theme/fonts/`
- Cairo is the default UI font; Amiri Quran is used for Quran text.
- Font families and supported weights must be centralized in `app_fonts_family.dart`.
- Use `AppSize.f*` for font sizes and the relevant family weight enum for font weights.
- Reuse existing text styles before creating new ones.
- No inline `TextStyle`, raw `fontFamily`, or `.copyWith` on styles in UI code.

Naming pattern:

```text
font{Size}W{Weight}{ColorRole}
```

Examples: `font12W500`, `font14W700White`, `fontQuran24W400Primary`.

Every style must derive from the appropriate private base (`_app` or `_quran`) and use semantic theme colors when its color varies by theme. The style name must accurately describe its actual color role.

## 6. Icons — AppIcons

- File: `core/theme/icons/app_icons.dart`
- Use `AppIcons.*`; never use raw `Icons.*` in widgets.
- Name icons by concept, not glyph appearance.
- One concept must have one canonical icon; do not duplicate icons for different colors or sizes.
- Use `AppSize.icon*` for sizes and `context.color.icon*` for colors.
- Brand marks and logos belong in assets, not the icon inventory.

## 7. Assets

- Shared assets: `AppAssets.*` in `core/constants/app_assets.dart`.
- Theme-dependent assets: `context.image.*` through `MyAssets`.
- Use existing constants; never hardcode asset paths in widgets.
- Store assets in the appropriate directory: `assets/images/`, `assets/svgs/`, `assets/audio/`, or `assets/json/`.
- When adding a theme-dependent asset, update all required `MyAssets` locations, including constructor, field, `copyWith`, `lerp`, and light/dark configurations.

## 8. Required Comments

Every color declaration must have a short comment immediately above it describing its intended use.

```dart
// Screen background — خلفية الشاشة.
static const Color scaffoldBackgroundColor = Color(0xFFF5F6F8);

// Main readable text — النص الأساسي.
static const Color textPrimary = Color(0xFF000000);

// Supporting text — النص الثانوي. Verify contrast on the target background.
static const Color textSecondary = Color(0xFFBBBEC3);

// Brand-colored icon — أيقونة بلون الهوية الأساسي.
static const Color iconBrand = Color(0xFF3D9A4B);
```

Comments must describe actual usage, not merely repeat the variable name. Add a warning only when a token is easy to misuse or requires a contrast check. Keep comments concise and in English with Arabic clarification when useful.

## 9. Final Checks

Before completing theme changes:

- [ ] Existing tokens were reused wherever possible.
- [ ] Every color declaration has a useful usage comment.
- [ ] Light and dark palettes contain matching semantic tokens.
- [ ] Shared colors exist only in `AppColorsCommon`.
- [ ] Theme-dependent values are accessed through `context.color.*`.
- [ ] No raw colors, inline text styles, raw icon glyphs, or asset paths exist in UI code.
- [ ] Text and icon contrast was checked.
- [ ] All theme extension fields and configurations are synchronized.
- [ ] `flutter analyze` passes with no issues.

**Final rule:** Inspect this document and the existing implementation before introducing anything new. Prefer clear semantic names, concise comments, and the smallest change that satisfies the requirement.
