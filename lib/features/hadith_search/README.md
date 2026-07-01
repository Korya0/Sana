# 🔍 Hadith Search Feature

The `hadith_search` module provides a comprehensive engine for searching Ahadith via the Dorar API, highlighting keywords, and saving them to local favorites. It is built strictly on Clean Architecture.

## 🏗️ Architecture

### 1. Domain Layer (`domain/`)
- **Entities**: `HadithEntity` contains the core properties with manual `==` and `hashCode` implemented, completely independent of JSON parsing.
- **Interfaces**: `IHadithRepository` and `IHadithFavoritesRepository` dictate the data contracts for fetching and saving Ahadith.

### 2. Data Layer (`data/`)
- **Models**: `HadithModel` extends `HadithEntity` to handle serialization/deserialization.
- **Repositories**: Both `HadithRepoImpl` and `HadithFavoritesRepoImpl` rely purely on Entity equality rather than manual string comparisons. They catch all errors properly (`Object catch`) and report unexpected ones to `AppLogger`.

### 3. Presentation Layer (`presentation/`)
- **Cubits**: 
  - `HadithSearchCubit` handles search debounce, pagination triggers, and formatting HTML highlights internally.
  - `HadithFavoritesCubit` handles optimistic updates for favorites and implements automatic rollback on failure. Constructor side-effects have been removed.
- **States**: Both Search and Favorite states have robust `==` and `hashCode` implementations using `collection`'s `ListEquality`.
- **Views**: 
  - `HadithSearchView` delegates scroll threshold logic directly to the Cubit.
  - UI depends strictly on `HadithEntity`, maintaining clean layer boundaries.
  - Clipboard sharing checks for `context.mounted` and displays safe user feedback toasts.

## 📦 Dependency Injection
- `di/hadith_search_di.dart`: Registers `DorarApiClient`, Repositories, and Cubits into the standard `GetIt` locator.
- `hadith_search.dart` (Barrel File): Exposes only what the rest of the application needs to see.
