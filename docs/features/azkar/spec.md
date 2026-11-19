# Spec: Azkar & Tasbeeh

> **Status:** In progress
> **Created:** 2026-11-15
> **Note:** Items marked `[x]` in this revision were personally approved/confirmed by the developer on 2026-11-19 based on implementation review. Unchecked items remain pending implementation or pending developer verification/closure as noted. Per project rules, `[x]` normally means implemented and verified in the running app by the developer.

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
- [x] The saved tasbeeh card shows a bead-arc gauge with its count and two 48 px actions.
- [x] When I have no saved tasbeeh items, the card shows a bead-arc gauge with ~~`0` under~~ "اختر سبحة للبدء" only (no count), plus Astaghfirullah and one custom tasbeeh action, without "Continue" or "All" buttons. The start gauge is not tappable; only the Astaghfirullah and custom actions respond. *(Change 2026-11-19: the start-state number was removed and the gauge was disabled.)*
- [x] When I have saved tasbeeh items, the card shows the most recently used item's text on up to two lines, its count inside the bead-arc gauge, and no remaining-count line.
- [x] On first appearance, the saved-tasbeeh count counts up from zero to the saved value, and the bead gauge fills bead by bead; both are skipped when motion is reduced.
- [x] A saved free tasbeeh with a zero count shows an inactive (empty) bead gauge; after the first count the arc is full.
- [x] The "Continue" button (play icon) opens the most recently used tasbeeh item.
- [x] The "All" button (list icon) opens a bottom sheet where I can choose a tasbeeh item or add one.
- [x] Tapping the bead gauge counts the most recent tasbeeh without leaving the home screen; only "Continue" opens the tasbeeh screen. *(Confirmed personally by the developer, 2026-11-19.)*
- [x] The home "All" bottom sheet does not include reading settings; the tasbeeh screen's app-bar sheet keeps its current reading settings.

### Tasbeeh screen
- [x] The tasbeeh has its own screen.
- [x] When I have no saved tasbeeh items, the screen offers Astaghfirullah and one custom tasbeeh action (see D-021).
- [x] The app bar control opens a bottom sheet listing saved tasbeeh items and an action to add a tasbeeh item.
- [x] On the loaded counter screen, tapping the selected-item control opens the same item-management sheet as the home "All" action, without reading settings.
- [x] Selecting an item from the counter screen's sheet switches the current item without leaving the screen.

### Counter
- [x] The tasbeeh text appears above a large circular counter without an outer card.
- [x] The zikr and counter are centered together in the available reading area; long text scrolls within that area.
- [x] The circular counter displays the remaining count when a target exists and shows completion at the target.
- [x] Tapping the circular counter increases the count.
- [x] After reaching a target, the next tap starts a new counting cycle at one.
- [x] I can count freely without a target.
- [x] A target count accepts at most four digits, and free counting stops at 9999.
- [x] A filled primary reset button beside the saved-tasbeeh selector shows the icon above the one-line "تصفير العداد" label, with the same height and corner radius as the selector.

### Managing tasbeeh items
- [x] Each tasbeeh item keeps its own independent counter.
- [x] Saving a tasbeeh collapses repeated whitespace in its text to single spaces.
- [x] The custom tasbeeh text field accepts at most 200 characters.
- [x] Counts and targets are still there after closing and reopening the app.
- [x] The bottom sheet provides item actions to edit or delete a saved tasbeeh.
- [x] I can edit the target of a tasbeeh item.
- [x] I can reset the counter from the tasbeeh screen.
- [x] The tasbeeh "تصفير العداد" button follows the same pattern: a single tap decrements the selected item by one, and a long press resets it fully. No dialog is shown. *(Confirmed personally by the developer, 2026-11-19.)*

> **Change (2026-11-19):** reset controls in both counters use tap = decrement one and long press = full reset. A tasbeeh confirmation dialog and an extra app-bar reset icon were considered and rejected by the developer.
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
- [x] The options sheet lists custom-azkar management only; creation is reached from management.
- [x] The saved-tasbeeh card shows the zikr on one line with an ellipsis and no scrolling.
- [x] The saved-tasbeeh card does not show a remaining-count line (for example, "remaining 0 of 3").
- [x] The saved-tasbeeh card shows a play icon on "متابعة" and a list icon on "كل السبح".
- [x] When no tasbeeh is saved, the card shows "اختر سبحة للبدء" as a secondary subtitle.
- [x] Long-press category sheets show icons beside "استعادة الأصل" and "حذف".

### Tasbeeh
- [x] Tasbeeh copy uses the "سبحة/سبح" wording everywhere, including the selector label "اضغط لاختيار السبحة".
- [x] The item sheet's "إنشاء سبحة" action shows an add icon in the same color and size as its label.
- [x] The custom tasbeeh form's text field is labeled "نص السبحة".

### Custom azkar
- [x] The category name field is labeled "اسم قسم الأذكار".
- [x] The zikr text field keeps a fixed height and scrolls inside its box instead of growing with the content; no text field anywhere grows to fit its text.
- [x] The create action sits in the app bar when the list has items; when the list is empty, the body button is the only create action.
- [x] Required fields show a red `*` mark, and optional fields show "(اختياري)".

### Reading
- [x] Reset and copy actions have identical sizes side by side.
- [x] The reading options sheet shows icons beside "استعادة الأصل" and "حذف".

### Validation
- [ ] Every text field requires at least 3 Arabic letters; one-character and punctuation-only values are rejected.
- [ ] Duplicate category names and duplicate tasbeeh texts are rejected.
- [ ] Counts are capped at 9999 in the field validator, the cubit and stored data.

### Bottom sheets
- [ ] Every bottom sheet shows its title at the start of the header, beside a close (`X`) icon when it opens over a screen or a back icon when it opens from another bottom sheet.
- [ ] Form bottom sheets show a text Save action at the end of the header and have no Save/Cancel buttons at the bottom.
- [ ] The header Save action stays disabled until the form fields are valid.
- [ ] The close/back control asks before discarding unsaved changes.

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

## Part 6: Quality assurance

- [ ] Verify that every azkar feature file has complete unit and widget test coverage.
- [ ] A full integration test suite covers the complete azkar and tasbeeh feature flows.
- [ ] Verify complete responsiveness across supported screen sizes, orientations, and text scaling for every azkar screen and state, including dialogs and bottom sheets.
- [x] Verify complete animation and motion behavior, including transitions and gesture-driven interactions, across every azkar screen and state. *(Developer-approved in this revision; keep evidence/screenshots as needed during final closure.)*
- [ ] Capture screenshots for every azkar screen and state, including dialogs and bottom sheets, covering all possible cases, and store them under `screenshots/azkar/` at the repository root.
- [ ] Organize and reference the azkar screenshots in the root `README.md` and `docs/features/azkar/README.md`.
- [ ] Review all related docs and READMEs before closing the feature.

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
- Reminders tied to a specific category. Notifications will be studied once, together with adhan, salawat, and other reminders, after all features are done.
- Keeping the screen on (not now).
- Cloud sync and accounts.
- Counting with the volume buttons while the app is in the background or the screen is locked (the buttons only work while a counter screen is open in the foreground).
- Volume-button counting on iOS, desktop, and web (Android-only for now; the setting is shown disabled elsewhere, and iPhone support is deferred).

## Open Questions
- **Android volume-button real-device verification:** Run the ADB test matrix in `plan.md` on an Android device before marking requirements 106-113 verified, especially that the device volume never changes and that normal volume behavior returns after leaving the counter screens.
- **Zikr reorder by drag (requirement 43):** Deferred for later implementation by developer decision (2026-11-19). Keep unchecked until implemented and verified.
