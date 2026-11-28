# Spec: Location

> **Status:** In progress
> **Created:** 2026-11-28
> **Note:** This is a shared service, not a user-facing feature. The Qibla feature and future prayer-time features must use this service instead of implementing their own location access. Requirements start unchecked until the service is extracted and verified.

## Goal
Pending: proposed wording, awaiting developer confirmation.

---

## Part 1: Permission flow

- [ ] Before requesting location permission, the app shows a short screen that explains why it is needed and what the user must do.
- [ ] When permission is denied, the app shows clear steps and offers a button that opens the system settings.
- [ ] The permission flow follows the same pattern already used by the Qibla feature.
- [ ] The app checks permission status before every location request.
- [ ] The app rechecks permission automatically when the user returns from system settings.

---

## Part 2: Fresh location

- [ ] Every location request returns the device's current GPS location.
- [ ] The service never returns a previously saved location to a consumer.
- [ ] The service does not store the user's location.
- [ ] Each result includes latitude, longitude, heading when available, and the time it was taken.
- [ ] The service reports a failure when the device location cannot be determined.
- [ ] The service reports a failure when location services are turned off.
- [ ] Errors travel to the consumer as a typed result, not a raw exception.

---

## Part 3: Consumption by features

- [ ] The Qibla feature obtains its location through this shared service.
- [ ] The Qibla feature requests a fresh location every time its screen opens.
- [ ] Future prayer-time features can obtain a current location through the same service.
- [ ] Consumers do not access the location plugin directly.

---

## Part 4: Quality assurance

- [ ] Verify that every location service file has complete unit and widget test coverage.
- [ ] A full integration test suite covers permission, success, denial, service-off and no-fix flows.
- [ ] Verify the service on a real device after the extraction from Qibla.
- [ ] Verify that Qibla still recalculates direction on a fresh location each time it opens.
- [ ] Capture screenshots for every permission state, store them under `screenshots/location/`, and reference them in the root `README.md` and `docs/features/location/README.md`.
- [ ] Review all related docs and READMEs before closing the service.

---

## Out of Scope

Decided by the developer; not part of this spec for now.

- A saved or manually entered location.
- Continuous background location tracking.
- Geocoding or address lookup.
- A map view.

## Open Questions

None. The extraction keeps the behavior already implemented and verified in Qibla.
