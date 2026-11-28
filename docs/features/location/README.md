# Location

> **Last reviewed:** 2026-11-28
> **Status:** Stable
> **Approved:** Confirmed in production by the developer on 2026-11-28 after testing on `SM A226B`.

## Purpose & Scope

- **Goal:** Pending confirmation in `spec.md`.
- **Out of scope:** Saved or manual locations, continuous background tracking, geocoding and maps.

## Guidelines for consuming features

- The Qibla feature and future prayer-time features must use this service instead of calling the location plugin directly.
- Keep the permission flow already used by Qibla: check → explain → request → denied with steps and a settings button.
- Every request must return a fresh GPS reading. Do not cache or persist a location for consumers.
- Return a typed result with latitude, longitude, heading and timestamp; never leak a raw exception.
- Recheck permission when the app resumes or the user returns from settings.

## Decisions

### D-001: Shared location service extracted from Qibla
- **Decision:** Move location access out of the Qibla feature into a shared service that Qibla and future prayer-time features consume.
- **Reason:** Developer decision on 2026-11-28; location is needed by more than one feature. [Confirmed]
- **Rejected alternatives:** Duplicating the location repository in every feature that needs it.
- **Date:** 2026-11-28
- **Status:** Active

### D-002: Fresh location on every request
- **Decision:** Never return a stored location; fetch a new GPS reading each time a consumer asks.
- **Reason:** Developer decision on 2026-11-28; Qibla already behaves this way and prayer times need a current position. [Confirmed]
- **Rejected alternatives:** Caching the last known location and reusing it across sessions.
- **Date:** 2026-11-28
- **Status:** Active

### D-003: Keep the Qibla permission UX
- **Decision:** Reuse the Qibla check → rationale → request → denied-with-settings pattern for the shared service.
- **Reason:** The pattern is already organized and familiar to the developer. [Confirmed]
- **Rejected alternatives:** Showing the system prompt without an in-app explanation.
- **Date:** 2026-11-28
- **Status:** Active

## Verification

- Unit and widget tests cover the shared service, the Qibla data source delegation and the repository delegation.
- Integration tests cover the full Qibla flow and confirm that entering Qibla twice requests a fresh location each time.

## Notes

- No new screenshots were captured because the permission screens are unchanged; the existing Qibla screenshots are reused.
