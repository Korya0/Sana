# 🔥 PLUGIN: FIREBASE (MCP) OPERATIONS & RULES
> **Version:** 2.0.0 (MCP-Aware) | **Author:** Antigravity (Senior Partner)
> **Target:** Automated Setup, Live Database Queries, Proactive Debugging.

## 🏛️ CORE PHILOSOPHY
1. **MCP First:** Use `firebase-mcp-server` tools for all infrastructure tasks (Init, Project management, App creation).
2. **Exploration over Assumptions:** Use `firestore_list_collections` and `firestore_get_documents` to understand the database schema before writing queries.
3. **Data Security:** Always validate `firebase_get_security_rules` before proposing data modeling changes.

---

## 🛠️ FIREBASE MCP PROTOCOL

### Phase 1: Environment & Setup
- **Env Check:** Always run `firebase_get_environment` to ensure we are in the correct project.
- **Auto-Init:** Use `firebase_init` to set up services (Auth, Firestore, Hosting) instead of manual file creation.
- **Config Sync:** Use `firebase_get_sdk_config` to get the latest credentials for Flutter configuration.

### Phase 2: Live Data & Debugging
- **Firestore Queries:** Use `firestore_query_collection` for verification. Never "guess" if data exists.
- **Crashlytics Audit:** When a bug is reported, use `crashlytics_get_top_issues` to find the root cause programmatically.
- **User Management:** Use `auth_get_users` to verify user states or custom claims during development.

### Phase 3: Deployment & Rules
- **Rule Validation:** Use `firebase_validate_security_rules` before any deployment.
- **Smart Deploy:** Use `firebase:deploy` prompt for CI/CD triggered from the chat.

---

## 🚫 ANTI-PATTERNS
- **Manual Config:** Hardcoding Firebase options instead of using `firebase_get_sdk_config`.
- **Blind Debugging:** Fixing issues without checking `functions_get_logs` or `crashlytics_list_events`.
- **Inconsistent Schema:** Adding Firestore documents that don't match the existing collection patterns (Check the schema first!).

---

## ✅ VERIFICATION CHECKLIST
- [ ] `firebase_get_environment` matches the target (Dev/Prod)?
- [ ] Security rules validated via `firebase_get_security_rules`?
- [ ] Firestore models aligned with existing collection data?
- [ ] `Crashlytics` initialization confirmed via live logs?

---

## 🤖 AI INTERACTION TEMPLATE
"استخدم الـ Firebase MCP لـ [Task: مثلاً تهيئة المشروع أو فحص الكراشات].
التزم بـ @firebase_rules.md. 
قم بفحص البيئة الحالية أولاً باستخدام `firebase_get_environment`."
