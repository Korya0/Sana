# Spec: Azkar & Tasbeeh

> **Status:** In progress  
> **Created:** 2026-11-15  
> **Note:** Items marked `[x]` are implemented in code and pending the developer's own verification in the running app. Only items the developer verifies stay `[x]`.

## Goal
Let users browse and read azkar with a simple counter, create and manage their own azkar categories, and count tasbeeh freely, all locally and without an account.

---

## Part 1: Azkar

### Home screen
- [x] The home screen shows azkar categories in a responsive grid, each with an icon and a name.
- [x] Custom azkar categories appear before built-in categories in the grid.
- [x] The home screen provides access to create a custom azkar category, open font size settings, and manage custom azkar.
- [x] A dedicated screen lists saved custom or modified azkar categories, shows an empty state when there are none, and provides entry points to add or edit them.
- [x] Long-pressing a category opens actions relevant to that category, such as font size, edit, restore the original built-in content when applicable, and delete when applicable.

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
- [ ] I can reorder the azkar items within a single category by dragging from the edit screen.

### Copying
- [x] I can copy an azkar item as formatted text, including its category and optional virtue.

### Font size settings
- [x] A bottom sheet lets me change the azkar font size with a slider and shows a live text preview.
- [x] The chosen font size is applied to azkar texts and is restored when I reopen the app.

---

## Part 2: Tasbeeh

### Tasbeeh card on the home screen
- [ ] A full-width tasbeeh card appears above the azkar categories.
- [ ] When I have no saved tasbeeh items, the card shows three preset azkar and one matching custom tasbeeh tile without "Continue" or "All" buttons.
- [ ] When I have saved tasbeeh items, the card shows the most recently used item's text and circular counter.
- [ ] The "Continue" button opens the most recently used tasbeeh item.
- [ ] The "All" button opens a bottom sheet where I can choose a tasbeeh item or add one.

### Tasbeeh screen
- [ ] The tasbeeh has its own screen.
- [ ] When I have no saved tasbeeh items, the screen offers three preset azkar and one custom tasbeeh tile.
- [ ] The app bar control opens a bottom sheet listing saved tasbeeh items and an action to add a tasbeeh item.
- [ ] Selecting an item in the bottom sheet displays its counter.
- [ ] When multiple items exist, previous and next arrows beside their neighboring zikr names switch the current item.

### Counter
- [ ] The tasbeeh text appears above a large circular counter without an outer card.
- [ ] The circular counter displays the remaining count when a target exists and shows completion at the target.
- [ ] Tapping the circular counter increases the count.
- [ ] I can count freely without a target.

### Managing tasbeeh items
- [ ] Each tasbeeh item keeps its own independent counter.
- [ ] Counts and targets are still there after closing and reopening the app.
- [ ] The bottom sheet provides item actions to edit or delete a saved tasbeeh.
- [ ] I can edit the target of a tasbeeh item.
- [ ] I can reset the counter from the tasbeeh screen.
- [ ] I can edit my custom tasbeeh items.
- [ ] I can delete my custom tasbeeh items after a confirmation message.

---

## Part 3: Shared counter behavior (reader and tasbeeh)

### Haptic feedback
- [x] Each tap on a counter gives light haptic feedback.
- [x] Completing an item gives a distinct haptic feedback.
- [x] I can turn haptic feedback off.

### Counting with volume buttons (Android and iPhone)
- [ ] There is a setting to count with the volume buttons; it is off by default.
- [ ] When it is on, and a counter screen (reading or tasbeeh) is open with the app in the foreground, pressing volume up adds one count.
- [ ] When it is on, and a counter screen is open with the app in the foreground, pressing volume down subtracts one count.
- [ ] The count never goes below zero.
- [ ] While counting this way, the device volume does not change.
- [ ] When the setting is off, or I leave the counter screens, the volume buttons behave normally.

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
