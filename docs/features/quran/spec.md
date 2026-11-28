# Spec: Quran

> **Status:** In progress
> **Created:** 2026-11-28
> **Note:** All requirements start unchecked. They describe the current implementation direction, but none has been verified in the running app after the latest UI changes, so the AI must not check them off. Goal, Out of Scope and Open Questions come from the developer's decisions in chat; anything the AI inferred is marked in the README instead.

## Goal
Pending: proposed wording, awaiting developer confirmation.

---

## Part 1: Entry and initialization

### Opening the feature
- [ ] Tapping the Quran tab in the bottom navigation opens the Quran feature.
- [ ] A centered circular progress indicator is shown while the Mushaf is being prepared.
- [ ] The progress indicator uses the app's primary color in both light and dark themes.
- [ ] When preparation succeeds, the indicator is replaced by the Mushaf screen without a success message.
- [ ] When preparation fails, an error view with a retry button is shown.
- [ ] Tapping retry repeats preparation.
- [ ] After a successful preparation, returning to the tab does not replay the loading state.
- [ ] The tab stays reachable from the bottom navigation while reading.

### Reliability
- [ ] The app starts normally even when the user never opens the Quran tab.
- [ ] Leaving the feature during preparation does not cause an error after the app is closed.

---

## Part 2: Mushaf screen and built-in controls

### Page display
- [ ] The Mushaf opens on the last read page.
- [ ] Pages can be turned by swiping.
- [ ] The page follows the app's light or dark theme.
- [ ] The bottom navigation stays visible while reading.

### Visible controls
- [ ] The switch between "Quran" and "Ten Recitations" is not visible.
- [ ] The side switch between Quran and Tafsir display modes is not visible.
- [ ] The bottom audio control bar is not visible.
- [ ] The audio icon in the Mushaf top bar is not visible.
- [ ] The list icon (index / search / bookmarks) remains visible in the top bar.
- [ ] The Tajweed "!" icon remains visible in the top bar.
- [ ] The Tajweed colors stay under the control of the fonts dialog toggle.

---

## Part 3: Ayah actions

### Action strip
- [ ] Long-pressing an ayah opens the action strip.
- [ ] The strip contains a play action for the single ayah.
- [ ] The strip does not contain the play-all action.
- [ ] The strip contains a Tafsir action.
- [ ] The strip contains a copy action.
- [ ] The strip contains bookmark actions.
- [ ] Every action uses the app's color tokens and press feedback.

---

## Part 4: Quality assurance

- [ ] Verify that every feature file has complete unit and widget test coverage.
- [ ] A full integration test suite covers the complete feature flows.
- [ ] Verify complete responsiveness across supported screen sizes, orientations, and text scaling for every feature screen and state, including dialogs and bottom sheets.
- [ ] Verify complete animation and motion behavior, including transitions and gesture-driven interactions, across every feature screen and state.
- [ ] Capture screenshots for every feature screen and state, including dialogs and bottom sheets, covering all possible cases, and store them under `screenshots/quran/` at the repository root.
- [ ] Organize and reference the feature screenshots in the root `README.md` and the feature `docs/features/quran/README.md`.
- [ ] Review all related docs and READMEs before closing the feature.

---

## Out of Scope

Decided by the developer; not part of this spec for now.

- Separate index, search and bookmark icons in the top bar (developer chose to keep the package list icon).
- A custom app bar replacing the package top bar (developer asked to avoid it).
- Hiding or relocating the Tajweed icon (deferred by the developer until later).
- App-owned microphone permission flow with rationale and denied states (deferred by the developer until later).

## Open Questions

- **Goal wording:** What is the one-sentence user goal for this feature? No wording has been confirmed yet; the spec leaves it pending.
- **Microphone permission:** Should the app own the permission prompt and the denied state before Tasmee starts? Current assumption: the package still handles it, so a denial shows its raw error text.
- **Landing page:** Should the Quran tab open an introductory page before the Mushaf? Current assumption: no, it opens the Mushaf directly for now.
- **Surah-number circle:** Should it use the theme's primary color in both themes? Current assumption: yes, this is still pending implementation.
- **Verification:** Have the current requirements been verified in the running app after the latest UI changes? Current assumption: no, so every requirement stays unchecked.
