<div align="center">

<!-- Badges at Top -->
<p>
  <a href="https://github.com/Korya0/Sana/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/Korya0/Sana" alt="contributors" />
  </a>
  <a href="https://github.com/Korya0/Sana/commits/master">
    <img src="https://img.shields.io/github/last-commit/Korya0/Sana" alt="last update" />
  </a>
  <a href="https://github.com/Korya0/Sana/network/members">
    <img src="https://img.shields.io/github/forks/Korya0/Sana" alt="forks" />
  </a>
  <a href="https://github.com/Korya0/Sana/stargazers">
    <img src="https://img.shields.io/github/stars/Korya0/Sana" alt="stars" />
  </a>
  <a href="https://github.com/Korya0/Sana/issues/">
    <img src="https://img.shields.io/github/issues/Korya0/Sana" alt="open issues" />
  </a>
  <a href="https://github.com/Korya0/Sana/blob/master/LICENSE">
    <img src="https://img.shields.io/github/license/Korya0/Sana" alt="license" />
  </a>
</p>

<!-- Typing Logo (English Style) -->
<img src="https://readme-typing-svg.herokuapp.com/?font=Almarai&weight=800&size=50&center=true&vCenter=true&width=500&height=100&duration=4000&lines=%D8%B3%D9%8E%D9%80%D9%86%D9%8E%D9%80%D8%A7"/>

<!-- Subtitle -->
<h3>A simple and clear modern Islamic companion.</h3>

<!-- Links Section -->
<p>
<a href="https://sana0.vercel.app/">
  <img src="https://img.shields.io/badge/🌐_Website-D4AF37?style=for-the-badge" alt="Website"/>
</a>
<a href="https://play.google.com/store/apps/details?id=com.sana.muslim.app">
  <img src="https://img.shields.io/badge/📱_Google_Play-00C853?style=for-the-badge" alt="Google Play"/>
</a>
<a href="https://www.linkedin.com/in/mahmoud-mohamed-5938ab28a/">
  <img src="https://img.shields.io/badge/💬_LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"/>
</a>
<a href="https://www.facebook.com/profile.php?id=61585568923187">
  <img src="https://img.shields.io/badge/📘_Facebook-1877F2?style=for-the-badge" alt="Facebook"/>
</a>
</p>

</div>

---

## 🕌 Key Features

- **🕐 Smart Prayer Times**: Accurate calculations, countdowns, Sunnah times, and religious events.
- **📖 Quran Reader**: Full Quran with Tafsir, audio recitations, and advanced bookmarking.
- **📿 Dhikr & Azkar**: Interactive counters, haptic feedback, and a wide collection of authentic supplications.
- **🧭 Qibla Compass**: Sensor-based precision compass with distance to Kaaba.
- **☀️ Daily Content**: Rotating Hadith, abandoned Sunnahs, and Names of Allah.
- **🔍 Hadith Search**: Search thousands of authentic Hadiths via Dorar Encyclopedia.
- **📱 Salat ala Nabi**: Background audio and notification reminders for praying upon the Prophet ﷺ.
- **🎓 Teaching Prayer**: Visual and textual step-by-step guidance for prayer.

---

## 🧩 Feature Modules & Architecture

<details>
<summary><b>🔄 App Update</b></summary>
<br>

Ensures users are running the latest version using **Firebase Remote Config**.
- **Features**: 
  - **Force Update**: Prevents app access for outdated versions.
  - **Optional Update**: Non-intrusive banner for new updates.
  - **Caching**: Remembers update status for offline startup.
- **Tech Details**: SOLID implementation using `VersionUtils` for comparison and `AppUpdateCubit` for UI state.
- **DI Components**: 
  - `IAppUpdateRepository` (LazySingleton)
  - `AppUpdateCubit` (LazySingleton)
</details>

<details>
<summary><b>🤲 Asma ul Husna</b></summary>
<br>

Displays the 99 Names of Allah with meanings and sharing capabilities.
- **Features**: 
  - Animated list with expandable meanings.
  - Share any name as a beautiful image.
  - "Name of the Day" integration on the home screen.
- **Tech Details**: Uses `Animated Sliver List` and `Skeletonizer` for premium loading.
- **DI Components**: 
  - `IAsmaUlHusnaRepository` (LazySingleton) - Handles JSON loading and caching.
  - `AsmaUlHusnaCubit` (Factory) - UI state management.
</details>

<details>
<summary><b>📿 Azkar Collection</b></summary>
<br>

Comprehensive interactive Dhikr experience.
- **Features**: 
  - 23+ categories (Morning, Evening, etc.) sorted by priority.
  - Interactive counter with haptic feedback and "Optimistic Scroll".
  - Exit confirmation for unfinished progress.
- **Tech Details**: Multi-Cubit architecture for categories and active list progress.
- **DI Components**: 
  - `IAzkarRepository` (LazySingleton)
  - `AzkarCategoriesCubit` (Factory)
  - `AzkarListCubit` (Local Provider)
</details>

<details>
<summary><b>☀️ Daily Content (Anwar el Youm)</b></summary>
<br>

The central engine for daily rotating Islamic content.
- **Features**: 
  - Randomized Hadith, Sunnah, and Names of Allah.
  - Smart rotation logic tied to `AppDateCubit` (midnight updates).
  - Favorites system for saving daily gems.
- **Tech Details**: Listens to date streams to trigger daily resets.
- **DI Components**: 
  - `IDailyContentRepository` (LazySingleton)
  - `DailyContentCubit` (LazySingleton)
</details>

<details>
<summary><b>🔍 Hadith Search</b></summary>
<br>

Advanced search engine for Prophetic Hadiths.
- **Features**: 
  - Integration with Dorar Encyclopedia API.
  - Infinite scrolling (Pagination) for large result sets.
  - Intelligent result coloring based on Hadith authenticity.
- **Tech Details**: Full **Clean Architecture** implementation (Entities, UseCases, Repositories).
- **DI Components**: 
  - `IHadithRepository` (LazySingleton)
  - `IHadithFavoritesRepository` (LazySingleton)
  - `HadithSearchCubit` (Factory)
  - `HadithFavoritesCubit` (Factory)
</details>

<details>
<summary><b>📍 Location Manager</b></summary>
<br>

The backbone for all location-aware features (Prayer Times, Qibla).
- **Features**: 
  - Automated GPS permission handling and service status checks.
  - `LocationGuard` wrapper for protecting location-dependent screens.
  - Geocoding for city/country name resolution.
- **Tech Details**: Uses `Geolocator` and `LifecycleObserver` for real-time updates.
- **DI Components**: 
  - `ILocationRepository` (LazySingleton)
  - `LocationCubit` (LazySingleton)
  - `LocationNameCubit` (LazySingleton)
</details>

<details>
<summary><b>🕋 Prayer Times</b></summary>
<br>

Precision prayer scheduling and tracking.
- **Features**: 
  - Astronomical calculations using the `Adhan` engine.
  - Countdown timer for the next prayer.
  - Sunnah times (Midnight, Last Third) and religious event alerts.
- **Tech Details**: Real-time updates via `Timer` scheduled exactly at prayer transitions.
- **DI Components**: 
  - `IPrayerRepository` (LazySingleton)
  - `PrayerTimesCubit` (LazySingleton)
</details>

<details>
<summary><b>🧭 Qibla Compass</b></summary>
<br>

Interactive tool for finding the direction of the Kaaba.
- **Features**: 
  - Real-time compass using magnetometer sensors.
  - Distance calculation using the Haversine formula.
- **Tech Details**: Logic isolated in `QiblaService` for mathematical purity.
- **DI Components**: 
  - `IQiblaRepository` (LazySingleton)
  - `QiblaCubit` (Factory)
</details>

<details>
<summary><b>📿 Salat ala Nabi</b></summary>
<br>

Personalized reminders for praying upon the Prophet ﷺ.
- **Features**: 
  - Background audio and notification alerts.
  - Customizable intervals and "Silent Hours" management.
- **Tech Details**: Uses `Workmanager` for reliable background execution even if the app is closed.
- **DI Components**: 
  - `IReminderRepo` (LazySingleton)
  - `ReminderCubit` (LazySingleton)
</details>

<details>
<summary><b>🎓 Teaching Prayer</b></summary>
<br>

Step-by-step educational guide for Salah.
- **Features**: 
  - Organized modules for Wudu, Prayer steps, and Sunnan.
  - Expandable topics with sharing capabilities.
- **Tech Details**: Data driven via local JSON assets and `TeachingContentParser`.
- **DI Components**: 
  - `ITeachingPrayerRepository` (LazySingleton)
  - `TeachingPrayerCubit` (Factory)
</details>

<details>
<summary><b>🏠 Home (Dashboard)</b></summary>
<br>

The central hub of the application that orchestrates access to all features.
- **Features**: 
  - Dynamic platform-based feature filtering.
  - Modern UI with **Glassmorphism**, gold shadows, and press animations.
  - **Sliver-based** layout for maximum scroll performance.
- **Tech Details**: Uses a modular design where each feature is a self-contained card registered in `FeaturesRepository`.
- **DI Components**: 
  - `IFeaturesRepository` (LazySingleton)
  - `FeaturesListCubit` (Factory)
</details>

<details>
<summary><b>📖 Quran Library Wrapper</b></summary>
<br>

A clean wrapper for the `quran_library` engine, customized for the app's aesthetic.
- **Features**: 
  - Seamless integration of Surah/Juz browsing and Tafsir.
  - High-quality audio streaming from multiple reciters.
  - Specialized **Quran Dark Mode** (0xFF161a1d).
- **Tech Details**: Pure presentation wrapper with no state duplication.
</details>

<details>
<summary><b>🌟 Splash & Initialization</b></summary>
<br>

Handles the app's entry sequence and critical service checks.
- **Features**: 
  - Automated location status verification before home entry.
  - Beautiful fade-in logo animation.
- **Tech Details**: Delegates location enforcement to the `LocationGuard` logic.
</details>

<details>
<summary><b>🛠 Developer Dashboard & Feedback</b></summary>
<br>

Admin tools and user communication systems.
- **Features**: 
  - **Feedback**: Fire-and-forget submission with Firestore offline support and automatic device info collection.
  - **Dashboard**: Admin-only view to manage user reports with **Optimistic Updates** (UI updates before server confirmation).
- **Tech Details**: Firestore persistence ensures messages are sent even after app restarts.
- **DI Components**: 
  - `IFeedbackRepository` (LazySingleton)
  - `IDashboardRepository` (LazySingleton)
</details>

---

## 🛠️ Tech Stack

<hr style="height:1px;border:none;color:#333;background-color:#333;" />

- **Framework**: `Flutter` (Stable)
- **Language**: `Dart`
- **Native Bridges**: `Platform Channels`
- **Database**: `Hive` (High-speed local storage)
- **Cloud Interface**: `Firebase` (Analytics, Crashlytics, Remote Config)
- **Code Push**: `Shorebird` (Instant live updates)
- **State Management**: `Cubit (flutter_bloc)` with `Freezed` Sealed Classes

---

## 📸 Screenshots

<hr style="height:1px;border:none;color:#333;background-color:#333;" />

<div align="center">

| | | |
|:---:|:---:|:---:|
| <img src=".github/screenshots/Android Medium - 19 (1).png" width="180"/> | <img src=".github/screenshots/Android Medium - 19.png" width="180"/> | <img src=".github/screenshots/Android Medium - 14.png" width="180"/> |
| <img src=".github/screenshots/Group 1.png" width="180"/> | <img src=".github/screenshots/Group 2.png" width="180"/> | <img src=".github/screenshots/Group 3.png" width="180"/> |

</div>

<br/>

<div align="center">

<img src=".github/screenshots/Group 4.png" width="300"/> <img src=".github/screenshots/Group 5.png" width="300"/>

</div>

---

## 🚀 Getting Started

<hr style="height:1px;border:none;color:#333;background-color:#333;" />

1. **Clone the repository**
   ```bash
   git clone https://github.com/Korya0/Sana.git
   ```
2. **Setup dependencies**
   ```bash
   flutter pub get
   ```
3. **Run for Mobile**
   ```bash
   flutter run
   ```

---

## 🤝 Contributing

<hr style="height:1px;border:none;color:#333;background-color:#333;" />

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

<hr style="height:1px;border:none;color:#333;background-color:#333;" />

Distributed under the **MIT License**. See `LICENSE` for more information.

---

## 💖 Acknowledgments

<hr style="height:1px;border:none;color:#333;background-color:#333;" />

- [quran_library](https://pub.dev/packages/quran_library) for the robust Quranic engine (complete with audio, tafsir, and search).
- [Adhan](https://pub.dev/packages/adhan) for precise astronomical calculations.
- [Dorar Encyclopedia](https://dorar.net/) for the comprehensive Hadith API.
- To all supporters of Islamic open-source software! 🌛

---

<div align="center">
Developed with passion for the Ummah 🌙
<br/>
<b>© 2026 Sana Team</b>
</div>
