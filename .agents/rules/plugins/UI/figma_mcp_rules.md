# 🎨 PLUGIN: FIGMA-TO-FLUTTER (MCP) CONVERSION RULES
> **Version:** 1.0.0 | **Author:** Antigravity (Senior Partner)
> **Target:** 100% Accuracy, Clean Architecture, No Basmaga.

## 🏛️ CORE PHILOSOPHY
1. **Design as Code:** Figma is the source of truth for UI, but `lib/core/theme/` is the implementation of that truth. Never hardcode values.
2. **Component Integrity:** Match Figma "Components" to Flutter "Atomic Widgets".
3. **RTL Priority:** Given the Arabic context (Cairo font), all layouts must be inspected for RTL compatibility (use `Directionality`, `start/end` instead of `left/right`).

---

## 🛠️ CONVERSION PROTOCOL (Step-by-Step)

### Phase 1: Token Extraction (The Foundation)
- **Colors:** Scan for hex codes. Map them to `AppColors` class in `core/theme/app_colors.dart`.
- **Typography:** Map Figma Text Styles (Headline, Body, etc.) to `AppTextStyles` using `google_fonts` (Cairo).
- **Spacing:** Identify consistent padding/margin patterns and define a `Spacing` constant class if needed.

### Phase 2: Frame-to-Screen Mapping
- **Identify Scopes:** Differentiate between "Mobile App Screens" and "Admin Dashboards".
- **Modularization:** Each major Figma Page (Canvas) should correspond to a feature module in `lib/features/`.
- **Screen Scaffolding:** Use `StandardScreen` or `BaseScaffold` to ensure consistent app-wide behavior (Status bars, safe areas).

### Phase 3: The "No Basmaga" Code Generation
- **Atomic Widgets:** Don't build one giant 500-line screen. Break the Figma Frame into smaller `presentation/widgets/`.
- **Logic Isolation:** UI must only observe state from a `Cubit`. Zero business logic in extracted UI code.
- **Image Assets:** Use `generate_image` tool to create quality placeholders/assets if Figma exports are unavailable.

---

## 🚫 ANTI-PATTERNS (FIGMA SPECIFICS)
- **Absolute Positioning:** Never use `Stack` with hardcoded `top/left` for everything. Use `Column`, `Row`, and `Flex` for responsive layout.
- **Fixed Widths:** Avoid `width: 375`. Use `MediaQuery`, `LayoutBuilder`, or `Flexible/Expanded`.
- **Nested Stack Sprawl:** If a UI can be done with a `ListView` or `Wrap`, do not use a `Stack`.

---

## ✅ VERIFICATION CHECKLIST
- [ ] Colors match `AppColors` exactly?
- [ ] Font is `Cairo` with the correct weights (300-900)?
- [ ] RTL issues checked (Padding-start, icons flipped)?
- [ ] No hardcoded strings (Use localization placeholders if configured)?
- [ ] State management (Cubit) ready to be plugged into the UI?

---

## 🤖 AI INTERACTION TEMPLATE
"استخدم الـ Figma MCP لتحويل الشاشة [Name] باتباع سياق @figma_mcp_rules.md. 
1. استخرج التوكنز أولاً.
2. قسم الشاشة إلى Component Widgets.
3. التزم بـ Clean Architecture (Presentation Layer فقط)."
