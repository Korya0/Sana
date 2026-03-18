# 🔗 PLUGIN: SHARE INTENTS (OS NATIVE)
> **Version:** 1.0.0 | **Author:** Antigravity (Senior Partner)
> **Target:** Sharing out, or Receiving in from WhatsApp/Gallery.

## 🏛️ CORE PHILOSOPHY
The App does not exist in a vacuum. Users want to export UI as images, text as copy, or intercept links from Twitter specifically to open your app natively.

---

## 🛠️ SHARE-OUT PROTOCOL
- **Library:** `share_plus` (Maintained by Flutter Community).
- **Files vs Text:** If sharing a file (PDF, receipt, downloaded image), you must convert the memory bytes to a physical absolute path via `path_provider` (temporary directory) `XFile(path)` before the OS accepts the share intent.
- **iPad Support:** `share_plus` on iPad crashes instantly if you forget `sharePositionOrigin`. Always provide a `Rect` from a `Builder` context indicating where the pop-over arrow points to.

## 📥 RECEIVE-IN PROTOCOL (SHARE TARGET)
- **Library:** `receive_sharing_intent`.
- **Integration:** This is highly invasive. Android requires modifying `<intent-filter>` inside `MainActivity.xml` targeting `text/plain` or `image/*`. iOS requires adding a Share Extension target in Xcode (written in Swift).
- **Initialization:** Intercept intents inside `main.dart` or your root `MyApp` state, parsing the payload, then passing it to the Router (Group E) and setting the initial App state.
