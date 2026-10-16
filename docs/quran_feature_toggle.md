# Quran Feature Toggle

**Prompt for an AI:** _"Read `docs/quran_feature_toggle.md` and toggle the Quran feature."_

Toggles the Quran feature (`quran_library`) in this app. Only comment/uncomment existing code — never add, delete, or move files.

## 1) Detect the current state

```bash
grep -n "quran_library" pubspec.yaml
```

- `quran_library: ^4.2.0` (active) → **ENABLED** → disable it (§3)
- `# quran_library: ^4.2.0` (commented) → **DISABLED** → enable it (§4)

## 2) Files to toggle

- `pubspec.yaml` → the `quran_library` dependency
- `lib/features/quran/**` → all 10 files (comment the whole file / uncomment it)
- `lib/core/di/features_di.dart` → import + `setupQuranDependencies(sl)`
- `lib/features/main_layout/presentation/routes/main_layout_routes.dart` → quran imports + the `/quran` `StatefulShellBranch`
- `lib/features/main_layout/presentation/pages/main_layout_view.dart` → the Quran `BottomNavigationBarItem`
- `lib/core/routing/app_routes.dart` → `static const quran = '/quran';`
- `lib/core/constants/app_strings.dart` → `quranKareem`, `quranCorrection`, `quranInitError`
- `android/app/src/main/kotlin/com/sana/muslim/app/MainActivity.kt` → base class (see §5)

Mark every disabled line with `// DISABLED: Quran feature.`

## 3) Disable

1. Comment out all of `lib/features/quran/**` (all 10 files).
2. Comment `quran_library: ^4.2.0` in `pubspec.yaml`.
3. Comment the quran lines in the 6 wiring files listed in §2.
4. In `MainActivity.kt`, use `FlutterActivity` (see §5).
5. Run `flutter pub get`.

## 4) Enable

Exact reverse of §3: restore `quran_library: ^4.2.0`, uncomment all of `lib/features/quran/**` and the wiring lines, set `MainActivity` back to `AudioServiceActivity`, then run `flutter pub get`.

## 5) Critical traps

- **`MainActivity.kt` base class depends on `audio_service`,** which comes transitively with `quran_library`:
  - Package present → `class MainActivity : AudioServiceActivity()`
  - Package absent → `class MainActivity : FlutterActivity()`

  Forgetting this is the main cause of "missing class" build failures.
- **Nav count must equal branch count:** 3 items/3 branches when enabled, 2/2 when disabled. Keep `main_layout_view.dart` and `main_layout_routes.dart` in sync.
- Two files import `package:quran_library` directly (`data/repos/quran_repo.dart`, `widgets/quran_success_widget.dart`) — they break analysis if not commented while disabled.
- Leave `pubspec.lock` and `ios/Podfile.lock` alone; they regenerate.

## 6) Verify

```bash
flutter pub get
flutter analyze
```

Done when `flutter analyze` reports **no errors** (Gradle/AGP/Kotlin version warnings are pre-existing and unrelated).

## 7) Current state

**DISABLED** (verified by a successful `flutter run --profile` build + install after disabling).
