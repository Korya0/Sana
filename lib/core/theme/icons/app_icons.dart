import 'package:flutter/material.dart';

/// Every icon the app is allowed to use — one concept per meaning.
///
/// The same idea used to be drawn with a different glyph on every screen (a star
/// as `Icons.star`, `Icons.star_border`, `Icons.star_outline`), so the same
/// meaning looked different depending on who wrote the screen. Here the glyph is
/// chosen **once**: a widget asks for a *concept*, never for a shape.
///
/// ```dart
/// Icon(AppIcons.success, size: AppSize.icon24, color: context.color.secondary)
///
/// // ❌ the glyph is not decided at the call site
/// Icon(Icons.check_circle_rounded, size: 24)
/// ```
///
/// Rules
///
/// - Name a **concept**, never a glyph. If nothing fits, add the concept here
///   first — never reach for the icon set directly.
/// - One concept, one icon. Do not add `starGold` beside `starFilled`; extend
///   the concept or colour it with `context.color.*`.
/// - Size and colour are **not** part of an icon — they are `AppSize.icon*` and
///   `context.color.*` at the call site.
/// - Brand marks and the app logo are SVGs, not icons — see `AppAssets`.
///
/// Changing the icon family
///
/// The family is an implementation detail: this inventory is written with
/// Material `IconData` today, but the **concept names must not change** if the
/// backing package does. To switch families, wrap the glyph so callers keep
/// asking for the concept — e.g. a sealed `AppIconData` with a Material and a
/// Font Awesome variant, rendered by a single `AppIcon` widget.
///
/// So when you are told "show X with icon Y", add `Y` here under its concept
/// name and use `AppIcons.Y` — never a raw `Icons.*`.
class AppIcons {
  AppIcons._();

  // Status
  static const IconData success = Icons.check_circle_outline_rounded;
  static const IconData error = Icons.error_outline_rounded;
}
