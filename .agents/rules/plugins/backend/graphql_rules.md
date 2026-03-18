# 🌐 PLUGIN: GRAPHQL CLIENT RULES
> **Version:** 1.0.0 | **Author:** Antigravity (Senior Partner)
> **Target:** GraphQL API integration with Flutter using `graphql_flutter` or `ferry`.

## 🏛️ CORE PHILOSOPHY
1. **GraphQL ≠ REST:** GraphQL is a fundamentally different paradigm. Do NOT force REST patterns (Retrofit, Dio interceptors) onto GraphQL operations.
2. **Schema-First:** Always read the GraphQL schema before writing queries. Use introspection or the `.graphql` schema file.
3. **Type Safety:** Prefer code-generated types from schema (via `ferry` or `graphql_codegen`) over raw `Map<String, dynamic>`.

---

## 📦 RECOMMENDED STACK

| Role | Package | Notes |
|------|---------|-------|
| **Client (Simple)** | `graphql_flutter` | Widget-based (Query/Mutation widgets). Good for simple apps. |
| **Client (Advanced)** | `ferry` | Stream-based, code-gen, normalized cache. For production-grade apps. |
| **Code Generation** | `graphql_codegen` or `ferry_generator` | Generates typed request/response classes from `.graphql` files. |
| **Auth** | Custom `AuthLink` | Injects Bearer token into every GraphQL request, similar to REST auth interceptor. |

### Decision Guide
- **< 10 queries, simple CRUD** → `graphql_flutter` (less setup)
- **Complex app, subscriptions, normalized cache** → `ferry` (more robust)

---

## 🏗️ ARCHITECTURE ALIGNMENT

GraphQL integrates into Clean Architecture at the **Data Layer only**:

```
Presentation  →  Domain  →  Data
                              ↑
                         GraphQL Client
                         (replaces Retrofit)
```

| Component | REST (Dio/Retrofit) | GraphQL Equivalent |
|-----------|--------------------|--------------------|
| API Service | `@RestApi` class | `.graphql` operation files + generated types |
| HTTP Client | `Dio` | `GraphQLClient` / `Ferry Client` |
| Auth Interceptor | `Dio Interceptor` | `AuthLink` in link chain |
| Caching | `dio_http_cache` | `GraphQLCache` / Ferry normalized cache |
| Error Handling | `DioException` → `ApiErrorHandler` | `OperationException` → `GraphQLErrorHandler` |

### Key Rules
- **Domain layer stays pure.** No `graphql` imports in Domain.
- **Repository** receives GraphQL response → maps to Domain Entity (same as REST).
- **Entities** are identical whether data comes from REST or GraphQL.
- **Cubit** doesn't know or care if the data source is REST or GraphQL.

---

## 🔄 GRAPHQL OPERATIONS STRUCTURE

```
lib/features/<feature>/data/
├── graphql/
│   ├── queries/
│   │   └── get_user.graphql        # Query operations
│   ├── mutations/
│   │   └── update_user.graphql     # Mutation operations
│   └── subscriptions/
│       └── on_message.graphql      # Subscription operations (real-time)
├── models/
│   └── user_dto.dart               # Generated or manual DTOs
├── sources/
│   └── user_graphql_source.dart    # Wraps GraphQL client calls
└── repos/
    └── user_repository.dart        # Maps DTOs → Entities
```

---

## ⚡ SUBSCRIPTIONS (Real-Time)

GraphQL Subscriptions replace WebSockets for real-time features:
```dart
// ✅ Use GraphQL Subscription for real-time
final subscription = client.subscribe(OnMessageSubscription());

// ❌ Don't mix raw WebSocket with GraphQL — use the GraphQL subscription system
```

- Subscriptions handled via `WebSocketLink` in the client link chain.
- Auto-reconnect on disconnect.
- Cubit listens to subscription stream (see Cubit template B6).

---

## 🚫 ANTI-PATTERNS

| Anti-Pattern | Rule |
|---|---|
| **Forcing Dio on GraphQL** | GraphQL has its own client. Don't route through Dio. |
| **Raw `Map<String, dynamic>`** | Use code-generated types. Raw maps lose type safety. |
| **Queries in Dart strings** | Keep `.graphql` files separate. Enables tooling + syntax highlighting. |
| **Over-fetching** | GraphQL's purpose is to fetch only what you need. Don't `select *`. |
| **Ignoring cache policies** | Use `CachePolicy.cacheFirst` for static data, `networkOnly` for real-time. |
| **Subscriptions without cleanup** | Always cancel subscription streams in Cubit `close()`. |

---

## ✅ VERIFICATION CHECKLIST
- [ ] GraphQL schema file (`.graphql`) available and up-to-date?
- [ ] Code-generated types match schema version?
- [ ] `AuthLink` injects token correctly (check with GraphQL playground)?
- [ ] Error handling maps `OperationException` → structured error?
- [ ] Subscriptions auto-reconnect on network change?
- [ ] Domain layer has zero `graphql` package imports?

---

## 🤖 AI INTERACTION TEMPLATE
"المشروع يستخدم GraphQL بدلاً من REST.
التزم بـ @graphql_rules.md.
استخدم [graphql_flutter / ferry] حسب تعقيد المشروع.
تأكد أن الـ Domain Layer نظيف من أي imports خاصة بـ GraphQL."
