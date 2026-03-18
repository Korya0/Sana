# 🎯 DART & FLUTTER BEST PRACTICES (2026)

## ⚡ Performance — The "Thread Merge" Era (3.29+)
- **Critical:** Blocking operations now block the UI thread directly.
- Use `Isolate.run()` for any heavy work (JSON > 50KB, image processing, complex logic).
- Avoid `Opacity`, `ColorFiltered` in animations — use `AnimatedOpacity` or `FadeTransition`.

## 🎨 Impeller 2.0 (Flutter 3.41+)
- **No SkSL warmup:** Legacy shader warmup logic is now dead weight. Remove it.
- **Grouped Filters:** Use `BackdropFilter.grouped` for multiple effects.
- **Const Constructors:** Use them everywhere to minimize rebuilds.

## 📐 Modern Dart (3.10+)
- **Dot Shorthands:** Use `.center` instead of `MainAxisAlignment.center` where context is clear.
- **Records & Patterns:** Prefer them over custom tuples or complex if-chains.
- **Sealed Classes:** Use for exhaustive state and type modeling.

## 🛠️ Code Quality
- **Line Length:** Max 80 characters.
- **Naming:** `PascalCase` classes, `camelCase` variables/functions, `snake_case` files.
- **Deprecated APIs:** Immediately flag and propose fixes (e.g., `withOpacity` -> `withValues`).
- **Private Widgets:** Use small private `Widget` classes instead of helper methods.

## 🔐 Security
- **No Hardcoded Secrets:** Use `--dart-define-from-file`.
- **Sensitive Data:** Use `flutter_secure_storage` for tokens. Never `SharedPreferences` for auth.
- **Logging:** Never log PII, tokens, or full sensitive API responses.
