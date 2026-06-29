# تقرير التدقيق المعماري التفصيلي والشامل لوحدة مواقيت الصلاة (features/prayer)

تمت إعادة فحص وتدقيق كود وحدة الصلاة في [lib/features/prayer](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer) بشكل فائق الدقة سطرًا بسطر وبشكل شامل بنسبة 100%، ومقارنتها مباشرة مع بنود بنود وثيقة المعايير المعمارية للمشروع [ARCHITECTURE_RUBRIC.md](file:///d:/flutter/flutter_Projects/muslim_app/architecture_docs/ARCHITECTURE_RUBRIC.md).

أدناه جميع المخالفات المعمارية والبرمجية مصنفة بدقة تامة طبقًا لبنود الروبيرك المعماري للمشروع:

---

## 🏗️ 1. المودول 1 و 2 و 3: الأساسيات، تصميم الكائنات ومبادئ SOLID

### 🔍 بند: Separation of Concerns (SoC) - فصل الاهتمامات
* **تسريب منطق التحكم والتحديث إلى الواجهة (UI Logic Leakage):**
  - في الـ widget المسمى [home_prayer_loaded.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/presentation/widgets/header/home_prayer_loaded.dart#L57)، تقوم فئة الـ UI بحساب فرق الوقت وتحديد ما إذا كان وقت الصلاة القادمة قد دخل لتطلب التحديث من الكيوبيت يدويًا عبر `context.read<PrayerTimesCubit>().refresh()`. هذا القرار المعقد وإدارة الحالات الزمنية يجب أن تكون مسؤولية الكيوبيت بالكامل ولا يجب تسريبها للـ UI.
  - استدعاء دالة `PrayerCountdownCalculator.calculateCountdown` مباشرة داخل مؤقت الـ UI لتغيير وعرض القيمة بدلاً من استقبال الحالة جاهزة ومحسوبة.
* **تسريب منطق العمل إلى النماذج (Models Leakage):**
  - كلاس البيانات [religious_event_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/models/religious_event_model.dart) يحتوي على منطق عمل ديني (Business Logic) مثل التحقق من مطابقة التاريخ واليوم عبر دالتين: `isOccurring(HijriCalendar hijri)` و `isAfter(HijriCalendar hijri)`. هذه الدوال يجب أن تُعزل في كيانات النطاق (Domain Entities) أو فئة منطق العمل، وليس فئة تحليل البيانات (Data Parsing).
* **خلط مسؤولية العرض ببيانات الـ Data:**
  - كلاس `PrayerDisplayModel` المعرف في [prayer_display_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/models/prayer_display_model.dart) تم وضعه في مجلد الـ `data` مع أنه لا يعبر عن استجابة شبكة أو قاعدة بيانات، وإنما هو نموذج لتمثيل البيانات المعروضة في شاشات الـ UI (مما يجعله Presentation Concern).

### 🔍 بند: High Cohesion & Low Coupling - الترابط القوي والاقتران الضعيف
* **الاقتران المباشر بين الكيوبيتات (Inter-Cubit Coupling):**
  - في ملف الكيوبيت [prayer_times_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/presentation/cubit/prayer_times_cubit.dart#L64-L73)، يتم حقن `LocationCubit` و `AppDateCubit` والاشتراك المباشر في التدفق (Stream) الخاص بهما لتنفيذ عملية تحديث مواقيت الصلاة. هذا الاقتران يجعل الكيوبيت معتمداً بالكامل على كتل تحكم خارجية (External Cubits) بدلاً من معالجة ذلك عبر واجهة موحدة أو التنسيق في طبقة الـ UI.
* **كسر عزل الميزات (Feature Coupling):**
  - كارت حالة الصلاة [prayer_status_carousel_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/presentation/widgets/header/widgets/prayer_status_carousel_card.dart#L8) وكارت المناسبات الدينية [religious_event_carousel_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/presentation/widgets/header/widgets/religious_event_carousel_card.dart#L9) يستوردان مباشرة الـ widget المسمى `DailyContentShareCard` من مجلد ميزة `daily_content`. هذا يخلق ارتباطاً قوياً يمنع فصل ميزة الصلاة برمجياً.

### 🔍 بند: Abstraction & Encapsulation - التجريد والكبسلة
* **تسريب تفاصيل التنفيذ الداخلي للمستودع (Leaky Repo API):**
  - تفرض واجهة [IPrayerRepository](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/repos/prayer_repository.dart#L14-L21) على المستدعي (وهو الكيوبيت) أن يمرر إحداثيات الموقع `CoordinatesModel` وإعدادات الصلاة `UserPrayerTimesSettings` كمدخلات لكل استدعاء. الكبسلة الصحيحة تقتضي أن يقوم المستودع داخلياً بجلب الإحداثيات والإعدادات دون فضح هذه المتطلبات والاعتماديات لطبقة الـ Presentation.

### 🔍 بند: Single Responsibility Principle (SRP) - المسؤولية الواحدة
* **تعدد مسؤوليات كلاس الكيوبيت (Fat Cubit):**
  - يحتوي الكيوبيت `PrayerTimesCubit` على مسؤوليات متعددة تخرق SRP: إدارة دورة حياة التطبيق (`WidgetsBindingObserver`)، تتبع تدفق حالات المواقع الخارجية والتاريخ، إدارة مؤقت التحديث الزمني وجدولته، معالجة وتغيير الترجمة المحلية (Locale)، التنسيق بين المستودعات، والتحكم بتهيئة الخدمات غير المتزامنة.
* **فئة وسيطة بلا فائدة (Redundant Delegate):**
  - فئة `PrayerTimesServiceImpl` في [prayer_times_service.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/services/prayer_times_service.dart) لا تقوم بأي عمل سوى توجيه الاستدعاءات مباشرة لخدمات أخرى. هذا يمثل تعقيدًا زائدًا وتكرارًا بلا فائدة.

### 🔍 بند: Abstraction & Encapsulation - مقارنة وتصميم الكائنات (Object Equality)
* **غياب مقارنة القيم للكائنات غير القابلة للتغيير (Immutable Objects):**
  - الكلاسات التالية تم وسمها بـ `@immutable` أو تستعمل كـ Data Holders ولكنها تفتقر تماماً لتطبيق مقارنة القيم (`operator ==` و `hashCode`):
    1. `PrayerAdjustmentsEntity` في [user_prayer_times_settings.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/models/user_prayer_times_settings.dart) (يسبب فشل المقارنة التلقائية لإعدادات الصلاة `UserPrayerTimesSettings`).
    2. `PrayerStateResult` في [prayer_state_result.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/models/prayer_state_result.dart).
    3. `PrayerTimeStatus` في [prayer_time_status.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/models/prayer_time_status.dart).
    4. `SunnahTimesEntity` في [sunnah_times_entity.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/models/sunnah_times_entity.dart).
    5. `ReligiousEventModel` في [religious_event_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/models/religious_event_model.dart).
    6. `PrayerDisplayModel` في [prayer_display_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/models/prayer_display_model.dart).
    7. `PrayerSunnah` و `SunnahHadith` في [sunnah_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/models/sunnah_model.dart).
* **مقارنة مرجعية خاطئة لحالة الكيوبيت (Broken Cubit State Equality):**
  - في الكلاس [prayer_times_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/presentation/cubit/prayer_times_state.dart#L127-L139)، تعتمد فئة `PrayerTimesLoaded` على مقارنة القائمة مباشرة `prayers == other.prayers` والتي تقارن مرجع القائمة في الذاكرة بدلاً من محتواها، بالإضافة لمقارنة الكائنات المركبة الأخرى غير المهيئة للمقارنة بالقيم. هذا يجعل مقارنة الحالات ترجع دائماً `false` ويؤدي لإعادة بناء واجهة المستخدم مع كل عملية إرسال للحالة حتى لو كانت البيانات متطابقة تماماً.

---

## 🌟 2. المودول 4 و 5: جودة البرمجيات وقابلية التوسع

### 🔍 بند: Testability - قابلية الاختبار
* **الاعتماد الصلب على وقت النظام (Hardcoded System Time):**
  - استدعاء `DateTime.now()` مباشرة بدلاً من استخدام فئة تجريد للوقت (Clock / Time Provider) في:
    - الكيوبيت `PrayerTimesCubit._calculatePrayerTimes` و `_scheduleNextUpdate`.
    - شاشة العرض `HomePrayerLoadedState._startTimer`.
    - أداة الحساب `PrayerCountdownCalculator`.
    هذا يجعل من المستحيل كتابة اختبارات زمنية معزولة ومتوقعة للعد التنازلي.
* **غياب مجلد وبيئة الاختبارات لوحدة الصلاة:**
  - لا توجد أي اختبارات أحادية (Unit Tests) لوحدة الصلاة كاملة، ولا يوجد حتى مجلد `test` للمشروع في بيئة العمل الحالية.
* **الاعتماد على واجهة فلاتر في طبقة الخدمات:**
  - يتم استدعاء `rootBundle` لقراءة ملفات الـ JSON في كل من `PrayerStatusServiceImpl` و `ReligiousEventsServiceImpl`. هذا يستدعي تهيئة الفلاتر بالكامل للقيام بالاختبارات ويمنع فحص الكود في بيئة Pure Dart. المعيار هو حقن واجهة لخدمة تحميل البيانات.

### 🔍 بند: Maintainability & Flexibility / DRY - الصيانة وعدم التكرار
* **تكرار كود التحويل (Duplicated Mappers):**
  - تطابق الكود والمنطق البرمجي لتحويل الكيانات لطرق حساب الصلاة والمذاهب البرمجية المعتمدة في حزمة adhan بين كل من المستودع [prayer_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/repos/prayer_repository.dart#L90-L126) والخدمة [prayer_state_service.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/services/prayer_state_service.dart#L140-L163).
* **إحداثيات ثابتة صلبة (Hardcoded Coordinates):**
  - يتم تعريف إحداثيات موقع افتراضية صلبة للمستخدم (القاهرة كموقع افتراضي) مباشرة في كود المستودع `PrayerRepoImpl` كقيم ثابتة، بدلاً من حقنها أو تحميلها من ملف تهيئة بيئة خارجي.

### 🔍 بند: Predictability - تدفق البيانات المتوقع
* **الالتفاف على حالة الكيوبيت النشطة (State Bypass):**
  - في [prayer_location_widget.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/presentation/widgets/prayer_settings/prayer_location_widget.dart#L13)، يقوم الـ widget باستدعاء مباشر متزامن لدالة `cubit.getStoredLocationName()` للحصول على اسم المدينة بدلاً من قراءته واستقباله عبر كائن الحالة المنبعث `LocationState`.

---

## 📂 3. المودول 6: تنظيم مشروع فلاتر

### 🔍 بند: Feature Isolation - استقلالية الميزات
* **كسر الاستقلالية المعمارية:**
  - تعتمد ميزة الصلاة بشكل مباشر ومحسوس على ميزة `daily_content` بسبب استيرادها المباشر لمحتوى الكروت التشاركية منها، مما ينتهك استقلالية ميزات المشروع.

### 🔍 بند: Naming Conventions - اصطلاحات التسمية
* **تسمية مضللة للكلاسات والكيانات:**
  - الفئات `PrayerTimesEntity` و `CalculationMethodEntity` و `MadhabEntity` و `PrayerAdjustmentsEntity` تحمل لاحقة `Entity` في أسمائها ولكنها معرفة داخل مجلد `data/models/` وتُستخدم ككلاسات بيانات أو enums بدلاً من أن تكون كيانات أعمال مجردة في طبقة النطاق.

### 🔍 بند: Barrel Files & Export Strategy - ملفات التجميع والتصدير
* **غياب ملف التصدير المعماري:**
  - تفتقر ميزة الصلاة بالكامل لملف تجميع وتصدير موحد (مثل `index.dart` أو `prayer.dart`) تحت مسار الميزة الرئيسي لتبسيط عمليات الاستيراد وتنظيفها للطبقات الأخرى.

---

## 🧱 4. المودول 7: مفاهيم الطبقات (Layering Concepts)

### 🔍 بنود: Layer Responsibilities & Dependency Direction & Layer Communication
* **عدم احترام طبقة النطاق (Domain Layer):**
  - لا توجد طبقة نطاق مفعلة (Domain Layer) للـ feature بالرغم من إنشاء المجلدات الخاصة بها.
* **الاعتماد العكسي والاتصال المباشر بين Presentation و Data:**
  - تعتمد طبقة العرض (`PrayerTimesCubit`) مباشرة على فئات تنفيذ البيانات والخدمات المحددة في طبقة الـ `data`.
  - يتم نقل البيانات عبر واجهات (Interfaces) تم وضعها داخل طبقة الـ `data` نفسها، مما يخالف قواعد الاتصال السليمة للـ Clean Architecture حيث يجب أن تعبر الواجهات حدود البيانات عبر تعريفها في طبقة النطاق (Domain).

---

## 🌳 5. المودول 8: البنية الداخلية للفلاتر

### 🔍 بند: Widget Lifecycle - دورة حياة العناصر
* **غياب مزامنة التحديثات البرمجية:**
  - يفتقر الكود [home_prayer_loaded.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/presentation/widgets/header/home_prayer_loaded.dart) لتعريف دالة `didUpdateWidget`. عند إعادة بناء الـ widget بسبب تغير الحالة الممررة (State update)، لن يستجيب الـ `_durationNotifier` فوراً لأي إحداثيات أو معطيات زمنية جديدة حتى يمر سطر المؤقت الدوري التالي.
* **إطلاق عمليات غير متزامنة غير معالجة في مشيد الكلاس:**
  - إطلاق مهام التهيئة لملفات النصوص والمناسبات الدينية عبر `unawaited` داخل المشيد في الكيوبيت `PrayerTimesCubit` هو تكتيك خاطئ معمارياً يجعل مراقبة استقرار النظام ومعالجة الأخطاء أمراً صعباً.

### 🔍 بند: Rebuild Process - عملية إعادة البناء
* **إعادة بناء مفرطة للواجهات (Over-rebuilding UI):**
  - نظراً لفشل مقارنة حالة الكيوبيت `PrayerTimesLoaded` (بسبب خرق الـ Equality)، يتم استدعاء الـ `builder` في شاشات العرض وإعادة بناء كامل الشجرة بشكل مفرط دون أي تصفية للحالات المتطابقة.

---

## 🔁 6. المودول 11 & 12: نظام التصميم والمخاوف العرضية (Theme & Localization)

### 🔍 بند: Localization & Theme - الترجمة المحلية والسمات العامة
* **استعمال نصوص عربية صلبة غير مترجمة:**
  - إعدادات الصلاة [prayer_times_settings_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/presentation/views/prayer_times_settings_view.dart#L80) تحتوي على نص عربي صلب `'الموقع'`.
  - كارت المدينة والدولة [city_country_widget.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/presentation/widgets/header/city_country_widget.dart#L25) يحتوي على نص عربي صلب `'موقع المستخدم الحالي'`.
  - فئة الأسماء الثابتة [prayer_settings_names.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/constants/prayer_settings_names.dart) تحتوي على نصوص عربية صلبة لجميع طرق الحساب والمذاهب.
* **ترميز الأحاديث صلبًا باللغة العربية:**
  - جميع الأحاديث وسنن الصلوات وقيم الراوي والأرقام تم ترميزها بشكل ثابت وعربي في كود فئة [sunnah_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/data/models/sunnah_model.dart#L47-L96) بدلاً من استدعائها من ملفات التهيئة المحلية.
* **إجبار اللغة العربية في التاريخ والمقارنات:**
  - في [prayer_timeline.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/presentation/widgets/prayer_timeline.dart#L29)، يتم تحديد اللغة العربية صلبًا لتنسيق الوقت: `DateFormat('a', 'ar').format(prayer.time)`.
  - استخدام تحققات برمجية صلبة على الأسماء العربية مثل `prayerName == 'العصر'` لتغيير نوع الكرت أو النص في الـ UI.
* **ألوان تصميم مكسورة صلبة:**
  - استخدام اللون الثابت `Colors.white10` في [prayer_sunnah_bottom_sheet.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/presentation/widgets/prayer_sunnah_bottom_sheet.dart#L97) و [sunnah_share_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/presentation/widgets/share_card/sunnah_share_card.dart#L69). هذا اللون لن يتوافق مع أنظمة الألوان الفاتحة وسينتج عنه خطأ بصري في التصميم.

---

## 🚀 7. المودول 10 & 13: تكوين الـ Widgets والأداء

### 🔍 بند: Smart vs Dumb Widgets
* **تحميل عناصر العرض بمنطق معقد (Fat Dumb Widgets):**
  - الكروت المخصصة لعرض الحالات والعد التنازلي والمناسبات تحمل مسؤولية عرض مربعات الحوار (Dialogs)، ونسخ النصوص للحافظة البرمجية، ومعالجة حفظ الصور والمشاركة برمجياً. المعمارية السليمة تفترض فصل هذه المهام وإتاحتها كـ callbacks للـ widget الأب أو طبقة الكيوبيت.

### 🔍 بند: Widget Granularity - استهلاك الموارد بسبب الـ Watch الواسع
* **رصد كامل كتل التحكم برمجياً:**
  - في [prayer_location_widget.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/prayer/presentation/widgets/prayer_settings/prayer_location_widget.dart#L12) يتم استخدام `context.watch<LocationCubit>()` بدلاً من مراقبة الخاصية المعنية فقط، مما يؤدي إلى إعادة بناء الـ widget بشكل متكرر دون وجود تغيير حقيقي في الاسم المعروض.
