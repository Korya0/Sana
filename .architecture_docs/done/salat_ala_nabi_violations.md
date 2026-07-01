# تقرير التدقيق المعماري لوحدة الصلاة على النبي (features/salat_ala_nabi)

تم فحص وتدقيق كود وحدة الصلاة على النبي في [lib/features/salat_ala_nabi](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/salat_ala_nabi) بالكامل ومقارنتها مع معايير المشروع المحددة في [ARCHITECTURE_RUBRIC.md](file:///d:/flutter/flutter_Projects/muslim_app/architecture_docs/ARCHITECTURE_RUBRIC.md).

أدناه تفصيل المخالفات المعمارية والبرمجية المرصودة سطرًا بسطر:

---

## 🏗️ 1. المودول 1 و 2 و 3: الأساسيات، تصميم الكائنات ومبادئ SOLID

### 🔍 بند: Separation of Concerns (SoC) - فصل الاهتمامات
* **تسريب طلب الأذونات الأصلية للكيوبيت (UI Native Dialog in Cubit):**
  - في الكلاس [reminder_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/salat_ala_nabi/presentation/cubit/reminder_cubit.dart#L66-L68)، يقوم الكيوبيت باستدعاء غير متزامن لطلب إذن الإشعارات من النظام مباشرة: `await _permissionsManager.requestNotificationPermission()`.
  - طلب أذونات النظام وحوارات التفاعل مع المستخدم هي اهتمامات خاصة بـ UI بالكامل (Presentation View)، ويجب أن يتعامل معها الـ View مباشرة ثم يُبلغ الكيوبيت بالنتيجة، بدلاً من إقحام الكيوبيت في استدعاء حوارات النظام.

### 🔍 بند: Abstraction & Encapsulation - مقارنة وتصميم الكائنات (Object Equality)
* **غياب مقارنة القيم لحالات الكيوبيت (Broken State Equality):**
  - في الملف [reminder_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/salat_ala_nabi/presentation/cubit/reminder_state.dart)، تفتقر فئات الحالات الأولية وحالات التحميل (`ReminderInitial` و `ReminderLoading`) لتعريف مقارنة القيمة المخصصة (`==` و `hashCode`). هذا يعطل منع تحديث الـ Widget بشكل متكرر.

---

## 🌟 2. المودول 4 و 5: جودة البرمجيات وقابلية التوسع

### 🔍 بند: Testability - قابلية الاختبار
* **الاعتماد الصلب على وقت النظام (DateTime.now):**
  - في منفذ مهام الخلفية [salawat_background_executor.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/salat_ala_nabi/data/services/salawat_background_executor.dart#L25)، يتم استدعاء الوقت المباشر للهاتف: `DateTime.now()` للتحقق من أوقات العمل. هذا الاعتماد الصلب يمنع كتابة اختبارات وهمية (Mock Tests) لمهمة الخلفية.
* **الاعتماد على واجهة فلاتر في طبقة الخدمات:**
  - يتم استدعاء `rootBundle` لقراءة ملفات التهيئة في طبقات الخدمات ومصادر البيانات، مما يمنع تشغيل اختبارات Pure Dart دون تشغيل محرك فلاتر بالكامل.
* **إطلاق مهام غير متزامنة غير معالجة في مشيد الكيوبيت:**
  - استدعاء `unawaited(loadSettings())` داخل مشيد `ReminderCubit` مباشرة يضر بقابلية الاختبار وتتبع تدفق انبعاث الحالات.

### 🔍 بند: Localization & Theme - الترجمة المحلية والسمات العامة
* **كبسلة الترجمة صلبًا داخل كلاس البيانات (Model Localization Coupling):**
  - في الكلاس [reminder_settings.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/salat_ala_nabi/data/models/reminder_settings.dart#L100)، يقوم كلاس البيانات بتهيئة نصوص صباحاً/مساءً صلبة مباشرة بالعربية: `final period = hour < 12 ? AppStrings.am : AppStrings.pm;`.
  - النماذج البرمجية للبيانات يجب أن تحمل بيانات خام فقط، وتترك التنسيق وعرض الترجمة لطبقة الـ Presentation والـ UI.

### 🔍 بند: Reusability / DRY - تكرار الكود
* **تهيئة متكررة بلا مبرر لخدمة الإشعارات:**
  - في [salawat_reminder_service.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/salat_ala_nabi/data/services/salawat_reminder_service.dart#L50-L64)، يتم استدعاء `await _notificationService.initialize();` في كل استدعاء لإظهار الإشعارات بدلاً من تهيئتها لمرة واحدة فقط عند تشغيل التطبيق.

---

## 🧱 3. المودول 7 & 6: مفاهيم الطبقات وتنظيم المشروع

### 🔍 بند: Layer Responsibilities - غياب طبقة النطاق (Domain Layer)
* **تخطي طبقة النطاق بالكامل:**
  - تفتقر ميزة الصلاة على النبي تماماً لوجود طبقة نطاق (Domain Layer)، حيث يتم تعريف الواجهات والمستودعات (`IReminderRepository` و `ISalawatReminderService`) والـ Models مباشرة في طبقة البيانات `data/` ويعتمد عليها الكيوبيت مباشرة.
* **غياب ملف التجميع والتصدير الموحد (No Barrel File):**
  - غياب ملف `index.dart` لتصدير واجهات ميزة الصلاة على النبي وتبسيط استدعائها.

---

## 🔎 4. المودول 1 و 8: كوارث معمارية عميقة (أُضيفت بعد الفحص الصارم)

### 🚨 بند: SRP & Fat Cubit - تضخم الكيوبيت ككائن إله (God Object)
* **الكيوبيت يدير التطبيق بدلاً من حالة الواجهة:**
  - الكلاس `ReminderCubit` محمل بمهام تتجاوز وظيفته: يعالج حسابات ساعات العمل (`updateWorkingHoursMode`)، يتحقق من المنصة (`kIsWeb`)، يظهر حوارات وتنبيهات تأكيدية، ويدير خدمات الخلفية مباشرة. كان يجب تفتيت كل هذه المهام إلى `Use Cases` منفصلة.

### 🚨 بند: Separation of Logic - تسريب المنصة (Platform Leakage)
* **تحققات المنصة داخل طبقة العرض:**
  - وجود شرط `if (kIsWeb)` داخل الكيوبيت يكسر تجريد الـ UI. معمارياً، الكيوبيت يجب أن يكون "أعمى" عن نوع المنصة، ويُترك هذا الاختلاف للـ Dependency Injection أو طبقة الـ Service لترجع تنفيذًا فارغًا (Dummy Implementation) على الويب.

### 🚨 بند: Anemic Domain & Data Models - منطق الأعمال داخل نموذج البيانات
* **منطق أعمال وتنسيق UI داخل الـ Model:**
  - الكلاس `ReminderSettingsModel` (وهو مجرد Data Model) يحتوي على دوال منطقية مثل `isWithinWorkingHours()` التي تحسب الأوقات المعقدة وتجاوز منتصف الليل، ودوال تنسيق للنصوص المترجمة مثل `formattedStartTime` التي تستخدم `AppStrings`. نماذج البيانات (Models) يجب أن تقتصر على المتغيرات والـ `fromJson/toJson` فقط، وهذا المنطق يخص الـ Domain Entities و الـ UI.

### 🚨 بند: Magic Numbers - الأرقام السحرية في الخدمات
* **تعريف غير آمن لمعرفات الإشعارات (Notification IDs):**
  - في `SalawatReminderServiceImpl`، يتم حساب معرّف إشعار بشكل مبرمج صلب (Hardcoded Magic Number) هكذا: `AppSalawatConstants.notificationBaseId + 100`. هذا تصرف غير آمن برمجياً وقد يؤدي لتصادم المعرفات مستقبلاً.
