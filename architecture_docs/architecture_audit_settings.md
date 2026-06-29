# تقرير التدقيق المعماري لوحدة الإعدادات (features/settings)

تم فحص وتدقيق كود وحدة الإعدادات في [lib/features/settings](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/settings) بالكامل ومقارنتها مع معايير المشروع المحددة في [ARCHITECTURE_RUBRIC.md](file:///d:/flutter/flutter_Projects/muslim_app/architecture_docs/ARCHITECTURE_RUBRIC.md).

أدناه تفصيل المخالفات المعمارية والبرمجية المرصودة سطرًا بسطر:

---

## 🏗️ 1. المودول 6: تنظيم مشروع فلاتر (Flutter Project Organization)

### 🔍 بند: Feature Isolation - استقلالية الميزات
* **كسر الاستقلالية والاستيراد من ميزة أخرى (Feature Coupling):**
  - في الملف [settings_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/settings/presentation/views/settings_view.dart#L18)، تعتمد ميزة الإعدادات بشكل مباشر ومقترن على ميزة الـ `home` عبر استيراد واستدعاء مربع الحوار السري لإدخال رمز المرور:
    `import 'package:sana/features/home/presentation/widgets/secret_pin_dialog.dart';`
  - هذا الاقتران المباشر يخرق استقلالية ميزة الإعدادات، ويمنع فصل ميزة الـ `home` أو إعادة هيكلتها برمجياً دون إعطاب ميزة الإعدادات.

### 🔍 بند: Barrel Files & Export Strategy - ملفات التجميع والتصدير
* **غياب ملف التجميع والتصدير الموحد (No Barrel File):**
  - لا يوجد ملف `index.dart` لتصدير واجهة شاشة الإعدادات وتنظيف مسار الاستيراد لها.

---

## 🧱 2. المودول 1 & 7: هيكل الطبقات (Layering Concepts)
* **غياب كامل لهيكل الميزة القياسي:**
  - الميزة تحتوي فقط على ملف واجهة مستخدم وحيد (SettingsView) ولا تحتوي على طبقات `data` أو `domain` أو مجلد للـ `widgets` التابعة لها، بالرغم من أنه مقبول كونه لا توجد قاعدة بيانات مخصصة للإعدادات (حيث تعتمد على خدمات الـ core والـ theme مباشرة)، إلا أن هيكلتها القياسية كـ feature تظل منقوصة.

---

## 🔎 3. المودول 1 و 8: كوارث معمارية عميقة (أُضيفت بعد الفحص الصارم)

### 🚨 بند: SRP & God Widget - واجهة متضخمة تدير منطق الأعمال
* **استدعاء خدمات خارجية مباشرة من الـ UI:**
  - واجهة `SettingsView` مسؤولة مباشرة عن إطلاق روابط خارجية عبر `url_launcher` (دالة `_launchURL`) واستدعاء نوافذ المشاركة عبر `SharePlus.instance.share`.
  - الواجهة (View) يجب أن تكون "غبية" (Dumb View) وتقتصر مسؤوليتها على رسم العناصر. استدعاء خدمات خارجية كالمشاركة أو المتصفح يجب أن يدار عبر (Intent Services) أو على الأقل عبر Cubit يطلق Side Effects (مثل `SettingsActionState`) للحفاظ على النظافة المعمارية وقابلية الاختبار.

### 🚨 بند: Separation of Logic - تسريب المنصة وخلطها بالواجهة (Platform Leakage)
* **تحققات المنصة داخل شجرة بناء الواجهة:**
  - الـ `build` يحتوي على تحققات صريحة للمنصة `if (!kIsWeb)` لإخفاء زر التقييم، بالإضافة لشروط مبنية على `kIsWeb` لتغيير نص المشاركة `shareText`.
  - هذه الشروط تخرق التجريد؛ يجب أن يُحقن الاختلاف المنصي عبر الـ Dependency Injection أو من خلال State يُرسلها الـ Cubit، بدلاً من تلويث شجرة الـ UI بشروط المنصة.

### 🚨 بند: Theme & Hardcoding - الألوان الصلبة
* **برمجة ألوان صلبة خارج نظام السمات:**
  - في السطر 119 يتم استخدام لون صلب `Color(0xFF1877F2)` لأيقونة فيسبوك. جميع الألوان، حتى الخاصة بالعلامات التجارية، يُفضل إدارتها عبر `AppColors` أو تمديد نظام الـ Theme (`ThemeExtension`) لضمان التناسق.
