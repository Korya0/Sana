# 🏢 PROJECT CONTEXT: سَـنَـا (Sana)

> **AI INSTRUCTION:** Read this for business logic and roadmap. Keep responses focused on these constraints.

---

## 📋 1. Business Context
- **Product Name:** Sana (سَـنَـا)
- **Goal:** High-performance, modern Islamic companion app with refined dark aesthetic (glassmorphism/gold).
- **Infrastructure:** Firebase (Firestore/Remote Config/Crashlytics), Shorebird (Code Push), Vercel (Web), Workmanager, Geolocator.
- **Localization:** Arabic RTL (Primary Priority)

## 🧩 2. Project-Specific Stack
- **State:** `flutter_bloc` (Cubit + Freezed Sealed Classes)
- **Networking:** `dio` + `retrofit`
- **Navigation:** `go_router`
- **DI:** `GetIt` (Constructor Injection enforced)
- **Local Storage:** `Hive` (via `ILocalStorageService`)

## 🧠 3. Domain Rules (Critical)
1. Clean Architecture (Feature-Based) is mandatory.
2. Every repository MUST return `ApiResult<T>` sealed class (Success/ApiFailure).
3. Zero `print()` calls — Use `AppLogger` for console and Crashlytics for production.
4. Logic/Data classes must use constructor injection; no `sl<T>()` inside them.
5. Hijri date adjustment is user-controlled via `AppDateCubit`.
6. Web version has specific restrictions (CORS proxy issues for Hadith search).

## ✅ 4. Roadmap & Status
- [x] Core Foundations (DI, Theme, Error Mapper, Routing)
- [x] Feature: Prayer Times & Real-time Countdown
- [x] Feature: Quran Reader (Uthmanic font)
- [x] Feature: Hadith Search (Dorar API + Inf. Scroll)
- [x] Feature: Azkar & Daily Content (Rotating Hadith/Sunnah)
- [x] Feature: Qibla Finder & Location Manager
- [x] Feature: Salat ala Nabi (Background Reminders)
- [x] Feature: App Update & In-app Feedback
- [x] Feature: Teaching Prayer Step-by-Step
