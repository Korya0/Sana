# 🤖 Antigravity Smart System (v1.2.1)

Welcome to your **Portable Engineering Hub**. This directory `.agents` contains the logic, rules, and workflows that transform Antigravity into a Senior Flutter/Dart Architect for this workspace.

---

## 📂 Directory Structure

### 1. `rules/`
This is the "Brain" of the system.
- `00_identity.md`: Defines the Senior Partner mindset and "No Basmaga" philosophy.
- `01_architecture.md`: Strict Clean Architecture & State Management (Cubit/GetIt) rules.
- `02_dart_flutter_best_practices.md`: Performance, Security, and 2026 Flutter standards.
- `03_verification_ops.md`: Guidelines for testing, PR generation, and tool usage.
- `plugins/`: Optional rules for external services (Firebase, Stripe, etc.).

### 2. `workflows/`
Contains executable processes.
- `/start-mission`: The primary command to begin any task. It forces the creation of `MISSION_EXPLANATION.md` for senior-level justification before coding.

### 3. `PROJECT_CONTEXT_TEMPLATE.md`
The blueprint for any new project. Copy this to the root and rename it to `PROJECT_CONTEXT.md` to define business logic and roadmap.

---

## 🚀 How to move to a NEW Project?

1. **Copy `.agents` Folder**: Simply copy this entire `.agents` directory to the root of your new project.
2. **Set Context**: Copy `.agents/PROJECT_CONTEXT_TEMPLATE.md` to the root, rename it to `PROJECT_CONTEXT.md`, and fill in the project details.
3. **Run `/start-mission`**: That's it! I will now act according to these rules in the new workspace.

---

## 📦 What about the global `Templates` folder?

You **do NOT** need to carry the `Templates` folder with you for every project. Here is how it works:

1. **The Central Vault**: Keep your `Templates` folder in its current central location (e.g., `d:/flutter/flutter_standard_library/Templates`).
2. **Cross-Project Access**: When working on *any* new project, you can simply tell me:
   > *"Grab the 'Auth Cubit' template from the library project and apply it here."*
3. **The Transformation**: I will read the template from the central path, and then use the local `.agents/rules` in your project to "upgrade" and "adapt" that template to the current project's context.

---

## 🛠️ Commands Summary
| Command | Result |
|---|---|
| `/start-mission` | Analyzes, Plans, and Documents the task before implementation. |
| `Generate PR` | Creates a Senior-level Pull Request summary. |

---

> **Note:** Every line of code written under this system must be justified (WHY, WHY, HOW) with a trade-off analysis (Pros vs Cons).
