# Code Conventions

## Shared code

- Any reusable logic, utility, constant, extension or helper used in **2+ places**
  goes in `core/`.
- Check `core/` before writing new shared code — never duplicate across features.
- **No cross-feature imports:** each feature is an isolated vertical slice; only
  `core/` is shared.

## Comments

- Extremely short and consistent: a label or 1–4 words.
- **No comments above class declarations, including `View` classes.**
- In UI trees, label the `Header`, `Body`, and major sections.
- For widgets, use hierarchical comments to identify the widget and its main
  contents when useful, e.g. `// Info (title + subtitle + price)`, followed by
  `// Title`, `// Subtitle`, and `// Price` for the nested elements when needed.
- In data and domain, put a short purpose comment above each method.
- Longer comments are allowed only when necessary to explain complex behavior or
  non-obvious decisions.
- Never use banners, separators, decorative blocks, or comments that merely
  restate the code.

```dart
// Header
const PrayerHeader(),

// Body
Expanded(child: ...),
```

```dart
// Info (title + subtitle + price)
const InfoCard(
  child: Column(
    children: [
      // Title
      TitleWidget(),

      // Subtitle
      SubtitleWidget(),

      // Price
      PriceWidget(),
    ],
  ),
),
```

```dart
// Prayer times
Future<void> loadPrayerTimes() async {}
```
