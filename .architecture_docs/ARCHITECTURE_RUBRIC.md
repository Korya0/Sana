
# Sana App - Architecture & Code Review Rubric

This document is the comprehensive checklist for reviewing any feature in the Sana app. It contains **ALL** architectural topics to ensure 100% compliance with our standards.

---

## 🏗️ Module 1 & 2 & 3: Fundamentals, Object Design, & SOLID
- [ ] **Separation of Concerns (SoC):** Is the UI strictly separated from business logic?
- [ ] **High Cohesion & Low Coupling:** Are related items grouped together? Are dependencies injected?
- [ ] **Abstraction & Encapsulation:** Are internal details hidden behind clean APIs?
- [ ] **Modularity:** Can this part be isolated?
- [ ] **Single Responsibility Principle (SRP):** Does this class/widget have only one reason to change?

---

## 🌟 Module 4 & 5: Software Quality & Scalability
- [ ] **Maintainability & Flexibility:** Is the code easy to read and change?
- [ ] **Extensibility:** Can we add new features without modifying existing code (Open/Closed)?
- [ ] **Reusability:** Are we reusing code instead of duplicating?
- [ ] **Testability:** Can we easily write unit tests for this (e.g., passing injected dependencies)?
- [ ] **Predictability:** Does the state flow predictably without side-effects?
- [ ] **Scalability:** Will this code survive if the app grows 10x larger?

---

## 📂 Module 6: Flutter Project Organization (Section 3 & 8 in your list)
- [ ] **Feature-based Structure:** Is the feature isolated in `lib/features/`?
- [ ] **Core/Shared Modules:** Are common utilities placed in `lib/core/`?
- [ ] **Feature Isolation:** Is the feature independent of other features?
- [ ] **Naming Conventions:** Are Folders, Files, and Classes named consistently?
- [ ] **Barrel Files & Export Strategy:** Are we using `index.dart` or export files correctly to clean up imports?

---

## 🧱 Module 7: Layering Concepts (Section 4)
- [ ] **Layer Responsibilities & Boundaries:** Is the boundary between `data`, `domain` (if exists), and `presentation` respected?
- [ ] **Dependency Direction:** Does `presentation` depend on `data`, but not vice-versa?
- [ ] **Layer Communication:** Do layers communicate through defined Interfaces/Abstractions?

---

## 🌳 Module 8: Flutter Internal Architecture (Section 5)
- [ ] **Widget / Element / Render Tree Awareness:** Are we avoiding unnecessary deep trees? 
- [ ] **BuildContext Usage:** Is `context` used safely (especially across async gaps)?
- [ ] **Widget Lifecycle:** Are `initState` and `dispose` managed correctly without memory leaks?
- [ ] **Rebuild Process:** Are we preventing unnecessary paints/layouts?

---

## 🔄 Module 9: Data & Communication Flow (Section 6)
- [ ] **Unidirectional Data Flow:** UI -> Event -> Cubit -> State -> UI Rebuild?
- [ ] **Request/Response Flow:** Is the API flow clean (Request -> Repo -> ApiResult)?
- [ ] **State Flow:** Is the state clearly modeled (e.g., using Freezed or sealed classes)?

---

## 🧩 Module 10: Widget Composition (Section 7)
- [ ] **Composition over Inheritance:** Are we composing small widgets rather than inheriting?
- [ ] **Smart vs Dumb Widgets:** Are UI components (Dumb) separated from logic components (Smart)?
- [ ] **Container vs Presentation Components:** Are layouts separated from styling?

---

## 🔁 Module 11: Reusability & Design System (Section 9)
- [ ] **Shared Widgets:** Does this feature use `core/common/widgets`?
- [ ] **UI Consistency:** Does it match the app's overall Design System?

---

## ⚙️ Module 12: Cross-Cutting Concerns (Section 11)
- [ ] **Configuration & Environment Separation:** Are API keys/URLs properly managed?
- [ ] **Logging:** Is `AppLogger` used for debugging instead of `print`?
- [ ] **Error Handling:** Are exceptions mapped to user-friendly messages?
- [ ] **Localization & Theme:** Are `context.color` and `AppStrings` used?

---

## 🚀 Module 13: Performance-Oriented Architecture (Section 12)
- [ ] **Widget Granularity:** Are `BlocBuilder`s placed as deep in the tree as possible?
- [ ] **Rebuild Awareness:** Are `const` constructors used everywhere possible?
- [ ] **Lazy Initialization:** Are heavy dependencies loaded lazily (e.g., `get_it` lazy singletons)?

---

## 📊 Module 14: Final Architecture Evaluation (Section 13)
- [ ] **Readability, Simplicity, & Discoverability:** Is it clean, pragmatic, and easy to find?
