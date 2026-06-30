# سجل المخالفات المعمارية - وحدة القرآن (features/quran)

تم إعادة فحص وتدقيق كود وحدة القرآن في [lib/features/quran](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/quran) بالكامل وبأقصى درجات التدقيق والتحليل والمقارنة مع المعايير المعمارية للمشروع المحددة في [ARCHITECTURE_RUBRIC.md](file:///d:/flutter/flutter_Projects/muslim_app/architecture_docs/ARCHITECTURE_RUBRIC.md).

أدناه تفصيل شامل لكافة المخالفات المعمارية والبرمجية المرصودة سطرًا بسطر:

---

## 🏗️ 1. المودول 1 و 2 و 3: الأساسيات، تصميم الكائنات ومبادئ SOLID

### 🔍 بند: Separation of Concerns (SoC) - فصل الاهتمامات
* **غياب طبقة الـ Domain بالكامل (Missing Domain Layer):**
  - تفتقر وحدة القرآن لوجود طبقة النطاق (Domain Layer) بالكامل. لا توجد حالات استخدام (Use Cases)، ولا توجد كيانات مستقلة (Entities)، ولا توجد عقود للمستودعات (Repository Contracts) بداخل مجلد خاص بالنطاق. هذا يخالف الهيكل العام للمشروع.
* **مكان واجهة المستودع خاطئ (Broken Layer Interface Location):**
  - تم تعريف واجهة المستودع `IQuranRepo` مباشرة داخل ملف التنفيذ في طبقة البيانات [quran_repo.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/quran/data/repos/quran_repo.dart#L5). وفقًا لمبادئ انعكاس الاعتمادية وفصل الاهتمامات، يجب وضع الواجهات في طبقة الـ Domain، لتقوم طبقة البيانات بتنفيذها وطبقة العرض باستخدامها.

### 🔍 بند: Dependency Inversion & Low Coupling - انعكاس الاعتمادية والاقتران الضعيف
* **اقتران طبقة العرض بطبقة البيانات مباشرة (Presentation Coupling to Data Layer):**
  - في الكيوبيت [quran_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/quran/presentation/cubit/quran_cubit.dart#L2)، يعتمد الكلاس مباشرة على استيراد ملف من مجلد البيانات:
    `import 'package:sana/features/quran/data/repos/quran_repo.dart';`
    وهذا يخرق حدود الطبقات المعمارية (Layer Boundaries) حيث يجب أن تعتمد طبقة العرض على الأبستراكشن في طبقة الـ Domain فقط.
* **الاقتران المباشر بحزم الـ UI الخارجية في طبقة العرض (Direct UI Package Coupling):**
  - في الويدجت [quran_success_widget.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/quran/presentation/widgets/quran_success_widget.dart#L2)، يتم استيراد واستدعاء شاشة مكتبة القرآن الخارجية `import 'package:quran_library/quran.dart' as ql;` مباشرة. هذا يعني عدم وجود تجريد (Abstraction) لواجهة القرآن، مما يجعل التطبيق مقترناً بشكل كامل بهذه الحزمة وصعب استبدالها أو تعديلها مستقبلاً.

### 🔍 بند: Abstraction & Encapsulation - مقارنة وتصميم الكائنات (Object Equality)
* **غياب مقارنة القيم لحالات الكيوبيت (Broken State Equality):**
  - في الملف [quran_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/quran/presentation/cubit/quran_state.dart)، تفتقر جميع الحالات (`QuranInitial`, `QuranLoading`, `QuranSuccess`, `QuranError`) لتعريف مقارنة القيم (`==` و `hashCode`).
  - نظرًا لأن حالة الخطأ `QuranError` تستقبل رسالة ديناميكية، فإن عدم مقارنتها بالقيم سيؤدي إلى اعتبار حالتين متطابقتين كائنات منفصلة في الذاكرة، مما يسبب عمليات إعادة بناء غير ضرورية للواجهات (Unnecessary Rebuilds). يفضل استخدام `Equatable` أو `Freezed` لإدارة مقارنة الحالات وتجنب هذه المشكلة.

---

## 🌟 2. المودول 4 و 5: جودة البرمجيات وقابلية التوسع

### 🔍 بند: Testability - قابلية الاختبار
* **غياب ملفات الاختبار وصعوبة الـ Mocking:**
  - لا توجد أي اختبارات وحدة (Unit Tests) أو اختبارات للواجهة (Widget Tests) لوحدة القرآن.
  - وبسبب اقتران الكيوبيت والمستودع بالمنطق الثابت لتهيئة الحزمة الخارجية `QuranLibrary.init()`، يصعب كتابة اختبارات معزولة أو حقن مستودعات وهمية (Mocking) دون تعديل الكود البرمجي ليدعم التجريد.

### 🔍 بند: Error Handling & Logging - معالجة الأخطاء واللوجر
* **مخالفة معمارية في استخدام معالج أخطاء الشبكة لعمليات محلية (Misplaced Error Handler):**
  - في [quran_repo.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/quran/data/repos/quran_repo.dart#L16), يتم إرسال استثناءات التهيئة الخاصة بالمكتبة المحلية (`QuranLibrary.init()`) إلى دالة `handleApiError(e)`. هذه الدالة مصممة معمارياً لمعالجة أخطاء الشبكة والـ API (مثل HTTP status codes)، واستخدامها لتهيئة مكتبة محلية قد يؤدي لرسائل خطأ مضللة وغير منطقية للمستخدم (مثل "خطأ في الاتصال بالخادم").
* **التقاط ضيق للاستثناءات (Narrow Exception Catching):**
  - في [quran_repo.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/quran/data/repos/quran_repo.dart#L15), يتم التقاط الاستثناءات من نوع `Exception` فقط (`on Exception catch (e)`). أي خطأ من نوع `Error` (مثل `TypeError` أو `AssertionError`) أثناء التهيئة لن يتم التقاطه وسيؤدي لانهيار التطبيق بالكامل دون معالجة.
* **ابتلاع وتجاهل الـ Stack Trace وغياب تسجيل الأخطاء (Missing Error Logging):**
  - عند حدوث خطأ في المستودع [quran_repo.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/quran/data/repos/quran_repo.dart#L15-L17), لا يتم استخدام كائن الـ Stack Trace أو تسجيل التفاصيل باستخدام `AppLogger.error`. هذا يجعل من الصعب جداً تعقب وحل المشاكل التقنية في بيئة التشغيل الفعلية.
* **عدم تسجيل الأخطاء في الكيوبيت (Missing Cubit Error Logging) [Q2]:**
  - عند فشل تهيئة المستودع وإصدار حالة `QuranError` داخل الكيوبيت [quran_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/quran/presentation/cubit/quran_cubit.dart), لا يقوم الـ Cubit باستدعاء `AppLogger.error` لتسجيل الفشل. تسجيل الأخطاء في الـ Repository لا يغني عن توثيق فشل تغيير حالة واجهة المستخدم في الـ Cubit.

### 🔍 بند: Maintainability, DRY & Discoverability - سهولة الصيانة وتكرار الأكواد
* **تكرار وتشتيت الكود البرمجي بإنشاء ملفات ويدجت نحيفة (Widget File Bloat):**
  - يحتوي ملف الويدجت [quran_loading_widget.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/quran/presentation/widgets/quran_loading_widget.dart) على 19 سطرًا فقط، ويحتوي ملف [quran_error_widget.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/quran/presentation/widgets/quran_error_widget.dart) على 25 سطرًا فقط.
  - هاتان الويدجتان هما مجرد غلاف بسيط لكائنات موجودة بالفعل (`CircularProgressIndicator` و `AppErrorView`) داخل `Scaffold`. إنشاء ملفات منفصلة تمامًا لهما يزيد من حجم شجرة الملفات ويقلل المقروئية والوضوح (Discoverability) دون فائدة برمجية. كان من الأفضل كتابتهما مباشرة داخل ملف العرض الرئيسي [quran_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/quran/presentation/views/quran_view.dart) أو تجميعهما.

---

## 📂 3. المودول 6 & 7: تنظيم المشروع ومفاهيم الطبقات

### 🔍 بند: Feature Isolation & Barrel Files - عزل الميزات وملفات التجميع
* **غياب ملف التجميع والتصدير الموحد (No Barrel File):**
  - لا يوجد ملف `index.dart` لتجميع وتصدير كود وحدة القرآن. هذا يجبر الملفات الخارجية (مثل [main_layout_routes.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/main_layout/presentation/routes/main_layout_routes.dart#L8-L9)) على استيراد الملفات الداخلية العميقة مباشرة مثل `quran_cubit.dart` و `quran_view.dart` مما يضعف عزل الميزات (Feature Isolation).
* **غياب مجلد وحقن التبعيات الخاص بالفيتشر (Missing DI Module) [Q3]:**
  - لا توجد هيكلية واضحة لحقن التبعيات (Dependency Injection) خاصة بوحدة القرآن (مثل مجلد `di/` وملف `quran_di.dart`). تسجيل التبعيات مبعثر أو مدمج مع ميزات أخرى، مما يكسر معيار تنظيم الفيتشرات المستقلة.

---

## 🌳 4. المودول 8 & 9: بنية فلاتر وتدفق البيانات (Flutter Internal & Data Flow)

### 🔍 بند: Widget Tree & Scaffold Nesting - تداخل السقالات غير المبرر
* **تداخل الـ Scaffolds وتبديل الهيكل الديناميكي (Nested Scaffolds):**
  - ترجع كل من ويدجت التحميل وويدجت الخطأ كائن `Scaffold` كامل لحسابها الخاص، بينما يتم عرض هذه الويدجتس كأبناء داخل `QuranView` الذي يُعرض بدوره كجزء من التبويبات (Tabs) تحت الـ Shell Navigator لـ `MainLayoutView`.
  - هذا يتسبب في وجود سقالات متداخلة (Nested Scaffolds) وتغيير بنية الواجهة جذريًا عند تبدل الحالة (Loading -> Success) مما يسبب قفزات واهتزازات في التصميم (Layout Jumps). يجب أن تقتصر هذه الويدجتس على إرجاع محتواها فقط دون Scaffold.
* **استخدام غير دقيق لنوع الرد (Semantic ApiResult Mismatch):**
  - واجهة ودوال المستودع `IQuranRepo.initialize()` ترجع نوع `ApiResult<void>` رغم أن التهيئة محلية بالكامل ولا تتضمن أي اتصال بخادم شبكة أو API. هذا خلط في المعنى المعماري لنوع البيانات وكان من الأفضل استخدام نوع إرجاع محلي أو `Result` عام.

### 🔍 بند: Widget Granularity & Rebuild Awareness - نطاق البناء وإعادة الرسم [Q1]
* **نطاق واسع لإعادة البناء (Broad BlocBuilder Scope):**
  - في [quran_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/quran/presentation/views/quran_view.dart), يغلف الـ `BlocBuilder` كامل الشاشة. ونظراً لأن حالات `QuranState` لا تعيد تعريف `==` و `hashCode` (Broken State Equality)، فإن أي استدعاء أو emit لحالة جديدة يؤدي لإعادة بناء كامل الشجرة بما فيها الـ Scaffold والـ AppBar الثابت، مما يؤثر سلباً على أداء التطبيق.

