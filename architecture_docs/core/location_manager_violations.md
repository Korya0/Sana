# تقرير شامل بمخالفات معمارية الكود (Location Manager)

هذا الملف يحتوي على تقييم شامل لمدى مطابقة كود قسم `location_manager` مع معايير `ARCHITECTURE_RUBRIC.md`.

## 💡 توصية معمارية هامة: تحويل الخدمة إلى Feature

حالياً، يقع `location_manager` في مسار `lib/core/services/location_manager`. ولكن نظراً لوجود طبقة `presentation` كاملة بداخله (تحتوي على Widgets و Cubits و Bottom Sheets) وطبقة `data` منفصلة، فهو يتجاوز كونه مجرد "خدمة (Service)". 
الخدمات في `core/services` يجب أن تكون مجرد كلاسات مساعدة (Utility) لا تحتوي على واجهة مستخدم. 
لذلك، **يُنصح بشدة بنقل هذا القسم بالكامل ليكون Feature مستقلة** في مسار `lib/features/location` أو `lib/features/location_picker`. هذا سيساعد في تحقيق معيار (Feature-based Structure) بشكل أفضل ويفصل الواجهة عن الخدمات الأساسية.

---

## 📋 قائمة المخالفات التفصيلية (بحسب وحدات التقييم)

### 🏗️ Module 1, 2 & 3: Fundamentals, Object Design, & SOLID

1. **مخالفة (Single Responsibility Principle - SRP) ومبدأ فصل الاهتمامات (SoC):**
   - **الملف:** `location_guard.dart`
   - **السبب:** هذا الـ Widget يُعتبر (God Widget)؛ فهو يقوم بمهام تتجاوز رسم واجهة المستخدم. يقوم بمراقبة دورة حياة التطبيق (`WidgetsBindingObserver`)، التحكم في الـ Navigation و الـ Bottom Sheets، التحقق من حالة الـ GPS، وإطلاق دوال معقدة داخل الـ Cubit. (الواجهة مختلطة بشدة مع منطق الأعمال).
   - **الملف:** `location_local_data_source.dart`
   - **السبب:** يحتوي على دالة `openAppSettings()` ويستدعي `_permissionsManager`. طبقة الـ Data Source الخاصة بإحداثيات الموقع (Geolocator) لا يجب أن تكون مسؤولة عن فتح إعدادات النظام العامة للتطبيق.

2. **مخالفة (High Cohesion & Low Coupling):**
   - **الملف:** `location_name_cubit.dart`
   - **السبب:** يعتمد بشكل مباشر على `LocationCubit` (مُرر في الـ Constructor) ويستمع لحالته داخلياً عبر `_listenToLocationUpdates()`. هذا يربط اثنين Cubits ببعضهما بـ Tight Coupling، والأفضل إما دمج المنطق، أو جعل المزامنة بينهما تتم في الـ UI عبر `BlocListener` أو في طبقة UseCase خارجية.

3. **مخالفة (Abstraction & Encapsulation):**
   - **الملف:** `location_name_cubit.dart`
   - **السبب:** المتغيران `_lastLat` و `_lastLng` محفوظان كحالة متغيرة (Mutable Variables) داخل الكلاس نفسه وليس داخل كلاسات الـ State (مثل `LocationNameLoaded`)، مما يكسر مبدأ الكبسولة ويجعل الـ State غير متوقعة.

16. **مخالفة (Dependency Inversion) وتسرب مكاتب الطرف الثالث (Domain Leakage):**
    - **الملف:** `i_location_repository.dart`
    - **السبب:** الـ Interface تعتمد مباشرة على كلاس `LocationPermission` القادم من حزمة `geolocator`. لا يجب أبداً أن يعتمد الـ Domain على مكاتب الـ Flutter الخارجية (يجب عمل Enum داخلي).

17. **مخالفة (Extensibility / Open-Closed Principle):**
    - **الملف:** `location_country_picker.dart`
    - **السبب:** يعتمد المكون بشكل ثابت ومباشر على المتغير العالمي `arabCountries`. هذا يجعل المكون مغلقاً أمام التعديل (لو أردنا استخدامه لدول عالمية مستقبلاً)، وكان يجب تمرير قائمة الدول كـ Parameter للمكون.

18. **مخالفة (Separation of Concerns) وخلط منطق العرض بالبيانات:**
    - **الملف:** `nominatim_response_model.dart`
    - **السبب:** يحتوي المودل على دالة `formattedAddress` تقوم بتشكيل النصوص للواجهة (`$city, $country`). نماذج البيانات (Data Models) يجب أن تكتفي باحتواء البيانات، والتنسيق مكانه الـ Presentation Layer أو طبقة Mapper.

---

### 🌟 Module 4 & 5: Software Quality & Scalability

4. **مخالفة (Testability) و (Dependency Injection):**
   - **الملف:** `location_guard.dart` (سطر 293)
   - **السبب:** استدعاء مباشر لـ Service Locator داخل الـ Widget عبر `await sl<IAppPermissionsManager>().openSettings();`. هذا يكسر مبدأ حقن الاعتماديات ويجعل من المستحيل تقريباً عمل Unit Test لهذا الـ Widget. يجب أن يتم هذا الاستدعاء من داخل الـ Cubit فقط.

5. **مخالفة (Predictability) وجودة توقع الأخطاء:**
   - **الملف:** `location_remote_data_source.dart` (سطر 71-77)
   - **السبب:** التعامل مع الأخطاء يتم بمقارنة النصوص بشكل هش (Brittle String Matching): `e.toString().toUpperCase().contains('IO_ERROR')`. هذا التصرف سيئ جداً ويجب الاعتماد على أنواع الـ Exceptions الصريحة أو الـ Error Codes.

6. **مخالفة (Maintainability) واستخدام الكود الميت و (Magic Numbers):**
   - **الملفات:** موزعة في الكود.
   - **السبب:** 
     - وجود أرقام سحرية كـ `Duration(seconds: 5)` و `for (var i = 0; i < 2; i++)`.
     - كود ميت (Dead/Zombie Code) في `_updateLocationSilently` يحتوي على تعليق يُشير إلى تعطيل الميزة دون مسح الكود فعلياً. (سيتم حذف هذا الكود الميت نهائياً كجزء من التعديلات القادمة).

19. **مخالفة (Side-Effects) وتأثيرات عامة غير متوقعة (Global State Mutation):**
    - **الملف:** `location_remote_data_source.dart` (سطر 36)
    - **السبب:** استدعاء `await setLocaleIdentifier(locale);` يُعدل لغة الـ Plugin على مستوى التطبيق كاملاً (Global). في حال حدوث طلبين متزامنين بلغات مختلفة، سيتداخلان (Race Condition). يخالف معيار "Predictability without side-effects".

20. **مخالفة (Predictability) وحلول ترقيعية (Hacky Polling):**
    - **الملف:** `location_name_cubit.dart` (في دالة `loadLocation`)
    - **السبب:** الكود يقرأ الإحداثيات من الـ `sharedPref`، وإذا كانت فارغة ينتظر `await Future<void>.delayed(500ms)` ثم يقرأها مجدداً! هذا دليل على وجود مشكلة تزامن (Race Condition) بين الـ Cubits ويؤدي لسلوك غير متوقع.

---

### 📂 Module 6: Flutter Project Organization

7. **مخالفة (Barrel Files & Export Strategy):**
   - **الملفات:** كامل نظام الملفات.
   - **السبب:** لا يوجد أي ملف `index.dart` لتجميع الـ Exports. يتم استدعاء الملفات بمساراتها العميقة (Deep Imports) مما يزحم ترويسات الملفات الأخرى في التطبيق.

8. **مخالفة (Naming Conventions):**
   - **الملف:** `cubit/location_permission/location_cubit.dart` و `location_state.dart`
   - **السبب:** عدم تطابق اسم المجلد مع محتواه. المجلد اسمه `location_permission` ولكن الملفات والكلاسات بداخلها اسمها `Location` بدلاً من `LocationPermissionCubit` و `LocationPermissionState`.

21. **مخالفة وضع النماذج (Models Placement):**
    - **الملف:** `constants/arab_countries.dart`
    - **السبب:** تم إنشاء كلاس (Model) باسم `ArabCountry` داخل ملف Constants بدلاً من وضعه في مجلد النماذج المخصص له.

---

### 🧱 Module 7: Layering Concepts

9. **مخالفة (Layer Responsibilities & Boundaries) وغياب طبقة الـ Domain:**
   - **الملف:** `data/repos/i_location_repository.dart`
   - **السبب:** لا يوجد طبقة `domain` أصلاً! تم إلقاء الـ Interface (العقد) الخاص بالـ Repository داخل مجلد `data/repos`. وفقاً لمعايير الـ Clean Architecture، يجب أن تكون العقود في مجلد `domain` (أو `domain/repositories`) والـ `data` لتنفيذ هذه العقود فقط.

22. **مخالفة معمارية في فصل مسؤوليات مصادر البيانات (Data Sources Mismatch):**
    - **الملف:** `location_remote_data_source.dart`
    - **السبب:** استخدام مكتبة `geocoding` (وهي Native Device Plugin) إلى جانب `LocationApiClient` (وهو شبكي). إضافات الجهاز المحلية تنتمي للـ `LocalDataSource`، والـ `RemoteDataSource` للـ API فقط.

---

### 🔄 Module 9: Data & Communication Flow

10. **مخالفة (State Flow & Modeling) و (Unidirectional Data Flow):**
    - **الملفات:** `location_cubit.dart` و `location_state.dart`
    - **السبب:** الـ Cubit يبعث حالات هي في الأصل أوامر واجهة (UI Commands) مثل `LocationShowChoiceSheet` و `LocationSkipped`. الـ State يجب أن يمثل البيانات فقط (Data State)، واستخدام الـ State لإرسال أوامر منقطعة (One-off UI Events) هو Anti-Pattern في التعامل مع Bloc/Cubit.

11. **مخالفة (State Modeling - Freezed/Sealed Boilerplate):**
    - **الملفات:** `location_state.dart` و `location_name_state.dart`
    - **السبب:** الروبيرك يطلب "using Freezed or sealed classes". بالرغم من توظيف الـ Sealed classes، إلا أن الكود مكدس بكتابة يدوية لـ `operator ==` و `hashCode` و `toString` في كل حالة. هذا الكود الزائد يخفض من الـ Maintainability. (كان يجب استعمال حزمة `Equatable` أو `Freezed` لتقليل هذا الضجيج).

---

### 🧩 Module 10 & 13: Widget Composition & Performance

12. **مخالفة (Smart vs Dumb Widgets):**
    - **الملف:** `location_country_picker.dart`
    - **السبب:** يُعتبر مكون واجهة يجب أن يكون غبياً (Dumb / Presentational)، ولكنه يتخاطب مباشرة مع الـ Cubit: `cubit.saveManualLocation(...)`. الأصح هو أن يمرر الاختيار كـ Callback (مثلاً `onCountrySelected`) ويترك لـ Parent إدارة الـ State.

13. **مخالفة (Container vs Presentation Components):**
    - **الملف:** `location_guard.dart`
    - **السبب:** خلط بيّن بين هيكلة الـ Layout (رسم `Skeletonizer`) وبين منطق الـ Bottom Sheets والـ Routing ودورة الحياة في نفس المكان.

27. **مخالفة (Routing & Navigation Consistency):**
    - **الملف:** `location_guard.dart`
    - **السبب:** يقوم الـ Widget بخلط صريح بين نظام الملاحة المدمج في فلاتر `Navigator.of(context).pop()` وبين نظام التوجيه `go_router` عبر `context.pop()` في نفس الملف! هذا يؤدي إلى تضارب، ويجب توحيد أسلوب الـ Navigation وإخراج هذا المنطق تماماً من الـ Widget إلى طبقة توجيه (Router/Coordinator).

23. **مخالفة (Widget Granularity) وإعادة بناء الشجرة بأكملها:**
    - **الملف:** `location_guard.dart` (سطر 316)
    - **السبب:** הـ `BlocBuilder` يغلف الـ `child` بأكمله، والذي قد يكون الشاشة بكاملها. هذا يؤدي إلى Rebuild غير ضروري، مخالفاً المعيار: "Are BlocBuilders placed as deep in the tree as possible?".

24. **مخالفة (Performance) وبطء في عمليات I/O:**
    - **الملف:** `location_repo_impl.dart` (حفظ الإحداثيات)
    - **السبب:** يتم استدعاء أوامر الحفظ في الذاكرة `sharedPref.setDouble` بشكل متسلسل بـ `await`. كان يجب استخدام `await Future.wait([ ... ])` لتنفيذ الحفظ بشكل متوازي وتقليل زمن الـ I/O.

---

### 🔁 Module 11 & 12: Reusability, Design System, & Cross-Cutting

14. **مخالفة (UI Consistency & Theme):**
    - **الملف:** `location_guard.dart` (الأسطر 161 و 162)
    - **السبب:** استخدام ألوان ثابتة صريحة (Hardcoded Colors): `borderColor: Colors.red, textColor: Colors.red,`. الروبيرك ينص على ضرورة استخدام `context.color`، وكان يجب استدعاء شيء مثل `context.color.error` بدلاً من `Colors.red`.

15. **مخالفة (Error Handling):**
    - **الملف:** `location_repo_impl.dart` (سطر 103-108)
    - **السبب:** عند حدوث خطأ `TimeoutException`، يتم إرسال رسالة خطأ عامة جداً (Generic): `AppStrings.locationError`. الروبيرك يطلب "Are exceptions mapped to user-friendly messages?"، وكان يجب تخصيص رسالة تنبه المستخدم لـ "انتهاء مهلة الاتصال بالـ GPS".

25. **مخالفة (Localization & Theme) وتثبيت لغة الترجمة (Hardcoded Locale):**
    - **الملف:** `location_name_cubit.dart` (سطر 21)
    - **السبب:** دالة استرجاع الموقع تقوم بتمرير اللغة العربية بقيمة صريحة `AppConstants.ar`، متجاهلة تماماً لغة النظام أو لغة التطبيق الحالية! هذا يكسر التوطين (Localization).

26. **مخالفة (Brittle State Machine) للواجهة:**
    - **الملف:** `location_guard.dart` (BlocListener)
    - **السبب:** يتم التحكم في عرض النوافذ السفلية (Bottom Sheets) استناداً لنصوص صريحة (Magic Strings) مثل `_lastShownStateTag == 'permission'`. بناء State Machine تعتمد على نصوص داخل הـ UI هو نهج هش جداً.
