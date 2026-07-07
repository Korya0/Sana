# F05 — Task Breakdown

# Phase 1 — Project Setup

[x] T001 Create feature folder structure (`lib/features/azkar/data/`, `lib/features/azkar/domain/`, `lib/features/azkar/presentation/`).
[x] T002 Add route definitions for categories screen and list screen in `core/routing/app_router.dart`.
[x] T003 Register all Azkar assets (`version.json`, `categories.json`, and category JSON files) in `pubspec.yaml`.

✅ Milestone: Feature folders, routes, and assets are initialized and ready for development.

----------------------------

# Phase 2 — Domain

[x] T004 Create `CategoryEntity` and `ZikrEntity` classes in `lib/features/azkar/domain/entities/`.
[x] T005 Create `IAzkarRepository` abstract interface containing signature definitions for `getCategories()` and `getAzkarByCategory()`.
[x] T006 Create `GetCategoriesUseCase` and `GetAzkarByCategoryUseCase` implementing the `call()` execution logic.

✅ Milestone: Domain layer is established with Entities, Repository interface, and UseCases without external dependencies.

----------------------------

# Phase 3 — Data

[x] T007 Create `CategoryModel` with JSON parsing (`fromJson()`) and entity mapping (`toEntity()`).
[x] T008 Create `ZikrModel` with JSON parsing (`fromJson()`) and entity mapping (`toEntity()`).
[x] T009 Create `IAzkarLocalDataSource` interface and the skeleton of `AzkarLocalDataSourceImpl` with required box references.
[x] T010 Implement version checking logic (`ensureDatabaseReady()`) comparing asset version with metadata box version.
[x] T011 Implement loading, parsing, validating (logging skips via `AppLogger`), and saving `categories.json` into `categories_box`.
[x] T012 Implement loading, parsing, validating, and saving category-specific JSON files into dynamic Hive boxes based on category ID.
[x] T013 Implement local reader methods inside `AzkarLocalDataSourceImpl` for reading categories and category-specific azkar lists.
[x] T014 Create `AzkarRepositoryImpl`, implement repository methods, map models to entities, wrap responses with `Result`, and log failures using `AppLogger`.
[x] T014a Refactor hardcoded strings (box names, json keys) to `static const` variables in the Data layer and move asset paths to `AppAssets`.

✅ Milestone: Data layer fully supports offline-first JSON parsing, Hive CE caching, and versioning with Result pattern and logging.

----------------------------

# Phase 4 — Presentation

[x] T015 Create `AzkarCategoriesState` sealed classes and `AzkarCategoriesCubit` managing category loading states (Initial, Loading, Loaded, Empty, Error).
[x] T016 Create sealed classes for `AzkarState` representing Initial, Loading, Loaded (carrying lists, counter values, scroll target index), Empty, and Error.
[x] T017 Implement `AzkarCubit` including loading azkar, counter management, completion tracking, and auto-scroll state emission.

✅ Milestone: Presentation logic and state updates (categories list, counters, and scroll emission) are fully modeled and isolated.

----------------------------

# Phase 5 — Dependency Injection

[x] T018 Register `IAzkarLocalDataSource`, `IAzkarRepository`, and UseCases in `core/di/features_di.dart`.
[x] T019 Register `AzkarCategoriesCubit` and `AzkarCubit` as factory components in `core/di/features_di.dart`.

✅ Milestone: Dependency Injection container configured and validated for feature execution.

----------------------------

# Phase 6 — UI

[x] T020 Create `CategoryIconMapper` utility in `lib/features/azkar/presentation/widgets/category_icon_mapper.dart` to map category IDs to SVG assets.
[x] T021 Create `EmptyStateWidget`, `LoadingStateWidget` (Skeleton/Shimmer widget), and `ErrorStateWidget` with retry callbacks for categories and azkar list.
[x] T022 Build `AzkarCategoriesScreen` incorporating AppBar, grid layout, BlocBuilder, and empty/error states.
[x] T023 Create `CategoryCardWidget` utilizing `CategoryIconMapper` to display individual categories.
[x] T024 Copy the existing list views (`azkar_list_view.dart`, `azkar_details_loader_view.dart`) from `D:\flutter\flutter_Projects\azkar\presentation\views` to `lib/features/azkar/presentation/views/` and adapt them into `AzkarListScreen` using the new `AzkarCubit` state management and routing.
[x] T025 Copy the existing widgets (`azkar_list_content.dart`, `zikr_item_card.dart`, `share_card/`, `zikr_card/`) from `D:\flutter\flutter_Projects\azkar\presentation\widgets` to `lib/features/azkar/presentation/widgets/` and adapt them to the new `ZikrEntity` and UI requirements (counter interaction, completed state, share, and copy actions).
[x] T026 Implement BlocListener in the adapted list screen to catch auto-scroll signals and execute `Scrollable.ensureVisible()`.
[x] T027 Implement exit confirmation flow using PopScope and ExitConfirmationDialog when unfinished azkar exist in the adapted views.

✅ Milestone: The UI is fully functional, visually responsive, and connected to the presentation layer without containing business logic, leveraging the existing UI code from the old project.

----------------------------

# Phase 7 — Polish

[x] T028 Verify structural compliance of folders and run `dart format lib` to format codebase.
[x] T029 Run `dart fix --apply` and resolve remaining warnings after `flutter analyze`.
[x] T030 Clean up dead code, unused imports, and residual TODO/FIXME comments.

✅ Milestone: The feature is clean, optimal, well-formatted, and completely complies with compiler and analyzer guidelines.
----------------------------

# Phase 8 — Integration & Customization (New Tasks)

- [x] T031 [US1] Update `CategoryIconMapper` in `lib/features/azkar/presentation/widgets/category_icon_mapper.dart` to return `IconData` and map the 23 categories to Islamic, Solar, and Cupertino icons.
- [x] T032 [P] [US1] Delete the unused SVG category card widget `lib/features/azkar/presentation/widgets/category_card.dart` and `azkar_categories_grid.dart`.
- [x] T033 [US1] Implement `HomeAzkarCategoriesSection` in `lib/features/home/presentation/widgets/sections/home_azkar_categories_section.dart` to display all 23 categories in a circular category grid section using `FeatureCircularCard`.
- [x] T034 [US1] Add and register `AzkarCategoriesCubit` inside `home_view.dart`'s MultiBlocProvider, and inject the `HomeAzkarCategoriesSection` below the `HomeDailyWisdomSection`.
- [x] T035 [US1] Modify route mapping in `lib/core/routing/app_router.dart` and `app_routes.dart` to remove the route configuration for the deleted `AzkarCategoriesView`.
- [x] T036 [P] [US1] Delete the unused categories view screen file `lib/features/azkar/presentation/views/azkar_categories_view.dart`.
- [x] T037 [US2] Modify `AzkarListView` in `lib/features/azkar/presentation/views/azkar_list_view.dart` to check if all azkar are finished, wait 500ms, and then pop the screen automatically.
- [x] T038 [US2] Run `flutter analyze` and `dart format` to verify build and code quality of the new integration.

✅ Milestone: Azkar categories are fully integrated into the home screen with mapped icons, and completing all Azkar in a category pops the screen automatically.

----------------------------

### Summary

- **Total number of tasks**: 38
- **Phase execution order**: Phase 1 -> Phase 2 -> Phase 3 -> Phase 4 -> Phase 5 -> Phase 6 -> Phase 7 -> Phase 8.
- **Critical dependencies**:
  - Phase 8 depends on all core Azkar functionality being ready (Phase 6 UI completed).
  - T033 and T034 depend on mapping updates in T031.
  - T037 is a self-contained modification of the list view.
- **Tasks that can run in parallel**:
  - Deleting unused files (T032, T036) can run in parallel with mapping updates (T031).
  - Implementation of auto-pop (T037) can run in parallel with the home UI integration.
- **Recommended Git commit strategy**: Commit per logical task. Each task represents a clean, logical progress point.
