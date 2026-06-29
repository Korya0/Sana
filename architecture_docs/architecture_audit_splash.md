# تقرير التدقيق المعماري لوحدة شاشة البداية (features/splash)

تم فحص وتدقيق كود وحدة شاشة البداية في [lib/features/splash](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/splash) بالكامل ومقارنتها مع معايير المشروع المحددة في [ARCHITECTURE_RUBRIC.md](file:///d:/flutter/flutter_Projects/muslim_app/architecture_docs/ARCHITECTURE_RUBRIC.md).

أدناه تفصيل المخالفات المعمارية والبرمجية المرصودة سطرًا بسطر:

---

## 🏗️ 1. المودول 6: تنظيم مشروع فلاتر (Flutter Project Organization)

### 🔍 بند: Barrel Files & Export Strategy - ملفات التجميع والتصدير
* **غياب ملف التجميع والتصدير الموحد (No Barrel File):**
  - لا يوجد ملف `index.dart` لتصدير واجهات ميزة شاشة البداية وتبسيط عمليات الاستيراد لها من الخارج.

---

## 🧱 2. المودول 1 & 7: هيكل الطبقات (Layering Concepts)
* **غياب الهيكل المعماري القياسي:**
  - تحتوي الميزة فقط على ملفين (`splash_routes.dart` و `splash_view.dart`) وتفتقر لوجود طبقة بيانات أو نطاق لعدم وجود معطيات تحتاج للتخزين أو المعالجة، إلا أن تقسيمها يظل منقوصاً معمارياً مقارنة بباقي الـ features.
  - تلتزم شاشة البداية بفصل جيد للمسؤوليات حيث تعتمد بالكامل على حزم الـ core للـ `LocationGuard` ولا تقحم أي عمليات مباشرة غير متوقعة للـ GPS بداخلها.

---

## 🔎 3. المودول 1 و 8: المخالفات العميقة المنسية (بعد الفحص الصارم)

### 🚨 بند: Single Responsibility Principle (SRP) - تفنيد الملاحظة السابقة
* **الاقتران العنيف بوحدة التموقع (LocationGuard Coupling):**
  - الملاحظة السابقة اعتبرت استخدام `LocationGuard` أمراً جيداً، لكن من منظور (Clean Architecture) الصارم، زرع ويدجت التموقع كأب مباشر لـ `SplashView` يخرق مبدأ المسؤولية الواحدة.
  - وظيفة شاشة البداية (Splash) تقتصر فقط على الجانب المرئي (Branding) وتهيئة التطبيق العامة (App Initialization). حشر منطق الصلاحيات داخل الـ UI الخاص بالشاشة يجعلها مقترنة تماماً بالمكان، وكان يجب إدارة الصلاحيات خارجياً عبر `AppInitCubit` أو حارس توجيه (Router Guard).

### 🚨 بند: State & Routing - منطق توجيه مدفون صلبًا
* **التوجيه المبرمج داخل StatefulWidget:**
  - التوقيت الزمني `Future.delayed(2 seconds)` والتوجيه `context.goNamed(AppRoutes.home)` مخفيان ومبرمجان بالصلب (Hardcoded) داخل الكلاس الداخلي السري `_NavigateToHomeState`.
  - هذا النمط يكسر مبادئ التوجيه الحديث (State-Driven Navigation). الانتقال بعد الـ Splash يجب أن يعتمد على استماع لـ State من مدير حالة (BlocListener) يفيد بانتهاء التهيئة، وليس على مؤقت زمني اعتباطي مدفون داخل الـ View.
