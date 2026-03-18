# 🧶 PLUGIN: STITCH INTEGRATION RULES
> **Version:** 1.0.0 | **Author:** Antigravity (Senior Partner)
> **Target:** Seamless Integration, ZERO State-Breakage, Theme Respect.

## 🏛️ CORE PHILOSOPHY
"Stitching" is the art of merging new UI into an existing heartbeat. It must be done with surgical precision to avoid "Basmaga" (messy code).

---

## 🛠️ STITCH PROTOCOL (How to Integrate)

### 1. Analysis Before Injection
- **Check Theme:** Before adding any UI, ensure it uses `AppColors` and `AppTextStyles`. Never let hardcoded hex codes leak during a stitch.
- **Identify Target:** Are you stitching a **Full Screen** or a **Small Widget**?
    - *Full Screen:* Create a new feature folder if it doesn't exist.
    - *Widget:* Place in `presentation/widgets/` of the relevant feature.

### 2. The Refactoring Edge
- **Widget Decomposition:** If Stitch produces a giant block, break it down immediately into smaller `const` widgets as per @AI_INSTRUCTIONS.md.
- **Existing Logic:** If the target area has an existing `Cubit`, the new UI must bind to it. Do not create a second Cubit for the same scope.

### 3. RTL & Arabic Support
- **Mirrored Layouts:** Always verify that `Padding`, `Margin`, and `Icons` are RTL-safe (`.start`, `.end`, `Directionality`).
- **Font Uniformity:** Force the use of the `Cairo` font for all text elements during the stitch.

---

## 🚫 ANTI-PATTERNS (STITCH SPECIFICS)
- **Duplicate Styles:** Don't let Stitch create a new `TextStyle` if one already exists in `core/theme/`.
- **Hardcoded Strings:** Replace all plain text in the stitch with `S.of(context)` placeholders or mention it for later localization.
- **Main-Thread Blocking:** If the stitch involves heavy lists, ensure `ListView.builder` is used.

---

## ✅ STITCH VERIFICATION
- [ ] Does the new UI follow the `presentation/` layer structure?
- [ ] Are all dependency registrations (DI) updated if new items were added?
- [ ] Is the spacing consistent with the rest of the app?
- [ ] Did you avoid `Stack(top, left)` for responsive elements?

---

## 🤖 AI INTERACTION TEMPLATE
"استخدم الـ Stitch لدمج هذا التصميم/الكود في الملف [File Path]. 
التزم بـ @stitch_rules.md و @AI_INSTRUCTIONS.md. 
تأكد من استخدام التيم الحالي (Cairo + AppColors) وعدم تكرار اللوجيك."
