# Location Manager Feature - Comprehensive Testing Plan

This document outlines the testing strategy for the Location Manager feature, covering logic, UI, and end-to-end flows.

## 1. Unit Tests (Business Logic & Data)

### A. Data Sources & Models
#### **LocationLocalDataSourceImpl**
*   **Scenario:** Verify platform-specific behavior for settings.
    *   **Input/Action:** Call `openLocationSettings()` on Web platform.
    *   **Expected Result:** Returns `false` without calling Geolocator.
*   **Scenario:** Verify location permission check.
    *   **Input/Action:** Call `hasPermission()` when `IAppPermissionsManager` returns true.
    *   **Expected Result:** Returns `true`.
*   **Scenario:** Verify `getLastKnownPosition` safety on Web.
    *   **Input/Action:** Call `getLastKnownPosition()` on Web.
    *   **Expected Result:** Returns `null` immediately.

#### **LocationRemoteDataSourceImpl**
*   **Scenario:** Mobile Geocoding Success.
    *   **Input/Action:** `placemarkFromCoordinates` returns a valid list.
    *   **Expected Result:** Returns formatted string "City, Country".
*   **Scenario:** Mobile Geocoding Retry Logic.
    *   **Input/Action:** First call to `placemarkFromCoordinates` throws `IO_ERROR`, second call succeeds.
    *   **Expected Result:** Method retries after delay and returns success.
*   **Scenario:** Web Geocoding (Nominatim).
    *   **Input/Action:** `LocationApiClient.getCityAndCountryWeb` returns valid model.
    *   **Expected Result:** Returns formatted string using `effectiveCity`.

#### **NominatimResponseModel**
*   **Scenario:** Serialization from JSON.
    *   **Input/Action:** Provide JSON with varying address fields (city vs town vs suburb).
    *   **Expected Result:** `effectiveCity` correctly prioritizes fields according to logic.

### B. Repositories
#### **LocationRepoImpl**
*   **Scenario:** Save Current Position Flow.
    *   **Input/Action:** Call `saveCurrentPosition()` where `getLastKnownPosition` is null but `getCurrentPosition` succeeds.
    *   **Expected Result:** Lat/Lng saved to `sharedPref`, `locationName` removed, returns `ApiResult.success(true)`.
*   **Scenario:** Handle Permission Denied Exception.
    *   **Input/Action:** Data source throws `PermissionDeniedException` during `saveCurrentPosition`.
    *   **Expected Result:** Returns `ApiResult.failure` with `Failure.location`.

### C. State Management (Cubits)
#### **LocationCubit**
*   **Scenario:** Initial state based on storage.
    *   **Input/Action:** Instantiate Cubit when `hasStoredLocation()` is true.
    *   **Expected Result:** State is `LocationSuccess`.
*   **Scenario:** Permission escalation.
    *   **Input/Action:** `requestLocationPermission()` returns `denied` twice.
    *   **Expected Result:** Emits `LocationNeedsPermission` first, then `LocationPermissionPermanentlyDenied` on second fail.
*   **Scenario:** Enforce Location - Service Disabled.
    *   **Input/Action:** `isLocationEnabled()` returns false.
    *   **Expected Result:** Emits `[LocationLoading, LocationNeedsServiceEnable]`.

#### **LocationNameCubit**
*   **Scenario:** Dependency on LocationCubit.
    *   **Input/Action:** `LocationCubit` emits `LocationSuccess`.
    *   **Expected Result:** `LocationNameCubit` triggers `loadLocation`.
*   **Scenario:** Retry delay for storage.
    *   **Input/Action:** `loadLocation` called when storage is initially empty but filled after 500ms.
    *   **Expected Result:** Waits for `_kLocationCheckRetryDelay`, finds coordinates, and fetches name.

---

## 2. Widget Tests (UI & Interaction)

### **LocationGuard Widget**
*   **Scenario:** Visibility of child.
    *   **Input/Action:** State is `LocationSuccess`.
    *   **Expected Result:** `child` widget is visible and `Skeletonizer` is inactive.
*   **Scenario:** Loading state.
    *   **Input/Action:** State is `LocationLoading`.
    *   **Expected Result:** `loadingPlaceholder` is shown or `Skeletonizer` is active.
*   **Scenario:** Bottom Sheet - Service Enable.
    *   **Input/Action:** State changes to `LocationNeedsServiceEnable`.
    *   **Expected Result:** `showCustomBottomSheet` called with "Enable Location Service" title.
*   **Scenario:** User Interaction - Manual Choice.
    *   **Input/Action:** Tap "Choose Country" on any guard bottom sheet.
    *   **Expected Result:** Current bottom sheet closes, and `_showCountryPicker` is called (ListView of countries appears).
*   **Scenario:** Manual Selection.
    *   **Input/Action:** Tap "Egypt" in Country Picker.
    *   **Expected Result:** Bottom sheet closes, `LocationCubit.saveManualLocation` called with Egypt's coordinates.
*   **Scenario:** Permanent Denial UI.
    *   **Input/Action:** State is `LocationPermissionPermanentlyDenied`.
    *   **Expected Result:** Bottom sheet shows "Open App Settings" button.
*   **Scenario:** Lifecycle Resumption.
    *   **Input/Action:** Trigger `AppLifecycleState.resumed`.
    *   **Expected Result:** `LocationCubit.enforceLocation` is triggered if no location is stored.

---

## 3. Integration Tests (End-to-End Flow)

### **Scenario: The "Happy Path" (GPS)**
1.  **Action:** User opens a feature wrapped in `LocationGuard`.
2.  **Action:** System detects GPS is off -> Bottom sheet "Enable Service" appears.
3.  **Action:** User taps "Enable" -> (Mock) System settings open -> User enables GPS.
4.  **Action:** User returns to app -> Lifecycle resume triggers check.
5.  **Action:** System detects permission missing -> Bottom sheet "Allow Location" appears.
6.  **Action:** User taps "Allow" -> System permission dialog -> User grants permission.
7.  **Expected Result:** Guard removes overlay, saves position, fetches "Cairo, Egypt", and displays the main feature UI.

### **Scenario: The "Manual Path"**
1.  **Action:** User opens feature -> `LocationShowChoiceSheet` emitted.
2.  **Action:** User taps "Choose Country".
3.  **Action:** User selects "Saudi Arabia" from list.
4.  **Expected Result:** Overlay disappears, app uses fixed coordinates for Saudi Arabia, and continues to main UI.

### **Scenario: Persistent Rejection**
1.  **Action:** User denies permission twice.
2.  **Expected Result:** Guard displays "Permanently Denied" message with "Open Settings" and "Choose Country" options.
3.  **Action:** User closes bottom sheet (if dismissible).
4.  **Expected Result:** Navigator pops (closes screen) if `showCancelButton` is true.

### **Scenario: Connectivity Failure**
1.  **Action:** GPS/Permission granted, but network fails during geocoding.
2.  **Expected Result:** `LocationNameCubit` emits `LocationNameError`.
3.  **Action:** User taps "Try Again".
4.  **Expected Result:** System re-attempts reverse geocoding.
