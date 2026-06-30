# سجل المخالفات المعمارية - قسم التاريخ (App Date)

هذا الملف يحتوي على قائمة بالمخالفات المعمارية في قسم `app_date` مقارنة بالمعايير الموجودة في `ARCHITECTURE_RUBRIC.md`. 
تم تسجيل هذه الملاحظات للمراجعة فقط دون تطبيق الحلول.

> [!IMPORTANT]
> **تحديث معماري هام (قاعدة جديدة يجب الالتزام بها):**
> تم إنشاء كلاس `FailureMapper` في المسار `lib/core/error/failure_mapper.dart`.
> **يُمنع منعاً باتاً** استيراد أو استخدام `AppStrings` أو أي نصوص واجهة (UI Strings) داخل أي `Repository` أو داخل طبقة الـ Data بشكل عام.
> - الـ `Repository` يجب أن يُرجع أنواع الأخطاء التقنية الموروثة من `Failure` (مثل `CacheFailure` أو `NetworkFailure`).
> - يقوم الـ `Cubit` (أو الـ UI) لاحقاً بتحويل هذا الخطأ إلى نص مناسب للمستخدم باستخدام الدالة `FailureMapper.mapFailureToMessage(failure)`.
> تم اتخاذ هذا القرار للحفاظ على استقلالية طبقة البيانات (Clean Architecture) ولتحقيق الأمان وقت الترجمة (Compile-time Safety) باستخدام (Sealed Classes & Exhaustive Switch).

## 1. طبقة البيانات (Data Layer) وفصل الاهتمامات (Separation of Concerns)
- ✅ **[تم الإصلاح] استيراد نصوص واجهة المستخدم في الـ Repository:** 
  - *الملف:* `app_date_repository.dart`
  - *المشكلة:* يتم استخدام `AppStrings.hijriAdjustmentSaveError` و `AppStrings.hijriMonthSaveError`. طبقة البيانات يجب ألا تعتمد أبداً على طبقة العرض (Presentation) أو ملفات الترجمة. يجب أن يُرجع الـ Repository خطأ (Failure) عام، ويقوم الـ Cubit أو واجهة المستخدم بتحويله إلى رسالة مترجمة. *(يخالف: Layer Responsibilities & Boundaries)*.
- ✅ **[تم الإصلاح] تضمين منطق الأعمال (Business Logic) في طبقة البيانات:** 
  - *الملف:* `app_date_repository.dart`
  - *المشكلة:* دالة `getVerificationMonths` التي ترجع الأشهر `[9, 11, 12]` موجودة في الـ Repository. مسؤوليته فقط جلب وحفظ البيانات، أما قاعدة "ماهي الأشهر التي تتطلب التحقق؟" فهي "منطق أعمال" ويجب أن تكون في الـ Cubit أو في طبقة الـ Domain. *(يخالف: Layer Responsibilities)*.
- ✅ **[تم الإصلاح] تسمية `ApiResult` بحاجة لتعديل:** 
  - *القرار المعماري:* لتجنب الالتباس في استخدام `ApiResult` لعمليات التخزين المحلي والشبكة معاً، سيتم تغيير اسمه إلى `Result` ليكون عاماً لجميع العمليات في التطبيق بدون الاعتماد على مكتبات خارجية.

## 2. معالجة الأخطاء (Error Handling)
- ✅ **[تم الإصلاح] ابتلاع الأخطاء وعدم إظهارها للمستخدم (Swallowing Errors):** 
  - *الملف:* `app_date_cubit.dart`
  - *المشكلة:* عند حدوث خطأ في دوال مثل `setAdjustment` أو `confirmVerification`، يتم التقاط الخطأ وتسجيله فقط باستخدام `AppLogger.error`، **ولا يتم إرسال أي حالة خطأ (Error State)** للواجهة. للمستخدم لن يعلم بحدوث مشكلة عند فشل الإجراء. *(يخالف: Are exceptions mapped to user-friendly messages?)*.

## 3. التواصل بين الطبقات (Layer Boundaries & Dependency Inversion)
- ✅ **[تم الإصلاح] مكان الـ Interface خاطئ:** 
  - *الملف:* `i_app_date_repository.dart`
  - *المشكلة:* موجود داخل مجلد `data/repositories`. وفقاً لمبادئ انعكاس الاعتمادية، يجب أن تتواجد الـ Interfaces في طبقة الـ Domain، حتى تعتمد طبقة הـ Data عليها لتنفيذها، وتعتمد طبقة הـ Presentation عليها لاستخدامها دون اقتران قوي بمجلد الـ Data. *(يخالف: Layer Communication)*.

## 4. تدفق البيانات (Unidirectional Data Flow)
- **تغيير الحالة من داخل الـ Listener (Chained State Update):** 
  - *الملف:* `hijri_and_gregorian_date_widget.dart`
  - *المشكلة:* داخل الـ `BlocListener`، عندما تتغير الحالة لظهور الـ Dialog، يتم استدعاء `cubit.confirmVerification()` فوراً. يتم إطلاق حدث لتغيير الحالة كرد فعل مباشر لتغير حالة أخرى في الـ UI، وهذا يكسر نمط التدفق أحادي الاتجاه ويجعل تتبع الحالات معقداً. *(يخالف: Unidirectional Data Flow)*.

## 5. إدارة المهام ومبدأ المسؤولية الواحدة (Task Management & SRP)
- **تشغيل مؤقت (Timer) بداخل الـ Cubit:** 
  - *الملف:* `app_date_cubit.dart`
  - *المشكلة:* يحتوي الـ Cubit على دالة `_scheduleMidnightUpdate` لتشغيل `Timer` لانتظار منتصف الليل. الـ Cubit مسؤول عن التفاعل مع الواجهة وليس إدارة المهام في الخلفية. وضع مهام الجدولة بداخل مكونات العرض يخرق مبدأ المسؤولية الواحدة.

## 6. خلط حالة واجهة المستخدم (UI State) مع البيانات
- **دمج حالة الـ Dialog مع الـ Model:** 
  - *الملف:* `app_date_state.dart`
  - *المشكلة:* تم تضمين متغير `showVerificationDialog` (والذي يعبر عن حدث في الواجهة) بداخل `AppDateLoaded` (والتي تعبر عن البيانات). دمج حالة التنقل/الديالوج مع حالة البيانات يعتبر دمجاً بين مسؤوليات مختلفة.

## 7. تنظيم المشروع ومكان الملفات (Project Organization & Feature Boundaries)
- **وجود طبقة عرض (Presentation) داخل مجلد الخدمات (Services):**
  - *المشكلة:* المجلد `app_date` موجود داخل `lib/core/services/`، ولكنه يحتوي على طبقة عرض كاملة (`presentation/cubit` و `presentation/widgets`). مجلد `services` في الـ Core مخصص عادة للخدمات البرمجية (Headless) التي لا تحتوي على واجهة مستخدم.
  - *التوصية/الحل المقترح:* يفضل بقوة نقل المجلد بالكامل ليصبح ميزة مستقلة (Feature) داخل مسار `lib/features/app_date/` للحفاظ على ترابط الكود (Cohesion).
  - *(يخالف: Feature-based Structure & Core/Shared Modules)*.

## 8. تسريب منطق التهيئة إلى الواجهة (Smart vs Dumb Widgets & SRP)
- **الواجهة تدير دورة حياة البيانات المنطقية:**
  - *الملف:* `hijri_and_gregorian_date_widget.dart`
  - *المشكلة:* يتم استدعاء دالة `checkMonthlyVerification()` الخاصة بالـ Cubit من داخل `initState` الخاص بالـ Widget. الواجهة يجب أن تكتفي بعرض البيانات (Dumb Widget) ولا ينبغي لها أن تنظم وتدير بدء سريان القواعد المنطقية للبيانات. حدث ذلك لأن دالة `init()` في الـ Cubit لا تقوم بالتحقق بشكل تلقائي.
  - *(يخالف: Smart vs Dumb Widgets & SRP)*.

## 9. قابلية الاختبار (Testability & Side Effects)
- **تشغيل عمليات غير متزامنة (Timer) بداخل الـ Constructor:**
  - *الملف:* `app_date_cubit.dart`
  - *المشكلة:* داخل الدالة البانية للـ Cubit، يتم استدعاء `_scheduleMidnightUpdate()` مباشرة، والتي تبدأ تشغيل `Timer`. بدء عمليات لها تأثيرات جانبية (Side Effects) فوراً عند إنشاء الكائن يجعل من الصعب جداً كتابة اختبارات أحادية (Unit Tests) في بيئة معزولة.
  - *(يخالف: Testability)*.

## 10. كفاءة الأداء ونطاق بناء الواجهة (Widget Granularity)
- **نطاق أوسع من اللازم للـ BlocBuilder:**
  - *الملف:* `hijri_adjustment_bottom_sheet.dart`
  - *المشكلة:* الـ `BlocBuilder` يغلف الـ `Column` بالكامل بما في ذلك النصوص الثابتة. من الأفضل أن يغلف الـ `BlocBuilder` فقط الأزرار التي تعتمد فعلياً على الحالة لتجنب إعادة بناء الواجهة بالكامل. كما يتم إنشاء القائمة `[-1, 0, 1]` في كل عملية بناء (Build) بدلاً من تعريفها كـ `const`.
  - *(يخالف: Widget Granularity & Rebuild Awareness)*.

## 11. تكرار الكود والاعتمادية على تفاصيل التنفيذ (DRY & Encapsulation)
- **تكرار معادلة المُعرّف (Magic Math):**
  - *الملف:* `app_date_cubit.dart`
  - *المشكلة:* يتم تكرار المعادلة `(currentYear * 100) + currentMonth` في أكثر من مكان داخل الـ Cubit لحساب المعرف الخاص بالشهر. يجب استخراج هذه المعادلة وتغليفها لتصبح (Getter) بداخل `AppDateModel` لتجنب التكرار.
  - *(يخالف: Reusability & Encapsulation)*.

## 12. التجريد (Abstraction)
- **ربط النماذج مباشرة بحزم خارجية:**
  - *الملف:* `app_date_model.dart`
  - *المشكلة:* النموذج يعتمد على الكائن `HijriCalendar` من الحزمة الخارجية مباشرة كنوع بيانات أساسي. في البنية النظيفة، يُفضل تجريد الاعتماد المباشر على الحزم الخارجية حتى يسهل استبدالها لاحقاً دون التأثير على كافة النماذج.
  - *(يخالف: Abstraction & Encapsulation)*.
