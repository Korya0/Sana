# 💳 PLUGIN: STRIPE (MCP) OPERATIONS & RULES
> **Version:** 1.0.0 (MCP-Aware) | **Author:** Antigravity (Senior Partner)
> **Target:** Automated Payments, Invoice Management, Live Pricing Audit.

## 🏛️ CORE PHILOSOPHY
1. **MCP First:** Use `stripe` MCP tools for all resource management (Customers, Products, Prices, Invoices).
2. **Interactive Planning:** Use `stripe_integration_recommender` for the initial architecture of any payment flow.
3. **Currency Integrity:** Always work in "Minor Units" (cents) as required by Stripe tools.

---

## 🛠️ STRIPE MCP PROTOCOL

### Phase 1: Planning & Discovery
- **Recommender Loop:** For new features, call `stripe_integration_recommender` first. Present questions to the user exactly as provided.
- **Resource Audit:** Before creating a new product or price, use `list_products` and `list_prices` to check for duplicates.
- **Account Info:** Run `get_stripe_account_info` once per session to confirm current account status and currency.

### Phase 2: Operations (Safe Mode)
- **Live Search:** Use `search_stripe_resources` with exact syntax (`customers:email:"..."`) to find specific objects.
- **Financial Safety:** Before finalizing an invoice or creating a refund, summarize the details to the user and wait for confirmation.
- **Refund Logic:** Always use `list_refunds` to check if a refund was already processed before creating a new one.

### Phase 3: Documentation & Code
- **Stripe Docs:** Use `search_stripe_documentation` to get code examples for specific SDK implementations (Node/Python/Dart).
- **Webhooks:** If a task involves webhooks, check the Stripe dashboard configuration via documentation first.

---

## 🚫 ANTI-PATTERNS
- **Manual ID Entry:** Guessing customer or product IDs instead of using `list_` or `search_` tools.
- **Floating Point Math:** Using dollars instead of cents in `unit_amount` (Stripe expects integers).
- **Silent Refunds:** Refunding payments without a clear `reason` and user confirmation.

---

## ✅ VERIFICATION CHECKLIST
- [ ] `get_stripe_account_info` matches the intended env (Test/Live)?
- [ ] Product and Price currency matches the target audience?
- [ ] Webhook signatures handled in the proposed code?
- [ ] Error handling for `PaymentIntent` failures implemented?

---

## 🤖 AI INTERACTION TEMPLATE
"استخدم الـ Stripe MCP لإدارة [Task: مثلاً إنشاء اشتراك أو استرجاع مبلغ].
التزم بـ @stripe_rules.md. 
ابدأ بالبحث عن العميل أولاً باستخدام `list_customers`."
