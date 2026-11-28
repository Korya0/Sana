# Spec: Location

> **Status:** Production (confirmed 2026-11-28)
> **Created:** 2026-11-28
> **Note:** This is a shared service, not a user-facing feature. The Qibla feature and future prayer-time features must use this service instead of implementing their own location access. Approved by the developer on 2026-11-28 after testing on a real device (`SM A226B`); 836 unit/widget tests and 11 integration tests passed.

## Goal
Pending: proposed wording, awaiting developer confirmation.

---

## Part 1: Permission flow

- [x] Before requesting location permission, the app shows a short screen that explains why it is needed and what the user must do.
- [x] When permission is denied, the app shows clear steps and offers a button that opens the system settings.
- [x] The permission flow follows the same pattern already used by the Qibla feature.
- [x] The app checks permission status before every location request.
- [x] The app rechecks permission automatically when the user returns from system settings.

---

## Part 2: Fresh location

- [x] Every location request returns the device's current GPS location.
- [x] The service never returns a previously saved location to a consumer.
- [x] The service does not store the user's location.
- [x] Each result includes latitude, longitude, heading when available, and the time it was taken.
- [x] The service reports a failure when the device location cannot be determined.
- [x] The service reports a failure when location services are turned off.
- [x] Errors travel to the consumer as a typed result, not a raw exception.

---

## Part 3: Consumption by features

- [x] The Qibla feature obtains its location through this shared service.
- [x] The Qibla feature requests a fresh location every time its screen opens.
- [x] Future prayer-time features can obtain a current location through the same service.
- [x] Consumers do not access the location plugin directly.

---

## Part 4: Quality assurance

- [x] Verify that every location service file has complete unit and widget test coverage.
- [x] A full integration test suite covers permission, success, denial, service-off and no-fix flows.
- [x] Verify the service on a real device after the extraction from Qibla.
- [x] Verify that Qibla still recalculates direction on a fresh location each time it opens.
- [x] No new screenshots are captured because the permission screens are unchanged; the existing Qibla permission-state screenshots under `screenshots/qibla/` are referenced from `docs/features/location/README.md` instead.
- [x] Review all related docs and READMEs before closing the service.

---

## Out of Scope

Decided by the developer; not part of this spec for now.

- A saved or manually entered location.
- Continuous background location tracking.
- Geocoding or address lookup.
- A map view.

## Open Questions

None. The extraction keeps the behavior already implemented and verified in Qibla.
