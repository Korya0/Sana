# 🏗️ CLEAN ARCHITECTURE & STATE MANAGEMENT

## Layer Boundaries
```
Presentation  →  Domain  →  Data
     ↑                         ↑
  (Observes state)       (Implements repos)
```

| Layer | Owns | Forbidden |
|---|---|---|
| **Presentation** | UI, Cubit/Bloc, State | Business logic, direct Repo access |
| **Domain** | Use Cases, Entities, Repo Interfaces | Networking models, DB drivers |
| **Data** | Repo implementations, API clients, DTOs | UI logic, Domain logic |

### 🎯 State Management — Cubit (Default)
- **Cubit** is the default. Use full BLoC only for complex event streams.
- **Sealed classes** for states (Dart 3.x), NOT Freezed unions.
- Exhaustive `switch` in UI. No `if (state is X)` chains.
- Coordinate between Cubits via **Use Cases**, never Cubit-to-Cubit calls.

### 💉 Dependency Injection — GetIt
- **Constructor injection** always. Never call `getIt<X>()` inside business logic.
- Use `lazySingleton` for services/repos, `factory` for Cubits.
- Use `DIHelper.registerFeature()` for standard features. For multi-source features (Remote + Local), register explicitly.

### 🌐 Networking & Data
- **ApiResult Boundary:** For simple CRUD, `ApiResult<T>` can be used in Cubit. For complex logic, map to a Domain Result.
- **No silent failures:** Every error path must be handled. No swallowed exceptions.
- **Entities vs DTOs:** Keep clear separation. Destination views fetch entities by ID from params.

## 📚 Global Template Reference
> **AI Instruction:** Before creating any new feature, cubit, or repository, you MUST first check the central template library.
- **Library Path:** `d:/flutter/flutter_standard_library/Templates/`
- **Action:** If a relevant template exists in `Architecture_Templates/` or `template_catalog.md`, read it first, then adapt it to the current project's context.
- **Consistency:** Use the template structure as the base to ensure project consistency.
