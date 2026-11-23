# Spec: Qibla

> **Status:** Production (confirmed 2026-11-23)
> **Created:** 2026-11-21
> **Revised:** 2026-11-23 — implementation verified on a real device (`SM A226B`) via 832 unit/widget tests and 10 integration tests; Qibla screenshots captured and referenced from both READMEs. Previously revised 2026-11-22 (alignment with the final implementation) and 2026-11-21 (after reviewing the interactive UI emulator with the developer).
> **Note:** Requirements were agreed section by section with the developer in chat on 2026-11-21, then ordered so that foundations come first (Part 1), then the Qibla screen (Part 2), then Quality assurance (Part 3). The additions the AI proposed to complete agreed behavior (loading state, permission and sensor failure messages, level/flat guidance) were approved by the developer on 2026-11-21. The revision of the same day reshaped the screens after the developer reviewed the emulator. Working fully offline is the top priority of this feature. On 2026-11-23 the developer confirmed the implemented behavior works correctly on a real device and approved closing the feature; status is `Production (confirmed 2026-11-23)`.

## Goal
Let users find the direction of the Qibla from their exact current location with a compass, fully offline and without an account, and know clearly when they are facing it.

---

## Part 1: Foundation (offline, location, and calculation)

### Offline
- [x] The Qibla feature works fully without an internet connection, with no download step after installing the app.
- [x] The screen does not show any offline notice or banner.

### Location & permission
- [x] Every time I open the Qibla screen, the app gets my exact current location using GPS and calculates the direction again.
- [x] The direction is calculated again when my location changes while the screen is open.
- [x] The app asks for location permission only when it is needed. Before the system prompt, a short screen tells me to tap the allow action and then choose "Allow while using the app" (a title and two short steps). I can leave with the app bar back button instead.
- [x] The location icon on the permission, denied, and failure screens is shown without a circle around it.

### Loading & location failure
- [x] While my location is being determined, the screen shows the Qibla screen itself as a skeleton: the same layout, sizes, spacing, and positions as the loaded screen, with placeholders in place of the content that changes. There is no separate loading screen.
- [x] When the location is determined, the skeleton is replaced directly by the loaded screen, with no success dialog or message.
- [x] If location permission is denied, the screen offers a button that opens the app's settings and shows short numbered steps for the path: open settings → permissions → location → allow → return. It automatically resumes when I return after granting permission, without an extra tap.
- [x] If the permission is granted but the location cannot be determined, the screen shows two numbered steps (enable Location from the notification shade and return, or open location settings, enable it, and return) and a button that opens the device's location settings. The direction is recalculated automatically when I return.

### Calculation & appearance
- [x] The Qibla direction is calculated on the device from my location to the Kaaba, for any place in the world.
- [x] The direction is measured from true north, not magnetic north.
- [x] The screen follows the app-wide day or night mode.

---

## Part 2: Qibla screen (compass and guidance)

### Direction information
- [x] The message card communicates the current action: turn right/left and the remaining angle, facing confirmation, low compass accuracy, or phone-level guidance.
- [x] Do not show a bottom details card, distance, Qibla bearing, phone heading, or a separate angular-difference readout — the top message card is the single place for all live guidance.

### Layout
- [x] The screen has two parts from top to bottom: a message card and the compass in the middle.
- [x] The message card keeps the same surface, background, and border in every state. Both the title and the message are unbounded, so the card height is driven entirely by the text and the guidance is never clipped. Its message content changes to tell me what to do now: which way to turn and how many degrees remain, facing confirmation, low accuracy, or hold-level guidance; its tone color distinguishes success (gold) from warning/error (red).

### Compass
- [x] A circular compass turns with the direction my phone is facing, with a fixed pointer at its top edge.
- [x] In night mode, the compass markings and center details are white in the normal state; on facing confirmation they turn yellow.
- [x] A Kaaba icon marks the Qibla direction on the compass rim, joined by a line to a very small circle at the center of the compass, instead of a plain arrow. The center shows no number.
- [x] The compass moves smoothly, without distracting jitter.

### Sensors and accuracy
- [x] If the compass sensor accuracy is low or there is magnetic interference, the message card says the compass accuracy is low and asks me to place the phone on a level surface away from metals so the reading is accurate. It is a message only — no calibration button or bottom sheet.
- [x] If the phone is not held level enough for a reliable reading, the message card asks me to place the phone on a level surface away from metals (for example AirPods).
- [x] The app checks that the device has a compass sensor when the Qibla screen is entered. If it has none, the screen shows the `unsupported` state with a message explaining that the device does not support the compass sensor, so the feature cannot be used.
- [x] If the Qibla screen is reached on a device with no compass sensor anyway, an error screen shows the same message. The screen does not show the Qibla direction in degrees in this case.

### Facing confirmation
- [x] When my phone points toward the Qibla within 6 degrees, compass details change to yellow; do not use a glow or bloom effect.
- [x] When my phone points toward the Qibla within 6 degrees, the message card shows the `AppStrings.qiblaFacing` confirmation message without changing its background, border, or surface style.

---

## Part 3: Quality assurance
- [x] Verify that every Qibla feature file has complete unit and widget test coverage.
- [x] A full integration test suite covers the complete Qibla feature flows.
- [x] Verify the accuracy of the Qibla direction and the distance against trusted reference values for several locations around the world.
- [x] Verify that the loading skeleton matches the loaded compass screen exactly in layout, sizes, and spacing.
- [x] Verify complete responsiveness across supported screen sizes, orientations, and text scaling for every Qibla screen and state, including dialogs and bottom sheets.
- [x] Verify complete animation and motion behavior, including the compass movement, the skeleton, and transitions, across every Qibla screen and state.
- [x] Capture screenshots for every Qibla screen and state, including dialogs and bottom sheets, covering all possible cases, and store them under `screenshots/qibla/` at the repository root.
- [x] Organize and reference the Qibla screenshots in the root `README.md` and `docs/features/qibla/README.md`.
- [x] Review all related docs and READMEs before closing the feature.

---

## Out of Scope
Decided by the developer; not part of this spec for now.
- Camera view with a Qibla arrow (augmented reality) (not now).
- Map with a line to the Kaaba (needs internet, which conflicts with the offline priority).
- Home-screen widget or quick shortcut for the Qibla (not now).
- Alternative direction formulas such as great circle versus rhumb line (not now).
- Vibration or sound when facing the Qibla (visual confirmation only).
- A bottom details card with distance, bearings, phone heading, or angular difference (removed; the top message card is sufficient).
- A saved or manually chosen location for the Qibla (the location is taken from GPS every time).
- Showing the name of my location (not needed).
- A settings screen for the Qibla.
- An offline notice or banner (the feature works offline, so no explanation is needed).
- A separate loading screen (the skeleton of the Qibla screen replaces it).
- A list of manual steps for enabling location permission (a button opens the settings instead).
- Showing the Qibla direction in degrees on devices with no compass sensor (the feature is not available there).
- The emulator test panel (scenario buttons, sensor sliders, city picker, display options) is a testing aid for the developer and is not part of the app.

## Open Questions — resolved at close (2026-11-23)
All four were assumptions proposed by the AI; on 2026-11-23 the developer approved the feature as implemented and these assumptions stood. They are kept as a historical record.
- **Location failure:** "location cannot be determined" = permission granted but GPS gives no fix (location service off or weak signal). The screen shows two steps and does not offer a manual location.
- **Kaaba icon:** `AppIcons.kaaba` (maps to `FlutterIslamicIcons.solidKaaba`) is the icon in use; no separate asset was supplied.
- **Sensor accuracy:** low accuracy = OS sensor accuracy status; magnetic interference is estimated when field strength leaves Earth's normal range. One "accuracy is low" message is shown without naming a cause.
- **Sensor check at entry:** the check lives in the Qibla screen's own `initialize()` — the screen shows the `unsupported` state on a device with no compass sensor. The Settings shortcut check is a known limitation in the README Tech Debt.

