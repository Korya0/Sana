# تقرير التدقيق المعماري لوحدة تعليم الصلاة (features/teaching_prayer)

تم فحص وتدقيق كود وحدة تعليم الصلاة في [lib/features/teaching_prayer](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/teaching_prayer) بالكامل ومقارنتها مع معايير المشروع المحددة في [ARCHITECTURE_RUBRIC.md](file:///d:/flutter/flutter_Projects/muslim_app/architecture_docs/ARCHITECTURE_RUBRIC.md).

أدناه تفصيل المخالفات المعمارية والبرمجية المرصودة سطرًا بسطر:

---

## 🏗️ 1. المودول 1 و 2 و 3: الأساسيات، تصميم الكائنات ومبادئ SOLID

### 🔍 بند: Abstraction & Encapsulation - مقارنة وتصميم الكائنات (Object Equality)
* **غياب مقارنة القيم لحالات الكيوبيت (Broken State Equality):**
  - في الملف [teaching_prayer_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/teaching_prayer/presentation/cubit/teaching_prayer_state.dart)، تفتقر جميع الحالات (`TeachingPrayerInitial`, `TeachingPrayerLoading`, `TeachingPrayerSuccess`, `TeachingPrayerError`) لتعريف مقارنة القيمة (`==` و `hashCode`). هذا يؤدي لإعادة بناء مفرط للواجهات حتى عند تطابق قائمة الأقسام تماماً.
* **غياب المقارنة بنماذج البيانات (Models Equality):**
  - تفتقر جميع فئات البيانات (`TeachingPrayerSectionModel`, `TeachingPrayerTopicModel`, `TeachingPointModel`) لتطبيق المقارنة بالقيم بالرغم من أنها كلاسات بيانات غير قابلة للتغيير وتحمل نصوص التعليمات فقط.

---

## 🌟 2. المودول 4 و 5: جودة البرمجيات وقابلية التوسع

### 🔍 بند: Testability - قابلية الاختبار
* **الاعتماد على واجهة فلاتر في مصادر البيانات (Flutter dependency in Data Source):**
  - في الكلاس [teaching_prayer_local_data_source.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/teaching_prayer/data/datasources/teaching_prayer_local_data_source.dart#L20)، يتم استدعاء `rootBundle.loadString(AppAssets.teachingPrayer)` مباشرة لتحميل البيانات. هذا يربط الكود برمجياً بـ Flutter Asset System ويمنع اختبار الكود في بيئة Pure Dart.

---

## 🧱 3. المودول 7 & 6: مفاهيم الطبقات وتنظيم المشروع

### 🔍 بند: Layer Responsibilities - غياب طبقة النطاق (Domain Layer)
* **تخطي طبقة النطاق تماماً:**
  - تفتقر ميزة تعليم الصلاة بالكامل لوجود طبقة نطاق (Domain Layer)، حيث يتم تعريف الواجهات والمستودعات والـ Models مباشرة في طبقة البيانات `data/` ويعتمد عليها الكيوبيت في طبقة العرض مباشرة.
* **غياب ملف التجميع والتصدير الموحد (No Barrel File):**
  - لا يوجد ملف `index.dart` لتصدير واجهات ميزة تعليم الصلاة وتبسيط الاستدعاءات.

---

## 🔁 4. المودول 11 & 12: نظام التصميم والسمات العامة (Theme & Design)

### 🔍 بند: Localization & Theme - ألوان وتصميم صلب
* **ألوان صلبة تكسر السمات وتناسق الألوان:**
  - في ملف تفاصيل الدرس [teaching_topic_details_bottom_sheet.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/teaching_prayer/presentation/widgets/teaching_topic_details_bottom_sheet.dart):
    - **السطر 54:** استخدام لون حدود صلب `Colors.white10` والذي لا يتناسق مع الوضع الفاتح (Light Mode).
    - **السطر 86:** استخدام تلوين أخضر صلب ومحدد مسبقاً `Colors.green.shade400` لإبراز الكلمات بين القوسين، بدلاً من استدعائه من سمات ألوان التطبيق الموحدة (`context.color.secondary` أو ما شابه).

---

## 🔎 5. المودول 4 و 9: كوارث معمارية عميقة (أُضيفت بعد الفحص الصارم)

### 🚨 بند: Semantic Types - الدلالة الخاطئة للبيانات وأنواع الردود
* **استخدام ApiResult لعمليات فك تشفير محلية (Parsing):**
  - في الملف `teaching_prayer_repo_impl.dart`، تقوم الدالة `getSections()` بطلب البيانات من `_localDataSource` الذي يقرأ ملف JSON محلي. ومع ذلك، يتم تغليف النتيجة بنوع `ApiResult.success()` أو `ApiResult.failure(CacheFailure)`.
  - الخطأ هنا هو استخدام `ApiResult` المخصص حصرياً للشبكات (Network Layer) لعمليات محلية بحتة لا يوجد بها اتصال بالخادم، وكذلك استخدام `CacheFailure` للتعويض عن أخطاء فك التشفير `FormatException` أو الأصول المفقودة `FlutterError`. هذا يعمي نظام التتبع (Error Tracking) عن الخطأ الفعلي.

### 🚨 بند: DRY & Maintainability - التضخم في ملفات الويدجت (Widget File Bloat)
* **إنشاء ملفات كاملة لأغلفة نحيفة (Thin Wrappers):**
  - تم إنشاء ملفين منفصلين: `teaching_prayer_error_widget.dart` و `teaching_prayer_loading_widget.dart`.
  - هذه الملفات تحتوي على 20+ سطر كود فقط لتقوم في النهاية بإرجاع `AppErrorView` و `CircularProgressIndicator` بشكل مباشر دون أي منطق إضافي. هذا النمط يزيد من تعقيد شجرة الملفات (File Tree) ويقلل من قابلية الصيانة دون أي فائدة حقيقية. يجب تجميعهما داخل ملف الـ View أو ملف تجميعي للـ States.

### 🚨 بند: SRP & Model Parsing - كلاس بيانات إلهي يحمل منطق الأعمال
* **عمليات فك التشفير والـ Regex داخل مشيد البيانات (Data Model):**
  - الكلاس `TeachingPrayerTopicModel` يقوم باستدعاء صريح ومباشر لـ `TeachingContentParser.parseContent(content)` بداخل الدالة `fromJson()`.
  - هذه كارثة معمارية (God Model) تكسر الـ SRP بامتياز. دوال الـ `fromJson` يجب أن تقتصر على تمرير المفاتيح (Mapping) فقط. عمليات معالجة النصوص (String parsing) وتشغيل الـ Regular Expressions لاستخراج النقاط يجب أن تتم في الـ Repository أو في (Use Case) مخصص. حشرها داخل הـ Model يجعل اختباره وعزله مستحيلاً.

### 🚨 بند: Presentation leaking Domain Logic - تسريب منطق الأعمال للواجهة
* **معالجة النصوص النحوية والألوان داخل شجرة بناء الواجهة:**
  - في الكلاس `TeachingTopicDetailsBottomSheet` (ملف UI بحت)، توجد الدالة `_buildHighlightedSpans` التي تستخدم كود Regex صلب `RegExp(r'\(.*?\)')` للبحث عن الكلمات بين الأقواس وتلوينها بالأخضر داخل دالة الـ `build`.
  - هذا خرق صريح لفصل الاهتمامات. منطق تحليل النص وتمييز الكلمات الهامة (Domain Logic) يجب ألا ينفذ ديناميكياً داخل شجرة بناء الواجهة في كل إطار (Frame). كان ينبغي معالجته مسبقاً في الـ Cubit أو الـ Use Case وإرجاعه كقائمة من الـ (Tokens/Spans) الجاهزة ليقوم الـ UI برسمها فقط (Dumb View).
