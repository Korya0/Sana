# 🗺️ PLUGIN: LOCATION & MAPS
> **Version:** 1.0.0 | **Author:** Antigravity (Senior Partner)
> **Target:** Robust GPS access without crashing, optimized Maps rendering.

## 🏛️ CORE PHILOSOPHY
Location APIs throw violent `ActivityNotFoundException` errors on Android if misused. Never request `Location` unless the user presses a specific button indicating they understand *why* the map needs to open.

---

## 🛠️ LOCATION PROTOCOL (geolocation)
- **Library:** Always use `geolocator` combined with `F9_Permissions_Handler`.
- **Power Usage:** Do NOT use `LocationAccuracy.best` for simple distance mathematical checks. Use `low` or `medium` to save battery. Use `best` ONLY for real-time turn-by-turn navigation apps.
- **Service Check:** **Always** check if the GPS itself is physically enabled first via `Geolocator.isLocationServiceEnabled()` before requesting the software permission.

## 🗺️ GOOGLE MAPS PROTOCOL
- **Library:** Use `google_maps_flutter` (official).
- **Security:** API keys MUST NOT be hardcoded in `.dart` files. Pass them via Dart Defines (`--dart-define`) or inject them directly into `AndroidManifest.xml` and `AppDelegate.swift` during CI/CD.
- **Memory Leak Warning:** `GoogleMapController` is extremely heavy. It **must** be stored in the State and actively `disposed` when the user leaves the screen.
- **Controller Access:** Pass the `GoogleMapController` to the Cubit if the UI needs to animate camera angles mathematically (e.g. `animateCamera(CameraUpdate.newLatLngZoom)`), but ensure the controller is nullified on UI dispose.
