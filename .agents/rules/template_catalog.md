# 📦 Flutter Template Catalog — Final v2.0

> **89 Flutter Templates** aligned with `AI_INSTRUCTIONS.md` v1.2.0
> **How to use:** Copy a prompt below → Paste in a new conversation → AI generates the code based on the template.

---

## 📋 How to Use These Templates

1. Pick a template from the list below.
2. Copy its **Prompt/Description**.
3. Open a new conversation with AI.
4. Paste the prompt → AI uses the predefined architecture in `Templates/` to generate your feature.

---

## 🏗️ A — Architecture & Project Scaffolding (6)

### A1 — Full Feature Scaffold
```

This template scaffolds a COMPLETE clean architecture feature. Follow @AI_INSTRUCTIONS.md strictly.

Variables:
- {{name}} — feature name (e.g., auth, products)
- {{entity}} — main entity name (e.g., User, Product)
- {{use_domain}} — boolean: include Domain layer (entities, use cases, repo interface) or skip for simple CRUD

Generated structure:
lib/features/{{name}}/
├── di/{{name}}_di.dart                      (DIHelper registration or manual)
├── data/models/{{entity}}_dto.dart          (JsonSerializable DTO + toEntity() extension)
├── data/sources/{{name}}_api_service.dart   (Retrofit @RestApi)
├── data/repos/{{name}}_repository.dart      (ApiResult wrapping, error mapping)
├── domain/entities/{{entity}}_entity.dart   (if use_domain — Equatable, immutable)
├── domain/use_cases/...                     (if use_domain — only if logic warrants)
├── presentation/cubit/{{name}}_cubit.dart   (Cubit with constructor injection)
├── presentation/cubit/{{name}}_state.dart   (Native sealed classes, NOT Freezed)
├── presentation/view/{{name}}_view.dart     (BlocProvider + BlocBuilder + exhaustive switch)

Plus test files mirroring the above:
test/features/{{name}}/
├── cubit/{{name}}_cubit_test.dart           (blocTest + mocktail)
├── data/repos/{{name}}_repository_test.dart (mock API, test ApiResult mapping)

Plus route registration snippet for GoRouter.

Rules: Constructor injection, ApiResult in Data only, sealed states, Equatable entities, BlocListener for side effects.
```

### A2 — Simple CRUD Feature
```

Lightweight feature WITHOUT Domain layer — Cubit calls Repo directly. Follow @AI_INSTRUCTIONS.md.

Variables:
- {{name}} — feature name
- {{entity}} — main entity name

Generated: data/ (model, source, repo) + presentation/ (cubit, sealed states, view) + di/ + test files + route.
No domain/ folder. No use cases. No repo interface.
Rules: Same as A1 but simpler. ApiResult in Data only. Sealed states.
```

### A3 — Core Project Bootstrap
```

Scaffolds the entire core/ folder for a new Flutter project. Follow @AI_INSTRUCTIONS.md.

Variables:
- {{project_name}} — project name
- {{base_url_dev}} — dev API base URL
- {{base_url_prod}} — prod API base URL

Generated:
lib/core/
├── di/setup_di.dart, core_di.dart, di_helper.dart
├── networking/dio_factory.dart, api_result.dart, api_error_handler.dart
├── router/app_router.dart (GoRouter shell with errorBuilder/404)
├── theme/app_theme.dart (light/dark, color tokens, text styles)
├── utils/app_logger.dart (kDebugMode gated)
├── config/app_config.dart (dart-define env)
main.dart (bootstrap only)

Rules: Dio with auth interceptor placeholder, kDebugMode logging, dart-define env config.
```

### A4 — Feature DI Registration
```

Variables: {{name}}, {{entity}}, {{multi_source}} (boolean: single API or Remote+Local)
If single source → DIHelper pattern. If multi_source → explicit registration.
Follow @AI_INSTRUCTIONS.md DI section.
```

### A5 — Modular Package Feature
```

Package-per-feature for large apps (15+ features). Own pubspec.yaml, own lib/, own test/.
Variables: {{name}}, {{entity}}
Follow @AI_INSTRUCTIONS.md monorepo section.
```

### A6 — Localization (L10n) Setup
```

One-time project setup for flutter_localizations. ARB files (en, ar), AppLocalizations class, l10n.yaml config.
Variables: {{default_locale}} (default: en), {{supported_locales}} (default: en,ar)
```

---

## 🧠 B — State Management (8)

### B1 — Standard Cubit + Sealed States
```

Variables: {{name}}, {{feature}} (parent feature name)
Generated: cubit.dart + state.dart (sealed: Initial, Loading, Success, Failure)
Include: BlocListener example for side effects (Snackbar/Navigation).
Rules: Native sealed classes, NOT Freezed. Constructor injection. Exhaustive switch.
```

### B2 — Paginated List Cubit
```

Variables: {{name}}, {{entity}}
States: Initial, Loading, Loaded(items, hasMore, currentPage), LoadingMore, Failure
Methods: loadInitial(), loadMore(), refresh()
Rules: End-of-list detection, prevent duplicate calls during loading.
```

### B3 — Form Validation Cubit
```

Variables: {{name}}, {{fields}} (comma-separated field names, e.g., "email,password,name")
States: FormState with per-field validation errors, isSubmitting, isValid
Methods: updateField(), validate(), submit()
```

### B4 — Search/Filter Cubit
```

Variables: {{name}}, {{entity}}
Features: Debounced search (300ms), filter combinations, empty state.
Uses Debouncer utility (K3).
```

### B5 — Multi-Tab Cubit
```

Variables: {{name}}, {{tab_count}} (number of tabs)
Each tab has independent loading state. Companion to E6 (StatefulShellRoute).
```

### B6 — Real-Time Cubit (Stream)
```

Variables: {{name}}, {{entity}}
Cubit listening to a Stream (Firestore/WebSocket). StreamSubscription with auto-cancel in close().
```

### B7 — Global/App-Level Cubit
```

Variables: {{name}} (e.g., auth, theme, locale)
lazySingleton registration (not factory). Provided above MaterialApp.
Example: AuthCubit watching login state, ThemeCubit for dark mode.
```

### B8 — Multi-Step/Wizard Cubit
```

Variables: {{name}}, {{step_count}} (number of steps)
One Cubit spanning multiple screens. Step tracking, data collection per step, final submit.
For onboarding, checkout, multi-page forms.
```

---

## 🌐 C — Networking & Data Layer (12)

### C1 — Dio Factory + Interceptors
```

Complete dio_factory.dart: base options, connectTimeout, receiveTimeout.
Auth interceptor placeholder (Bearer token injection).
Logging interceptor gated behind kDebugMode with pretty-printing.
Variables: {{base_url_key}} (dart-define key name)
```

### C2 — Retrofit API Service
```

Variables: {{name}}, {{base_path}} (e.g., /api/v1/users)
@RestApi abstract class with GET, POST, PUT, DELETE examples.
@Body, @Path, @Query, @Header annotations.
```

### C3 — ApiResult + ApiErrorHandler
```

ApiResult<T> sealed class (Success, Failure).
ApiErrorHandler mapping DioException types → structured error with message.
Lives in core/networking/. Data layer only.
```

### C4 — Repository Implementation
```

Variables: {{name}}, {{entity}}
Repo calls Retrofit client, wraps in ApiResult, catches DioException.
Includes DTO→Entity mapping via extension method (e.g., UserDto.toEntity()).
```

### C5 — Offline-First Repository
```

Variables: {{name}}, {{entity}}
Strategy: fetch API → cache locally (Hive/Isar) → fallback to cache on failure.
Remote + Local source. Explicit DI (not DIHelper).
```

### C6 — Auth Interceptor (Token Refresh)
```

Full auth interceptor: inject Bearer from secure storage, catch 401, call refresh token API,
retry original request with new token, handle refresh failure (force logout).
Uses QueuedInterceptorsWrapper for thread safety.
```

### C7 — SSL Pinning Interceptor
```

Dio interceptor for certificate pinning. SHA-256 pin verification.
Support for certificate rotation (multiple pins). Fail-closed on mismatch.
```

### C8 — File Upload Service
```

Multipart upload via Dio/Retrofit. Progress tracking via onSendProgress.
Variables: {{endpoint}}
```

### C9 — WebSocket/Real-Time Client
```

WebSocket or SSE client. Auto-reconnect on disconnect.
Variables: {{name}}
Separate from Dio/REST. Includes connection state management.
For chat, live tracking, notifications.
```

### C10 — File Download Service
```

Large file download with progress tracking. Save to device file system.
Handle storage permissions (Android/iOS). Resume interrupted downloads.
```

### C11 — Mock Interceptor
```

Dio interceptor that intercepts API calls → returns local JSON mock files.
Simulated delay (200-500ms). Enabled only in Dev environment.
For backend-not-ready scenarios. Maps request path → JSON asset file.
```

### C12 — HTTP Cache Interceptor
```

GET response caching for static/semi-static data.
Configurable TTL per endpoint. Memory + disk cache.
For countries lists, categories, config endpoints.
```

---

## ❄️ D — Data Models (6)

### D1 — Freezed DTO (Complex)
```

Variables: {{name}}, {{fields}} (comma-separated, e.g., "id:int,name:String,email:String?")
Full Freezed model with fromJson, toJson, copyWith. Part file.
```

### D2 — JsonSerializable DTO + Request Model
```

Variables: {{name}}, {{fields}}, {{is_request}} (boolean)
If response: fromJson + toJson + toEntity() extension.
If request: toJson only, includeIfNull: false, no fromJson.
```

### D3 — Domain Entity (Equatable)
```

Variables: {{name}}, {{fields}}
Plain Dart class extending Equatable. Immutable, final fields.
No dependencies. No fromJson/toJson. Clean domain object.
```

### D4 — Pagination Response Model
```

Generic PaginatedResponse<T> with: items, total, page, pageSize, hasMore.
fromJson with item parser function. Lives in core/networking/.
```

### D5 — Enum with JSON Mapping
```

Variables: {{name}}, {{values}} (comma-separated)
@JsonValue annotations. fromString factory. Unknown/fallback value handling.
```

### D6 — Local DB Models
```

Variables: {{name}}, {{fields}}, {{db_type}} (hive or isar)
If Hive: @HiveType, @HiveField annotations, TypeAdapter.
If Isar: @Collection, Id field.
Separate from JSON DTOs. Includes toDto()/fromDto() mapping.
```

---

## 🗺️ E — Navigation (6)

### E1 — GoRouter Full Setup
```

Complete app_router.dart: route tree, named route constants, GoRouter config.
Includes errorBuilder (404 page with "Go Home" button).
Variables: {{has_auth}} (boolean: include auth redirect)
```

### E2 — Auth Route Guard
```

GoRouter redirect: unauthenticated → /auth/login. Uses AuthCubit state.
GoRouterRefreshStream with listenable for reactive auth changes.
```

### E3 — Shell Route with Bottom Nav
```

Variables: {{tabs}} (comma-separated tab names, e.g., "home,search,profile")
ShellRoute wrapping bottom navigation. Nested routes per tab.
```

### E4 — Deep Link Handling
```

Route config for deep links. Path parameter extraction + validation.
Variables: {{scheme}}, {{host}} (e.g., myapp, example.com)
```

### E5 — TypedGoRoute Setup
```

Type-safe routing with @TypedGoRoute. Code-generated route classes.
Variables: {{name}}, {{params}} (route parameters)
```

### E6 — StatefulShellRoute
```

Variables: {{tabs}} (comma-separated)
StatefulShellRoute preserving tab state (scroll position, Cubit state) via IndexedStack.
Companion to B5 (Multi-Tab Cubit). Each branch independent.
```

---

## 🔐 F — Security (8)

### F1 — Environment Config
```                             

AppConfig class reading --dart-define-from-file values.
.env.dev.json, .env.prod.json templates + .env.example (committed).
Variables: {{keys}} (comma-separated config keys, e.g., "BASE_URL,API_KEY")
```

### F2 — Secure Token Storage
```

flutter_secure_storage wrapper: saveToken(), getToken(), deleteToken(), clearAll().
Handles platform-specific options (Android EncryptedSharedPreferences, iOS Keychain).
```

### F3 — Envied Obfuscated Keys
```

envied setup with obfuscate: true. @Envied annotation class.
Variables: {{keys}} (comma-separated API key names)
```

### F4 — Jailbreak/Root Detection
```

Device security check: rooted/jailbroken/emulator detection.
Configurable policy: warn (show dialog) vs block (force close).
```

### F5 — Biometric Auth Service
```

local_auth wrapper. Check availability, authenticate with fingerprint/face.
For sensitive operations or app lock on launch.
```

### F6 — Screen Capture Prevention
```

Secure flag preventing screenshots/screen recording.
Platform-specific: Android FLAG_SECURE, iOS screenshot notification handling.
```

### F7 — Inactivity/Session Timeout
```

Auto-lock after X minutes idle. AppLifecycleState observer.
Variables: {{timeout_minutes}} (default: 5)
Options: force logout OR require biometric re-auth.
```

### F8 — Local DB Encryption
```

Variables: {{db_type}} (hive, isar, sqflite)
Encryption key from SecureStorage (F2). SQLCipher for sqflite, built-in for Hive/Isar.
```

### F9 — Permissions Handler
```

Centralized AppPermissionsManager using permission_handler.
request(), check(), and openSettings() methods. Prevents OS crash on rejected dialogs.
```

---

## 🎨 G — UI & Presentation (13)

### G1 — Screen with BlocProvider
```

Variables: {{name}}, {{cubit_name}}
BlocProvider + BlocBuilder with exhaustive switch on sealed states.
Loading/Error/Success rendering. BlocListener for side effects.
```

### G2 — Paginated ListView Screen
```

Variables: {{name}}, {{entity}}
ListView.builder + ScrollController for infinite scroll. RefreshIndicator.
Uses B2 Cubit pattern. End-of-list loading indicator.
```

### G3 — Form Screen
```

Variables: {{name}}, {{fields}}
TextEditingControllers per field. Form validation. Submit flow.
Uses B3 Cubit pattern. Dispose controllers properly.
```

### G4 — Responsive Scaffold
```

LayoutBuilder-based breakpoints: mobile (<600), tablet (<1200), desktop.
Adaptive navigation: drawer (mobile), rail (tablet), sidebar (desktop).
```

### G5 — Empty/Error/Loading Widgets
```

AppEmptyView (icon + message + optional action button).
AppErrorView (message + retry callback).
AppLoadingView (centered indicator).
Reusable across all screens.
```

### G6 — Adaptive Dialog/Bottom Sheet
```

Show as dialog on tablet, bottom sheet on mobile. Platform-responsive.
Shared content builder. Dismiss callbacks.
```

### G7 — Theme Setup
```

Variables: {{primary_color}}, {{font_family}} (Google Fonts)
AppTheme with light/dark ThemeData. Color tokens, text styles, component themes.
Import Google Fonts package.
```

### G8 — Shimmer Loading Skeleton
```

Shimmer effect widgets: ShimmerListItem, ShimmerCard, ShimmerProfile.
Variables: {{type}} (list_item, card, profile, custom)
Uses shimmer package.
```

### G9 — Slivers/CustomScrollView
```

Variables: {{name}}
CustomScrollView + SliverAppBar (collapsing) + SliverList.
For product detail, user profile, complex scrolling screens.
```

### G10 — Snackbar/Toast Manager
```

AppSnackbar helper: showSuccess(), showError(), showWarning().
Consistent styling (green/red/yellow). One-line calls.
Lives in core/utils/.
```

### G11 — Adaptive UI Primitives
```

Cross-platform responsive elements (Buttons, Switches, Dialogs, Loaders).
Reads Platform.isIOS to render Cupertino vs Material seamlessly.
Includes: AppButton, AppSwitch, AppLoader, AppDialog.
```

### G12 — Haptic Feedback Engine
```

AppHaptics helper: lightImpact(), mediumImpact(), heavyImpact(), selectionClick().
Wraps Flutter's HapticFeedback.
Ensures premium native button feels and semantic error vibrations.
Lives in core/utils/.
```

### G13 — Keyboard & Focus Manager
```

KeyboardDismisser widget wrapper + AppFocusHelper.
Automatically dismisses keyboard on outside taps (crucial for iOS UX).
Handles form focus nodes cleanly.
```

---

## 💉 H — Dependency Injection (6)

### H1 — Core DI Setup
```

setup_di.dart (init function calling all feature DIs).
core_di.dart (Dio, shared services, app-level Cubits).
GetIt instance export.
```

### H2 — DIHelper Class
```

Generic DIHelper.registerFeature<T, R>() from @AI_INSTRUCTIONS.md.
Exact implementation from the rules. Single file.
```

### H3 — Multi-Source Feature DI
```

Variables: {{name}}, {{entity}}
Explicit registration: Remote API + Local DAO + Repository + UseCases + Cubit.
For offline-first features. No DIHelper.
```

### H4 — Async Dependencies Setup
```

registerSingletonAsync for Firebase, Hive, SharedPreferences.
Splash screen waiting for locator.allReady() before navigation.
```

### H5 — Scoped Dependencies [ADVANCED]
```

pushNewScope/popScope for temporary DI scopes.
Variables: {{scope_name}}
Use for complex flows (checkout, document editing). Prevents memory leaks.
Mark as ADVANCED — use only when needed.
```

### H6 — Environment Mock Injection
```

Simple if (AppConfig.isDev) → MockRepo, else → RealRepo.
No injectable package. No code generation. Pure GetIt.
Variables: {{name}} (feature to mock)
```

---

## 🪵 I — Logging & Monitoring (5)

### I1 — AppLogger
```

kDebugMode gated. Levels: debug, info, warn, error.
error() sends to Crashlytics in prod. No print() or debugPrint().
Never log tokens, passwords, PII. Single file in core/utils/.
```

### I2 — Crashlytics Setup
```

Firebase Crashlytics init in main.dart.
FlutterError.onError + PlatformDispatcher.instance.onError.
recordError for non-fatal. Don't log expected domain exceptions.
```

### I3 — Performance Monitoring
```

Firebase Performance or custom trace wrapper.
API call tracing, screen load tracing. Auto HTTP metric collection.
```

### I4 — Analytics/Event Tracking
```

AppAnalytics wrapper: logScreenView(), logEvent(), setUserProperty().
Firebase Analytics integration. Lives in core/utils/.
```

### I5 — Crashlytics User Context
```

After login: setUserIdentifier(userId).
setCustomKey for app state (dark mode, cart count, active feature).
Enriches crash reports. Linked to AuthCubit (B7).
```

---

## 🧪 J — Testing (7)

### J1 — Cubit Unit Test
```

Variables: {{name}}, {{cubit_name}}
mocktail + bloc_test. Mock repo. blocTest() with act/expect. Verify state transitions.
```

### J2 — Repository Unit Test
```

Variables: {{name}}
Mock API service. Test success path (ApiResult.success). Test failure path (DioException mapping).
```

### J3 — UseCase Unit Test
```

Variables: {{name}}
Mock repo. Test business logic. Verify orchestration of multiple repo calls.
```

### J4 — Widget Test
```

Variables: {{widget_name}}
pumpWidget, find, tap, verify. MaterialApp wrapper. Mock dependencies.
```

### J5 — Test Helpers & Fixtures
```

Shared test utilities: FakeEntity factories, MockRepo/MockCubit declarations.
test/helpers/ directory. Reusable across all tests.
```

### J6 — Golden Tests [OPTIONAL]
```

Variables: {{widget_name}}
golden_toolkit or alchemist setup. Screenshot comparison.
Reference image generation. Multi-device size testing.
Mark as OPTIONAL — adopt when design consistency is priority.
```

### J7 — Integration/E2E Tests
```

Variables: {{flow_name}} (e.g., login_flow, checkout_flow)
integration_test package. Full app launch on emulator.
Tap, enter text, verify navigation. End-to-end.
```

---

## ⚡ K — Performance & Advanced (6)

### K1 — Isolate Heavy Computation
```

Isolate.run() wrapper for JSON parsing >50KB, image processing.
Generic compute<T>() helper. Thread Merge aware (Flutter 3.29+).
```

### K2 — Cached Network Image Setup
```

cached_network_image config. Placeholder (shimmer from G8), error widget.
Cache management settings. AppCachedImage widget wrapper.
```

### K3 — Debouncer Utility
```

Reusable Debouncer class. Timer-based. Configurable duration.
run(), cancel(), dispose(). For search, scroll, auto-save.
```

### K4 — Throttler Utility
```

Execute once per X duration, ignore subsequent calls until cooldown.
Prevents double-submit (payment, like buttons). Companion to K3.
```

### K5 — Image Cache Manager
```

PaintingBinding.instance.imageCache config in main.dart.
maximumSizeBytes, maximumSize. Prevents OOM on image-heavy screens.
```

### K6 — Asset Pre-loader
```

precacheImage for critical images. SVG pre-compile (flutter_svg).
Called during splash screen. Eliminates first-render flicker.
```

### K7 — Background Task Manager
```

workmanager wrapper to execute silent tasks (15 min+ intervals).
Sync data, push local notifications, or clear cache while app is killed.
```

---

## 📬 L — DevOps & Workflow (9)

### L1 — PR Template
```

.github/pull_request_template.md matching @AI_INSTRUCTIONS.md Post-Task Output format.
Sections: Summary, Changes, Testing, Checklist.
```

### L2 — PROJECT_CONTEXT.md Template
```

Variables: {{project_name}}, {{description}}
All sections: Business Context, Domain Rules, Roadmap, Current State, Decision Log, Active Plugins.
```

### L3 — Feature Checklist
```

Step-by-step markdown checklist for implementing a feature end-to-end.
From data layer → domain → presentation → DI → tests → PR.
```

### L4 — Analysis Options
```

Strict analysis_options.yaml. flutter_lints + custom rules.
Enforce conventions from @AI_INSTRUCTIONS.md (naming, imports, etc.).
```

### L5 — CI/CD Pipeline
```

.github/workflows/ci.yml: analyze → test → coverage report → build (dev/prod) → deploy.
Variables: {{deploy_target}} (firebase_hosting, play_store, testflight)
```

### L6 — Fastlane Setup
```

Fastfile + Appfile for iOS and Android.
Lanes: beta (TestFlight/Internal Track), release (App Store/Play Store).
Certificate management (Match for iOS).
```

### L7 — Git Pre-commit Hooks
```

lefthook.yml config. Pre-commit: dart format + dart analyze.
Pre-push: run tests. Prevents bad code from entering repo.
```

### L8 — Makefile/Task Runner
```

Makefile with targets: build (build_runner), test, coverage, clean, format, analyze, run_dev, run_prod.
Shortcuts for repetitive commands.
```

### L9 — Versioning & Changelog
```

Conventional Commits guide. CHANGELOG.md auto-generation setup.
Version bump script (patch/minor/major). pubspec.yaml version update.
```

### L10 — Mission Manifest
```

Mandatory documentation for any non-trivial mission or task. Follow @AI_INSTRUCTIONS.md section "MISSION & TASK DOCUMENTATION".

Sections:
1. What: Task description.
2. Why: Rationale and technical justification.
3. Advantages: Gains in performance, quality, etc.
4. Disadvantages: Trade-offs and risks.

Variables: {{mission_name}}
```

---

## 📊 Summary

| Category | Count |
|----------|-------|
| A — Architecture | 6 |
| B — State Management | 8 |
| C — Networking | 12 |
| D — Data Models | 6 |
| E — Navigation | 6 |
| F — Security | 9 |
| G — UI & Presentation | 13 |
| H — Dependency Injection | 6 |
| I — Logging & Monitoring | 5 |
| J — Testing | 7 |
| K — Performance | 7 |
| L — DevOps & Workflow | 10 |
| **TOTAL** | **95** |

---

## 🚀 How to Use This File

### To build a template, copy-paste this in a new conversation:

```
I want to build Mason template [CODE] from my template catalog.

Context:
- template location: d:\flutter\flutter_standard_library\Templates\templates\
- Follow rules from: @AI_INSTRUCTIONS.md
- Reference the template catalog for the prompt details

[PASTE THE template'S PROMPT SECTION HERE]
```

### Recommended build order (dependencies first):
1. **Core:** A3 → C1 → C3 → H1 → H2 → I1 → K3 → K4 → G5 → G7 → G10
2. **Features:** A1 → A2 → B1 → C2 → C4 → D2 → D3 → G1
3. **Extended:** B2→G2, B3→G3, C6, E1→E2, F1→F2
4. **Advanced:** Everything else based on project needs
