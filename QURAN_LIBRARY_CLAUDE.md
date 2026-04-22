# Technical Documentation: `quran_library` v3.2.0

Comprehensive architectural mapping and implementation reference for the `quran_library` package within the "Muslim App" ecosystem.

## 🏗 Architecture Overview

The library follows a **Monolithic Library** pattern using Dart's `part` and `part of` directives, grouped under a single entry point `lib/quran.dart`. This allows all internal files to share a private scope while exposing a unified API through `QuranLibrary`.

### Key Architectural Pillars:
1.  **State Management**: Powered exclusively by `GetX`. Controllers are persistent singletons (`permanent: true`).
2.  **Data Persistence**: Uses `GetStorage` for local settings, bookmarks, and configuration.
3.  **Rendering Engine**: Implements a custom renderer for **QPC V4** fonts, handling line-by-line and word-by-word layout from JSON data.
4.  **Asynchronous Data Loading**: Core Quran data is stored in compressed `.gz` JSON files in assets, loaded and decompressed at runtime.

---

## 📂 Directory Structure

```text
lib/
├── quran.dart                  # Main Entry Point (Exports all components)
├── src/
│   ├── flutter_quran_utils.dart # Public API (QuranLibrary class)
│   ├── audio/                  # Audio handling (Recitations, Word-by-word)
│   │   ├── controller/         # AudioCtrl (JustAudio & AudioService integration)
│   │   └── ui/                 # Audio players and download managers
│   ├── quran/                  # Core Quran logic
│   │   ├── data/
│   │   │   ├── models/         # AyahModel, SurahModel
│   │   │   ├── qpc_v4/         # QPC V4 Page Renderer and Assets Store
│   │   │   └── repositories/   # QuranRepository (Gzip JSON loader)
│   │   └── presentation/
│   │       ├── controllers/    # QuranCtrl (Core State), BookmarksCtrl
│   │       └── widgets/        # QuranScreen, Ayah widgets, Surah headers
│   ├── tafsir/                 # Tafsir & Translations
│   │   ├── controller/         # TafsirCtrl (Dio downloads, SQL/JSON handling)
│   │   └── model/              # TafsirNameModel, TranslationModel
│   └── word_info/              # Word-by-word analysis (Eerab, Tasreef)
└── assets/                     # Compressed data, Fonts, Images
```

---

## 🖼 Key UI Components

The library provides several pre-built widgets that can be used directly:

*   **`QuranLibraryScreen`**: The main full-screen Quran viewer.
*   **`SurahHeaderWidget`**: Renders the artistic Surah name and header.
*   **`AyahMenuDialog`**: The interactive menu that appears when clicking an Ayah (Tafsir, Play, Bookmark).
*   **`FontsDownloadWidget`**: A UI for managing compressed font assets (V4).
*   **`TafsirWidget`**: The bottom sheet for displaying Tafsir/Translation content.
*   **`WordInfoBottomSheet`**: Detailed word-by-word analysis UI.


---

## 🚀 Core Controllers (State Management)

### `QuranCtrl` (Central Nervous System)
*   **Path**: `lib/src/quran/presentation/controllers/quran/quran_ctrl.dart`
*   **Role**: Manages the reactive state of the Quran (page number, selection, font settings, loading status).
*   **Key State**: `currentPageNumber`, `isQuranLoaded`, `isFontDownloaded`, `selectedAyahsUQNumbers`.
*   **Methods**: `loadQuranDataV3()`, `jumpToPage()`, `search()`, `toggleAyahSelection()`.

### `AudioCtrl` (Multimedia Engine)
*   **Path**: `lib/src/audio/controller/audio_ctrl.dart`
*   **Role**: Orchestrates recitation playback using `just_audio` and `audio_service` for background control.
*   **Workflow**: Checks for local file -> Downloads if missing -> Plays via `AudioSource`.
*   **Important**: Requires `MainActivity` to extend `AudioServiceActivity` on Android.

### `TafsirCtrl` (Content Manager)
*   **Path**: `lib/src/tafsir/controller/tafsir_ctrl.dart`
*   **Role**: Manages downloading and fetching Tafsir/Translation data.
*   **Logic**: Handles high-volume data requests and local caching to prevent UI blocking.

### `BookmarksCtrl` (User Personalization)
*   **Path**: `lib/src/quran/presentation/controllers/bookmark/bookmarks_ctrl.dart`
*   **Role**: Manages categorized bookmarks (last read, favorites) using `GetStorage`.

---

## 💾 Data Layer & Persistence

### Data Source
*   **Asset Pattern**: `assets/json/*.json.gz`
*   **Service**: `GzipJsonAssetService` decompresses data on the fly.
*   **Structure**: `QuranRepository` abstracts this, providing clean access to `Surah` and `Ayah` models.

### Local Storage (`GetStorage`)
*   **Settings**: Stores `isBold`, `fontScale`, `isNightMode`, `lastPage`.
*   **Cache**: Used to store download status of Tafsir and Recitations.

---

## 🎨 Rendering Logic (QPC V4)

The library uses `QpcV4PageRenderer` to build Quran pages.
*   **Input**: JSON containing word glyphs, line types, and surah/ayah associations.
*   **Logic**:
    1.  Resolves Ayah Unique Numbers.
    2.  Handles special line types: `surahName`, `basmallah`, `ayah`.
    3.  Inserts `\u202F` (Narrow No-Break Space) between words for precise layout control.
    4.  Builds `QpcV4RenderBlock` list for the `QuranScreen`.

---

## 🛠 Engineering Standards (Do's and Don'ts)

### ✅ Do's
*   **Initialization**: Always call `await QuranLibrary.init()` in `main()`.
*   **State Access**: Use `QuranCtrl.instance` to read/modify Quran state from outside the package.
*   **Data Safety**: Wrap search queries in `normalizeText` (from the library) to ensure correct Arabic matching.
*   **Audio**: Ensure `AudioCtrl.instance` is used for all recitation controls to maintain background service sync.

### ❌ Don'ts
*   **Direct Modification**: Never edit files in `pub_cache`. Use the `QuranLibrary` public API.
*   **State Duplication**: Do not create local controllers for Quran state; always use the library's provided singletons.
*   **Blocking Main Thread**: Avoid heavy JSON parsing on the main thread; the library already offloads most tasks.

---

## 🔍 Key Workflows

### Initializing the Library
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await QuranLibrary.init(); // Essential: Bootstraps all controllers
  runApp(MyApp());
}
```

### Navigating to a Specific Ayah
```dart
QuranLibrary().jumpToAyah(pageNumber, ayahUniqueNumber);
```

### Integrated Search
```dart
List<AyahModel> results = QuranLibrary().search("صراط الذين");
```

---

## 🛑 Known Constraints & Tips
*   **Fonts**: QPC V4 fonts are bundled. If characters don't appear, check `pubspec.yaml` font declarations in the main app.
*   **Windows Support**: Requires `JustAudioMediaKit` for audio playback.
*   **Web**: local file downloads are bypassed; streaming is used directly from CDNs.
