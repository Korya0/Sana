# Spec: Azkar & Tasbeeh

> **Status:** In progress
> **Created:** 2026-11-15
> **Revised:** 2026-11-28 — reminders for individual azkar categories were added by developer decision. These new requirements start unchecked; all previously added requirements remain `[x]` as verified by the developer.
> **Note:** Per project rules, `[x]` means implemented and verified in the running app by the developer. The new reminder requirements are not implemented or verified yet.

## Goal
Let users browse and read azkar with a simple counter, create and manage their own azkar categories, and count tasbeeh freely, all locally and without an account.

---

## Part 1: Azkar

### Home screen
- [x] The home screen shows azkar categories in a responsive grid, each with an icon and a name.
- [x] Azkar categories use circular icon surfaces, show each title on one moving line when needed, and have no entrance animation (skeleton loading only).
- [x] The azkar section header carries the options action (the home screen has no app bar); the options sheet remains the entry to management.
- [x] Custom azkar categories appear before built-in categories in the grid.
- [x] The home screen provides access to open font size settings and manage custom azkar from the azkar section options sheet. Creating a custom azkar category is done from the custom azkar management screen (including its empty state and the in-list create action when items exist), and creation may also be offered from relevant empty states.
- [x] A dedicated screen lists saved custom or modified azkar categories, shows an empty state when there are none, and provides entry points to add or edit them.
- [x] Long-pressing a category opens actions relevant to that category, such as edit, restore the original built-in content when applicable, and delete when applicable.

### Reading screen
- [x] Choosing a category opens the reading screen and shows its azkar as vertical cards with the text centered.
- [x] Each card has a circular counter that shows the remaining count and reflects progress toward the target.
- [x] Reaching the target moves automatically to the next azkar card.
- [x] I can reset a single azkar counter from its card without a confirmation message.
- [x] The reading screen provides contextual actions for the current category based on its state, such as font size, edit, restore the original built-in content, or delete a custom category.
- [x] Trying to exit reading with started but incomplete progress shows an exit confirmation; if there is no started incomplete progress, exit proceeds without confirmation.
- [x] When all azkar in the current reading session are completed, the app shows completion feedback and closes the reading screen automatically.

### Custom azkar
- [x] I can create a custom azkar category with a name and one or more azkar items, each with text and a target count; required fields are validated before saving.
- [x] When adding or editing a zikr item, I can add its virtue (فضل الذكر) and edit it.
- [x] I can add, edit, and remove azkar items within a custom or edited category before saving, subject to the category's editing constraints.
- [x] A saved custom azkar category appears in the azkar categories and is still there after closing and reopening the app.
- [x] I can edit a custom azkar category, including its name, its azkar items, and each item's target count.
- [x] I can edit a built-in category's content; the built-in category name stays unchanged, original non-removable items can have their target count edited but cannot be removed, and items I added can be edited or removed.
- [x] Saving edits while reading applies the updated content to the current reading session and preserves per-item counter progress, keeping each count within the updated target.
- [x] I can delete a custom azkar category after a confirmation message.
- [x] I can restore a modified built-in category to its original bundled content after a confirmation message.
- [x] Closing a create or edit form or sheet with unsaved changes shows a confirmation to discard changes.
- [x] I can reorder the azkar items within a single category by dragging from the edit screen.

### Copying
- [x] I can copy an azkar item as formatted text, including its category and optional virtue.

### Font size settings
- [x] A bottom sheet lets me change the azkar font size with a slider and shows a live text preview.
- [x] The chosen font size is applied to azkar texts and is restored when I reopen the app.

---

## Part 2: Tasbeeh

### Tasbeeh card on the home screen
- [x] A full-width tasbeeh card appears above the azkar categories.
- [x] The saved tasbeeh card shows a bead-arc gauge with its count and one centered text action.
- [x] When I have no saved tasbeeh items, the card shows a bead-arc gauge with no reserved space for a hidden count and no "Continue"/"All" buttons. The gauge itself is not tappable; its prompt is a text button "السبحة المخصصة" with an add icon that opens the custom-tasbeeh sheet, followed by three compact light-bordered preset chips centered: الحمد لله، أستغفر الله، سبحان الله. *(Change 2026-11-19: replaced the old prompt plus two-button row.)*
- [x] When I have saved tasbeeh items, the card shows the most recently used item's text on up to two lines, its count inside the bead-arc gauge, and no remaining-count line.
- [x] On first appearance, the saved-tasbeeh count counts up from zero to the saved value, and the bead gauge fills bead by bead; both are skipped when motion is reduced.
- [x] A saved free tasbeeh with a zero count shows an inactive (empty) bead gauge; after the first count the arc is full.
- [x] The "متابعة التسبيح" chip below the beads opens the most recently used tasbeeh item.
- [x] ~~The "All" button (list icon) opens a bottom sheet where I can choose a tasbeeh item or add one.~~ Removed on 2026-11-20; the home card shows only the "متابعة التسبيح" chip.
- [x] ~~Tapping the bead gauge counts the most recent tasbeeh without leaving the home screen~~ (removed 2026-11-20); the card is display-only and the centered "متابعة التسبيح" chip below the beads opens the tasbeeh screen.
- [x] ~~The home "All" bottom sheet does not include reading settings~~ (the home All entry is removed); the tasbeeh screen's app-bar sheet keeps its current reading settings.

### Tasbeeh screen
- [x] The tasbeeh has its own screen.
- [x] When I have no saved tasbeeh items, the screen offers three preset chips (الحمد لله، أستغفر الله، سبحان الله) and the "السبحة المخصصة" prompt (see D-021).
- [x] Below the app bar, the "قائمة السبح" action opens a sheet listing saved tasbeeh items; "إنشاء سبحة" opens the create form.
- [x] The app bar 3-dot icon opens the shared reading settings sheet (font size, haptics, volume-button counting).

### Counter
- [x] The tasbeeh text and counter appear together inside a card matching the reading-mode zikr card.
- [x] The zikr and counter are centered together in the available reading area; long text scrolls within that area.
- [x] The circular counter displays the remaining count when a target exists and shows completion at the target.
- [x] Tapping the circular counter increases the count.
- [x] After reaching a target, the next tap starts a new counting cycle at one.
- [x] I can count freely without a target.
- [x] A target count accepts at most four digits, and free counting stops at 9999.
- [x] A two-part menu in the card shows minus = decrement one and a refresh icon with `0` = full reset; each action is visible with its own label.

### Managing tasbeeh items
- [x] Each tasbeeh item keeps its own independent counter.
- [x] Saving a tasbeeh collapses repeated whitespace in its text to single spaces.
- [x] The custom tasbeeh text field accepts at most 500 characters.
- [x] Counts and targets are still there after closing and reopening the app.
- [x] The bottom sheet provides item actions to edit or delete a saved tasbeeh.
- [x] I can edit the target of a tasbeeh item.
- [x] I can decrement or fully reset the counter from the tasbeeh card's two-part menu. No dialog is shown. *(Confirmed personally by the developer.)*

> **Change (2026-11-20):** reset controls in both cards use two visible actions (minus = decrement one, refresh with `0` = full reset). The old tap/long-press difference, a tasbeeh confirmation dialog and an extra app-bar reset icon were rejected.
- [x] I can edit my custom tasbeeh items.
- [x] I can delete my custom tasbeeh items after a confirmation message.

---

## Part 3: Shared counter behavior (reader and tasbeeh)

### Haptic feedback
- [x] Each tap on a counter gives light haptic feedback.
- [x] Completing an item gives a distinct haptic feedback.
- [x] I can turn haptic feedback off.

### Counting with volume buttons (Android only)
> All requirements below were confirmed personally by the developer on 2026-11-19. Implemented on Android; iPhone is deferred (see Out of Scope).
> **Change (2026-11-19):** the developer asked to enable the setting automatically on first open on Android; it was originally specified as off by default.
- [x] There is a setting to count with the volume buttons; it is enabled automatically on Android the first time the app is opened, and an explicit choice to turn it off is kept across restarts.
- [x] The setting is visible on every platform, but on non-Android platforms it is disabled and explains that it is available on Android only.
- [x] When it is on, and a counter screen (reading or tasbeeh) is open with the app in the foreground, pressing volume up adds one count.
- [x] On the reading screen, the volume buttons count the first incomplete zikr.
- [x] When it is on, and a counter screen is open with the app in the foreground, pressing volume down subtracts one count.
- [x] The count never goes below zero.
- [x] While counting this way, the device volume does not change.
- [x] When the setting is off, or I leave the counter screens, the volume buttons behave normally.

---

## Part 4: UI refinement (2026-11-18)

> **Note:** These requirements refine the screens in Parts 1-3. Where they conflict with an older line, this Part wins until the older line is reconciled.

### Home
- [x] ~~The app-bar header stays as it is (developer decision: no change).~~ Removed on 2026-11-18: the home screen has no app bar, and the options icon moved to the azkar section header.
- [x] The tab root never shows a back arrow, because it has no screen to return to.
- [x] The options sheet lists custom-azkar management and the shared reading settings rows; creation is reached from management.
- [x] The saved-tasbeeh card shows the zikr on up to two lines and no remaining-count line.
- [x] The saved-tasbeeh card does not show a remaining-count line (for example, "remaining 0 of 3").
- [x] The saved-tasbeeh card shows only a centered "متابعة التسبيح" chip below the beads (label then left-pointing arrow); the "كل السبح" button and the experimental adjust control were removed.
- [x] When no tasbeeh is saved, the card shows "السبحة المخصصة" as a text button with an add icon.
- [x] Long-press category sheets show icons beside "استعادة الأصل" and "حذف".

### Tasbeeh
- [x] Tasbeeh copy uses the "سبحة/سبح" wording everywhere; the selector field was removed in favour of "قائمة السبح".
- [x] The "إنشاء سبحة" action sits below the app bar with an add icon, beside "قائمة السبح".
- [x] The custom tasbeeh form's text field is labeled "نص السبحة".

### Custom azkar
- [x] The category name field is labeled "اسم قسم الأذكار".
- [x] The zikr text field keeps a fixed height and scrolls inside its box instead of growing with the content; no text field anywhere grows to fit its text.
- [x] The create action is a text+icon button in the body header (above the name field); there is no floating button.
- [x] Required fields show a red `*` mark, and optional fields show "(اختياري)".

### Reading
- [x] Reset and copy actions have identical sizes side by side.
- [x] The reading options sheet shows icons beside "استعادة الأصل" and "حذف".

### Validation
- [x] Every text field requires at least 3 Arabic letters; one-character and punctuation-only values are rejected.
- [x] Duplicate category names and duplicate tasbeeh texts are rejected.
- [x] Counts are capped at 9999 in the field validator, the cubit and stored data.

### Bottom sheets
- [x] Every bottom sheet shows its title at the start of the header, beside a close (`X`) icon when it opens over a screen or a back icon when it opens from another bottom sheet.
- [x] Form bottom sheets show a text Save action at the end of the header and have no Save/Cancel buttons at the bottom.
- [x] The header Save action stays disabled until the form fields are valid.
- [x] The close/back control asks before discarding unsaved changes.

---

## Part 5: Confirmed implemented behaviors (added 2026-11-19)

> Added based on implementation review and developer approval (2026-11-19). These behaviors are user-visible/testable outcomes already present in the current implementation.

### Reading
- [x] After completing a zikr repetition, the reading screen moves/focuses to the first incomplete zikr card so the next item is easy to continue.
- [x] Auto-completion feedback and automatic closing of the reading screen happen only when the current reading session becomes fully completed by normal progress (not when edits to the category content make the session appear complete).
- [x] Copying a zikr item produces formatted text that includes the category title and the zikr text, and includes the virtue as a labeled section when a virtue is present.

### Tasbeeh
- [x] When the tasbeeh screen opens while items are loading, it does not briefly show the empty preset/start state if saved items will be shown; the correct loaded state is shown once loading completes.
- [x] The tasbeeh item sheet allows me to edit or delete a shown saved tasbeeh item from the item list.

### Custom azkar management
- [x] The custom/modified azkar list avoids showing a loading skeleton for very fast loads to reduce visual flicker.

### Data and sync consistency
- [x] After I open or complete actions that can change azkar or tasbeeh data (such as editing, adding, deleting, restoring, or opening screens), the app refreshes the relevant lists and screens so I see the latest saved state when I return.
- [x] My saved azkar/tasbeeh data remains usable after app restart, and quick or repeated saves do not lose the latest saved changes.

---

## Part 6: Reminders (added 2026-11-28)

### Scope
- [ ] The user can add a reminder to any azkar category, including built-in categories such as morning and sleep azkar and custom categories.
- [ ] The user can set the reminder time and choose which days it repeats.
- [ ] The user can edit or remove an existing reminder.
- [ ] Deleting an azkar category cancels all reminders attached to it.

### System behavior
- [ ] The app asks for notification and exact alarm permissions using the shared flow in `docs/features/notifications/spec.md`.
- [ ] Reminders follow the shared scheduling and presentation rules in `docs/features/notifications/spec.md`.
- [ ] At most five azkar categories can have reminders, whether built-in or custom, chosen by the user.
- [ ] Each category has at most one reminder per day.
- [ ] The user chooses whether a reminder repeats every day or only on selected days.
- [ ] The app follows the battery-optimization guidance in `docs/features/notifications/spec.md`.

---

## Part 7: Quality assurance

- [x] Verify that every azkar feature file has complete unit and widget test coverage. *(Developer-approved on 2026-11-20. Evidence: 120 source files / 132 test files / 0 files without tests; 584 unit and widget tests passing; 97.36% line coverage of `lib/features/azkar`.)*
- [x] Verify complete responsiveness across supported screen sizes, orientations, and text scaling for every azkar screen and state, including dialogs and bottom sheets. *(Confirmed personally by the developer in full, 2026-11-21.)*
- [x] Verify complete animation and motion behavior, including transitions and gesture-driven interactions, across every azkar screen and state. *(Developer-approved in this revision; keep evidence/screenshots as needed during final closure.)*
- [x] Capture screenshots for every azkar screen and state, including dialogs and bottom sheets, covering all possible cases, and store them under `screenshots/azkar/` at the repository root. *(Confirmed personally by the developer in full, 2026-11-21.)*
- [x] Organize and reference the azkar screenshots in the root `README.md` and `docs/features/azkar/README.md`. *(Confirmed personally by the developer in full, 2026-11-21.)*
- [x] Review all related docs and READMEs before closing the feature. *(Confirmed personally by the developer in full, 2026-11-21.)*

---

## Planned phase: shared notification service

Not implemented yet. This phase is defined in `docs/features/notifications/spec.md`.

- [ ] Azkar reminders are built on the shared notification service instead of a feature-owned notification implementation.
- [ ] Azkar does not define its own permission, scheduling or presentation rules for notifications.
- [ ] The five-category reminder budget stays in this spec; the shared service enforces the app-wide total cap.

---

## Out of Scope
Decided by the developer; not part of this spec for now.
- AI-generated azkar (no plan for it at the moment).
- Saving daily reading progress between sessions.
- Time-based category suggestions on the home screen (users need stable places).
- A dedicated on-screen undo button for tasbeeh (an extra tap only adds to the count; subtracting is only available through the volume down button when that setting is on).
- Statistics and streaks.
- Search and favorites (about 20 categories; not needed).
- Backup/export of custom azkar (cannot be done at this stage).
- Sharing azkar as an image, link, or importable format.
- Keeping the screen on (not now).
- Cloud sync and accounts.
- Counting with the volume buttons while the app is in the background or the screen is locked (the buttons only work while a counter screen is open in the foreground).
- Volume-button counting on iOS, desktop, and web (Android-only for now; the setting is shown disabled elsewhere, and iPhone support is deferred).

## Open Questions

None. Notification behavior is defined in `docs/features/notifications/spec.md`.
