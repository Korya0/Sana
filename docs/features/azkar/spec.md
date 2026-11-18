# Spec: Azkar & Tasbeeh

> **Status:** In progress  
> **Created:** 2026-11-15  
> **Note:** Check off a requirement (`[ ]`) only when it is implemented and verified in the running app by the developer. Code that exists but is not verified stays `[ ]`. Automated tests do not replace developer verification in the running app.

## Goal
Let users browse and read azkar with a simple counter, create and manage their own azkar categories, and count tasbeeh freely, all locally and without an account.

---

## Part 1: Azkar

### Home screen
- [ ] The home screen shows azkar categories in a responsive grid, each with an icon and a name.
- [ ] Azkar categories use circular icon surfaces, show each title on one moving line when needed, and have no entrance animation.
- [ ] The azkar section header carries the options action (the home screen has no app bar); the options sheet remains the entry to management.
- [ ] Custom azkar categories appear before built-in categories in the grid.
- [ ] The home screen provides access to create a custom azkar category, open font size settings, and manage custom azkar.
- [ ] A dedicated screen lists saved custom or modified azkar categories, shows an empty state when there are none, and provides entry points to add or edit them.
- [ ] Long-pressing a category opens actions relevant to that category, such as font size, edit, restore the original built-in content when applicable, and delete when applicable.

### Reading screen
- [ ] Choosing a category opens the reading screen and shows its azkar as vertical cards with the text centered.
- [ ] Each card has a circular counter that shows the remaining count and reflects progress toward the target.
- [ ] Reaching the target moves automatically to the next azkar card.
- [ ] I can reset a single azkar counter from its card without a confirmation message.
- [ ] The reading screen provides contextual actions for the current category based on its state, such as font size, edit, restore the original built-in content, or delete a custom category.
- [ ] Trying to exit reading with started but incomplete progress shows an exit confirmation; if there is no started incomplete progress, exit proceeds without confirmation.
- [ ] When all azkar in the current reading session are completed, the app shows completion feedback and closes the reading screen automatically.

### Custom azkar
- [ ] I can create a custom azkar category with a name and one or more azkar items, each with text and a target count; required fields are validated before saving.
- [ ] When adding or editing a zikr item, I can add its virtue (فضل الذكر) and edit it.
- [ ] I can add, edit, and remove azkar items within a custom or edited category before saving, subject to the category's editing constraints.
- [ ] A saved custom azkar category appears in the azkar categories and is still there after closing and reopening the app.
- [ ] I can edit a custom azkar category, including its name, its azkar items, and each item's target count.
- [ ] I can edit a built-in category's content; the built-in category name stays unchanged, original non-removable items can have their target count edited but cannot be removed, and items I added can be edited or removed.
- [ ] Saving edits while reading applies the updated content to the current reading session and preserves per-item counter progress, keeping each count within the updated target.
- [ ] I can delete a custom azkar category after a confirmation message.
- [ ] I can restore a modified built-in category to its original bundled content after a confirmation message.
- [ ] Closing a create or edit form or sheet with unsaved changes shows a confirmation to discard changes.
- [ ] I can reorder the azkar items within a single category by dragging from the edit screen.

### Copying
- [ ] I can copy an azkar item as formatted text, including its category and optional virtue.

### Font size settings
- [ ] A bottom sheet lets me change the azkar font size with a slider and shows a live text preview.
- [ ] The chosen font size is applied to azkar texts and is restored when I reopen the app.

---

## Part 2: Tasbeeh

### Tasbeeh card on the home screen
- [ ] A full-width tasbeeh card appears above the azkar categories.
- [ ] The saved tasbeeh card shows a bead-arc gauge with its count and two 48 px actions.
- [ ] When I have no saved tasbeeh items, the card shows a bead-arc gauge with `0` under "اختر سبحة للبدء", plus Astaghfirullah and one custom tasbeeh action, without "Continue" or "All" buttons.
- [ ] When I have saved tasbeeh items, the card shows the most recently used item's text on one line with an ellipsis, its count inside the bead-arc gauge, and no remaining-count line.
- [ ] The "Continue" button (play icon) opens the most recently used tasbeeh item.
- [ ] The "All" button (list icon) opens a bottom sheet where I can choose a tasbeeh item or add one.
- [ ] The home "All" bottom sheet does not include reading settings; the tasbeeh screen's app-bar sheet keeps its current reading settings.

### Tasbeeh screen
- [ ] The tasbeeh has its own screen.
- [ ] When I have no saved tasbeeh items, the screen offers Astaghfirullah and one custom tasbeeh action (see D-021).
- [ ] The app bar control opens a bottom sheet listing saved tasbeeh items and an action to add a tasbeeh item.
- [ ] On the loaded counter screen, tapping the selected-item control opens the same item-management sheet as the home "All" action, without reading settings.
- [ ] Selecting an item from the counter screen's sheet switches the current item without leaving the screen.

### Counter
- [ ] The tasbeeh text appears above a large circular counter without an outer card.
- [ ] The zikr and counter are centered together in the available reading area; long text scrolls within that area.
- [ ] The circular counter displays the remaining count when a target exists and shows completion at the target.
- [ ] Tapping the circular counter increases the count.
- [ ] After reaching a target, the next tap starts a new counting cycle at one.
- [ ] I can count freely without a target.
- [ ] A target count accepts at most four digits, and free counting stops at 9999.
- [ ] A filled primary reset button beside the saved-tasbeeh selector shows the icon above the one-line "تصفير العداد" label, with the same height and corner radius as the selector.

### Managing tasbeeh items
- [ ] Each tasbeeh item keeps its own independent counter.
- [ ] Saving a tasbeeh collapses repeated whitespace in its text to single spaces.
- [ ] The custom tasbeeh text field accepts at most 200 characters.
- [ ] Counts and targets are still there after closing and reopening the app.
- [ ] The bottom sheet provides item actions to edit or delete a saved tasbeeh.
- [ ] I can edit the target of a tasbeeh item.
- [ ] I can reset the counter from the tasbeeh screen.
- [ ] I can edit my custom tasbeeh items.
- [ ] I can delete my custom tasbeeh items after a confirmation message.

---

## Part 3: Shared counter behavior (reader and tasbeeh)

### Haptic feedback
- [ ] Each tap on a counter gives light haptic feedback.
- [ ] Completing an item gives a distinct haptic feedback.
- [ ] I can turn haptic feedback off.

### Counting with volume buttons (Android and iPhone)
- [ ] There is a setting to count with the volume buttons; it is off by default.
- [ ] When it is on, and a counter screen (reading or tasbeeh) is open with the app in the foreground, pressing volume up adds one count.
- [ ] When it is on, and a counter screen is open with the app in the foreground, pressing volume down subtracts one count.
- [ ] The count never goes below zero.
- [ ] While counting this way, the device volume does not change.
- [ ] When the setting is off, or I leave the counter screens, the volume buttons behave normally.

---

## Part 4: UI refinement (2026-11-18)

> **Note:** These requirements refine the screens in Parts 1-3. Where they conflict with an older line, this Part wins until the older line is reconciled.

### Home
- [ ] ~~The app-bar header stays as it is (developer decision: no change).~~ Removed on 2026-11-18: the home screen has no app bar, and the options icon moved to the azkar section header.
- [ ] The tab root never shows a back arrow, because it has no screen to return to.
- [ ] The options sheet lists custom-azkar management only; creation is reached from management.
- [ ] The saved-tasbeeh card shows the zikr on one line with an ellipsis and no scrolling.
- [ ] The saved-tasbeeh card does not show a remaining-count line (for example, "remaining 0 of 3").
- [ ] The saved-tasbeeh card shows a play icon on "متابعة" and a list icon on "كل السبح".
- [ ] When no tasbeeh is saved, the card shows "اختر سبحة للبدء" as a secondary subtitle.
- [ ] Long-press category sheets show icons beside "استعادة الأصل" and "حذف".

### Tasbeeh
- [ ] Tasbeeh copy uses the "سبحة/سبح" wording everywhere, including the selector label "اضغط لاختيار السبحة".
- [ ] The item sheet's "إنشاء سبحة" action shows an add icon in the same color and size as its label.
- [ ] The custom tasbeeh form's text field is three lines tall and labeled "نص السبحة".

### Custom azkar
- [ ] The category name field is labeled "اسم قسم الأذكار".
- [ ] The zikr text field grows with its content instead of scrolling inside a fixed-height box.
- [ ] The create action sits in the app bar when the list has items; when the list is empty, the body button is the only create action.
- [ ] Required fields show a red `*` mark, and optional fields show "(اختياري)".

### Reading
- [ ] Reset and copy actions have identical sizes side by side.
- [ ] The reading options sheet shows icons beside "استعادة الأصل" and "حذف".

---

## Part 5: Quality assurance

- [ ] Verify that every azkar feature file has complete unit and widget test coverage.
- [ ] A full integration test suite covers the complete azkar and tasbeeh feature flows.
- [ ] Verify complete responsiveness across supported screen sizes, orientations, and text scaling for every azkar screen and state, including dialogs and bottom sheets.
- [ ] Verify complete animation and motion behavior, including transitions and gesture-driven interactions, across every azkar screen and state.
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

## Open Questions
- **iOS volume-button counting:** Confirm feasibility and any platform/review constraints for counting with hardware volume buttons on iPhone during real-device validation. Assumption for now: one volume button increases the count and the other decreases it while a counter screen is open in the foreground, without changing device volume.
