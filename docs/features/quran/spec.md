# Spec: Quran

> **Status:** In progress
> **Created:** 2026-11-28
> **Revised:** 2026-11-28 — requirements agreed with the developer after a feasibility audit of `quran_library 5.0.1`. The Goal wording was written by the AI at the developer's request on 2026-11-28. All requirements start unchecked; none has been verified in the running app after these decisions.
> **Note:** Out of Scope comes from the developer's decisions in chat; inferred implementation choices are recorded in the feature README instead.

## Goal
Let the user open the Quran without friction and continue from where they stopped, with simple tools for listening, memorization, and completing a Khatma.

---

## Part 1: Navigation and entry

### Bottom navigation
- [ ] The bottom navigation order is Home, Quran, Azkar, Settings.
- [ ] The Quran tab is placed before the Azkar tab.

### Landing page
- [ ] Tapping the Quran tab opens a lightweight landing page instead of the Mushaf.
- [ ] The landing page prepares the Mushaf in the background.
- [ ] When preparation is already complete, entering the Mushaf shows no loading indicator.
- [ ] When preparation is still running, entering the Mushaf shows a loading indicator and then opens the Mushaf automatically.
- [ ] The landing page does not show a surah index.
- [ ] The landing page does not force a starting point such as Al-Fatihah.
- [ ] Each section takes only the space its content needs.
- [ ] The landing page contains no empty cards or oversized placeholders.

---

## Part 2: Continue reading and bookmarks

### Continue reading
- [ ] The landing page shows a compact card with the last reading position.
- [ ] Tapping the card opens the Mushaf at that position.
- [ ] When no reading history exists, the card does not offer a forced start action.

### Bookmarks
- [ ] The landing page shows three colored bookmarks matching the ones inside the Mushaf.
- [ ] Each bookmark indicates whether it holds an ayah.
- [ ] Tapping a bookmark that holds one ayah opens the Mushaf at that ayah.
- [ ] When a bookmark holds several ayahs, the app shows a compact list of them before opening the Mushaf.
- [ ] Bookmarks stay in sync with the ones saved inside the Mushaf.

### Quick search
- [ ] The landing page offers a small quick search icon.
- [ ] Tapping search opens the Mushaf with its list button available.
- [ ] The user selects the Search tab from that list.
- [ ] No separate search UI is built for the landing page.

---

## Part 3: Tafsir

### Tafsir
- [ ] The landing page offers a Tafsir entry point.
- [ ] Tapping it lets the user choose a surah or ayah, then opens Tafsir without entering the Mushaf first.
- [ ] The user can choose from the Tafsir sources and translations provided by the package.
- [ ] Tafsir data can be downloaded from within the app.

---

## Part 4: Listening

### Surahs and readers
- [ ] The landing page offers a compact Listening section.
- [ ] The section lists surahs available through the package.
- [ ] The section lists readers available through the package.
- [ ] The user can download a surah for offline playback.
- [ ] The user can play a surah.
- [ ] The user can resume the last listening position.

### Playback
- [ ] Playback continues in the background with control buttons.
- [ ] Playback controls are available on the lock screen.
- [ ] The section uses only the space its content needs.

---

## Part 5: Memorization

### Scope
- [ ] The landing page offers a Memorization section separate from Tasmee.
- [ ] Tasmee remains available in the Mushaf app bar during reading.
- [ ] The Memorization section does not request microphone access.

### Recall and plan
- [ ] The Memorization section hides words or ayahs for recall.
- [ ] The user can reveal hidden words while memorizing.
- [ ] The user chooses a starting method: Al-Fatihah, An-Nas, or a selected surah.
- [ ] The user chooses a daily plan by available time: a page, half a page, or ayahs.

### Progress and review
- [ ] A map shows which pages are memorized and their strength.
- [ ] A review schedule uses spaced repetition.
- [ ] Daily review notifications follow `docs/features/notifications/spec.md`.
- [ ] Memorization data is stored locally by the app.

---

## Part 6: Ward and Khatma

### Daily ward
- [ ] The user sets a fixed daily ward as a juz, a hizb, or pages.
- [ ] The app calculates the daily ward automatically.
- [ ] The app adjusts the ward when the user falls behind.
- [ ] The app sends a daily notification reminding the user of the current ward, using the shared rules in `docs/features/notifications/spec.md`.

### Khatma plans
- [ ] The user can start a 30-day Khatma plan.
- [ ] The user can start a Ramadan Khatma plan.
- [ ] The user can set a custom number of days for a Khatma plan.
- [ ] Completed Khatmas are listed with their dates and count.
- [ ] The app estimates the remaining time to finish the current Khatma from the current pace.
- [ ] Ward and Khatma data is stored locally by the app.

---

## Part 7: Quality assurance

- [ ] Verify that every feature file has complete unit and widget test coverage.
- [ ] A full integration test suite covers the complete feature flows.
- [ ] Verify complete responsiveness across supported screen sizes, orientations, and text scaling for every feature screen and state, including dialogs and bottom sheets.
- [ ] Verify complete animation and motion behavior, including transitions and gesture-driven interactions, across every feature screen and state.
- [ ] Capture screenshots for every feature screen and state, including dialogs and bottom sheets, covering all possible cases, and store them under `screenshots/quran/` at the repository root.
- [ ] Organize and reference the feature screenshots in the root `README.md` and the feature `docs/features/quran/README.md`.
- [ ] Review all related docs and READMEs before closing the feature.

---

## Planned phase: shared notification service

Not implemented yet. This phase is defined in `docs/features/notifications/spec.md`.

- [ ] Quran review and ward notifications are built on the shared notification service.
- [ ] Quran does not define its own permission or scheduling rules for notifications.

---

## Out of Scope

Decided by the developer; not part of this spec for now.

- A surah index on the landing page (the user chooses from the list inside the Mushaf).
- A forced "Start from Al-Fatihah" action (the user chooses the starting point).
- Large cards or empty placeholders on the landing page.
- A separate Tasmee section on the landing page (Tasmee stays in the Mushaf app bar for reading).
- A custom search UI on the landing page (search is reached through the Mushaf list button).
- A daily streak display.
- A custom app bar replacing the package top bar.
- Changing or hiding the Tajweed icon.
- An app-owned microphone permission flow (deferred).

## Open Questions

- **Verification:** Have the current requirements been verified in the running app? Current assumption: no, so every requirement stays unchecked.
- **Notification time:** What time should daily review and ward notifications be sent? Current assumption: a developer-set fixed time.
