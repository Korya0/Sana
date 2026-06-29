# سجل المخالفات المعمارية - وحدة القبلة (features/qibla)

تم فحص وتدقيق كود وحدة القبلة في [lib/features/qibla](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla) بالكامل وبدقة عالية، ومقارنتها مباشرة مع المعايير المعمارية للمشروع المحددة في [ARCHITECTURE_RUBRIC.md](file:///d:/flutter/flutter_Projects/muslim_app/architecture_docs/ARCHITECTURE_RUBRIC.md).

أدناه تفصيل المخالفات المعمارية والبرمجية المرصودة سطرًا بسطر:

---

## 🏗️ 1. المودول 1 و 2 و 3: الأساسيات، تصميم الكائنات ومبادئ SOLID

### 🔍 بند: Separation of Concerns (SoC) - فصل الاهتمامات
* **الاقتران المباشر بالمكونات البرمجية الخارجية (Plugin Coupling in Cubit):**
  - في الكيوبيت [qibla_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/presentation/cubit/qibla_cubit.dart#L47)، يتم استيراد واستدعاء الإشارة الخاصة بحزمة الاتجاهات مباشرة `final stream = FlutterCompass.events;`. الكيوبيت يجب أن يكون Pure Dart وخالياً تماماً من الاعتماد المباشر على الحزم Native/Plugins، ويجب كبسلة هذا الاستدعاء في طبقة الخدمات (Services) أو مصادر البيانات (Data Sources) تحت مظلة الـ Repository.
* **الاعتماد المباشر على خدمات التخزين المحلي في الكيوبيت:**
  - في [qibla_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/presentation/cubit/qibla_cubit.dart#L58-L72) وفي ملف الحقن [qibla_di.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/di/qibla_di.dart#L34)، يعتمد الكيوبيت مباشرة على `ILocalStorageService` لقراءة وحفظ وضع القبلة (`qiblaMode`). حفظ وتعديل التفضيلات المخزنة هي مسؤولية مستودع البيانات (Repository) أو مصدر بيانات محلي (Local Data Source)، ولا يجب استدعاؤها أو حقنها مباشرة في طبقة العرض (Cubit).

### 🔍 بند: Single Responsibility Principle (SRP) - المسؤولية الواحدة
* **تعدد مهام كلاس الكيوبيت:**
  - يقوم الكيوبيت `QiblaCubit` بعدة مسؤوليات متباينة: إدارة التهيئة ومزامنتها، تتبع تفعيل وإرسال الحالات المتنوعة، التحكم المباشر بالحفظ المحلي، واستقبال تدفق البيانات الجغرافي من حزمة البوصلة وتوجيهه.

### 🔍 بند: Abstraction & Encapsulation - مقارنة وتصميم الكائنات (Object Equality)
* **غياب مقارنة القيم لحالات الكيوبيت (Broken State Equality):**
  - في الملف [qibla_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/presentation/cubit/qibla_state.dart)، تفتقر فئات الحالات (`QiblaInitial`, `QiblaLoading`, `QiblaSuccess`, `QiblaError`) لتعريف مقارنة القيمة المخصصة (`==` و `hashCode`). هذا يؤدي إلى إعادة بناء (Rebuild) كامل للواجهات مع كل إرسال للحالة حتى لو كانت متطابقة تماماً. يفضل استخدام `Equatable` أو `Freezed`.
* **غياب مقارنة الكيانات (Entities Equality):**
  - تفتقر جميع فئات الكيانات في [qibla_entities.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/domain/entities/qibla_entities.dart) لتعريف المقارنة بالقيم بالرغم من تعبيرها عن كائنات بيانات غير قابلة للتغيير.
* **تقريب قيم الثوابت الرياضية يدويًا (Hardcoded Math Values):**
  - في [qibla_map_widget.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/presentation/widgets/map/qibla_map_widget.dart#L51-L88)، تم تدوين نسبة تحويل الدرجات والراديان يدويًا باستخدام رقم صلب مقرب `(180 / 3.141592653589793)`. يجب استبدال هذا الرقم الصلب بالقيمة الرسمية المتوفرة في `dart:math` كـ `math.pi`.

---

## 🌟 2. المودول 4 و 5: جودة البرمجيات وقابلية التوسع

### 🔍 بند: Don't Repeat Yourself (DRY) - عدم تكرار الأكواد
* **تكرار واختلاف قيم الثوابت الجغرافية (Coordinates Inconsistency):**
  - في الكلاس [qibla_map_widget.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/presentation/widgets/map/qibla_map_widget.dart#L64-L65)، تم تدوين إحداثيات الكعبة المشرفة يدوياً وبصورة صلبة (`kaabaLat = 21.422487` و `kaabaLng = 39.826206`).
  - هذا يكرر ويخالف الثوابت المعرفة سلفاً في [qibla_data_constants.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/constants/qibla_data_constants.dart#L7-L8) حيث عُرفت كـ (`kaabaLatitude = 21.4225` و `kaabaLongitude = 39.8262`).

### 🔍 بند: Testability - قابلية الاختبار
* **الاعتماد المباشر على الحزمة الخارجية في الكيوبيت:**
  - استدعاء `FlutterCompass.events` مباشرة وبطريقة ثابتة (Static) في الكيوبيت يمنع حقن وحيازة تدفق وهمي (Mock Stream) لاختبار تصرفات الكيوبيت عند تغير اتجاه الهاتف في البيئة التجريبية.

### 🔍 بند: Readability & Discoverability - المقروئية والوضوح
* **استخدام كود معقد غير مبرر (IIFE Code Smell):**
  - في كلاس [get_qibla_direction_use_case.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/domain/use_cases/get_qibla_direction_use_case.dart#L16-L42)، تم كتابة تعبير دالة مستدعية ذاتياً (IIFE) داخل جملة `switch` لمعالجة نجاح جلب البيانات. هذا النمط البرمجي يرفع تعقيد مقروئية الكود دون وجود حاجة برمجية حقيقية له.

---

## 📂 3. المودول 6 & 7: تنظيم المشروع ومفاهيم الطبقات

### 🔍 بند: Feature Isolation & Unused Code - عزل الميزات والأكواد الميتة
* **أكواد ونماذج ميتة غير مستخدمة (Unused Dead Code):**
  - ملف النماذج [qibla_models.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/data/models/qibla_models.dart) يحتوي على فئات كاملة (`QiblaMessageModel`, `QiblaLocationModel`, `QiblaCompassDataModel`) وهي غير مستخدمة أو مستوردة مطلقاً في أي جزء من أجزاء الكود البرمجي للمشروع.
  - ملف إعدادات الرسائل [qibla_message_config.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/presentation/widgets/hint/qibla_message_config.dart) غير مستخدم أو مستورد مطلقاً في أي مكان بالتطبيق.
* **غياب ملف التجميع والتصدير الموحد (No Barrel File):**
  - لا يوجد ملف `index.dart` لتصدير أدوات وواجهات وحدة القبلة، مما يجبر الملفات الخارجية (مثل [qibla_routes.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/presentation/routes/qibla_routes.dart#L5-L7)) على استيراد الملفات العميقة مباشرة مثل `qibla_view.dart`, `qibla_scaffold.dart`, `skeletonizer_qibla_widget.dart` مما يضعف عزل الميزات.

### 🔍 بند: Layer Responsibilities - مسؤوليات الطبقات
* **استيراد واجهات عرض النصوص (AppStrings) في المستودعات والخدمات:**
  - في مستودع القبلة [qibla_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/data/repos/qibla_repository.dart#L31-L83) والخدمة [qibla_service.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/data/services/qibla_service.dart#L70-L95)، يتم استيراد `AppStrings` المعرفة في طبقة العرض لاستخدام نصوص الأخطاء والرسائل مباشرة.
  - طبقة البيانات يجب ألا تعتمد أبداً على نصوص واجهة المستخدم، بل يجب أن ترجع كائنات أخطاء أو حالات برمجية مجردة، ويقوم الكيوبيت أو الواجهة بترجمتها لنصوص للمستخدم.

---

## 🌳 4. المودول 8 & 13: بنية فلاتر الداخلية وكفاءة الأداء (Widget Lifecycle & Performance)

### 🔍 بند: Widget Lifecycle & Stream Subscription - استهلاك وتوليد التدفقات داخل البناء
* **إعادة بناء وتوليد التدفق مع كل رندرة (Stream Re-creation in Build Method):**
  - في ويدجت [qibla_compass_stream_widget.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/presentation/widgets/loaded/qibla_compass_stream_widget.dart#L17)، يتم استدعاء دالة الكيوبيت `getQiblaStream` مباشرة داخل دالة `build`.
  - بما أن دالة `getQiblaStream` تقوم بعمل `stream.map(...)` وتوليد كائن `Stream` جديد تماماً في كل مرة تُستدعى فيها، فإن الـ `StreamBuilder` يقوم بإلغاء اشتراكه القديم والاشتراك في التدفق الجديد مع كل عملية إعادة بناء (Rebuild) للويدجت! هذا يمثل خللاً فادحاً في الأداء ويسبب زيادة استهلاك الذاكرة والمعالج وربما فقدان بعض البيانات الجغرافية. يجب توليد التدفق مرة واحدة وتخزينه أو إدارته خارج دالة `build`.

### 🔍 بند: Widget Granularity & Object Allocation - تكرار حجز كائنات الرسام
* **تكرار كائن الرسام في دالة البناء (CustomPainter Instantiation in Build):**
  - في [qibla_compass.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/presentation/widgets/compass/qibla_compass.dart#L38-L51)، يتم إنشاء كائن جديد تماماً من `CompassBackgroundPainter` داخل دالة البناء `build`. وبما أن الويدجت يعاد بناؤه بشكل مستمر مع كل تحديث خفيف للبوصلة (عدة مرات في الثانية)، فهذا يتسبب في ضغط شديد ومستمر على جامع القمامة (Garbage Collector) لتخصيص الكائنات وإفراغها.
* **خلل منطقي في الـ CustomPainter لمنع إعادة الرسم (shouldRepaint Bug):**
  - في الكلاس [compass_background_painter.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/presentation/widgets/compass/compass_background_painter.dart#L90)، ترجع دالة `shouldRepaint` القيمة `false` دائمًا. هذا يعني أنه لو تغير ثيم التطبيق (من الوضع الداكن للفاتح أو العكس) وتغيرت الألوان الممررة للرسام (`primaryColor` و `secondaryBackgroundColor`)، فلن يقوم الرسام بتحديث ألوان الخلفية على الشاشة، مما يسبب عدم اتساق في المظهر العام. يجب مقارنة المعاملات القديمة بالجديدة داخل الدالة لمعرفة إذا كان يجب إعادة الرسم.

### 🔍 بند: BuildContext Usage & Layout Warnings - مخاطر التحديث أثناء رندرة الشجرة
* **استدعاء تدوير الخريطة داخل didUpdateWidget:**
  - في [qibla_map_widget.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/presentation/widgets/map/qibla_map_widget.dart#L52)، يتم استدعاء `_mapController.rotate(mapRotationDegrees)` مباشرة داخل `didUpdateWidget`. القيام بتحديثات على الخرائط أو عناصر التحكم وتغيير حالاتها أثناء دورة تحديث الويدجت قد يسبب تحذيرات فلاتر المشهورة ("setState() or markNeedsBuild() called during build") ويسبب مشاكل في الرندرة. يفضل تأخير الاستدعاء باستخدام `WidgetsBinding.instance.addPostFrameCallback`.

---

## ⚙️ 5. المودول 12: الترجمة وتناسق المظهر العامة (Localization)

### 🔍 بند: Localization - الترجمة المحلية
* **نصوص صلبة عربية تمنع عمل الترجمة:**
  - في [skeletonizer_qibla_widget.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/qibla/presentation/widgets/skeletonizer_qibla_widget.dart#L17-L18)، تم استخدام نصوص عربية صلبة لتحديد الرسالة الاحتياطية أثناء التحميل:
    - `message: 'جاري تحديد القبلة'`
    - `subMessage: 'يرجى الانتظار...'`
    هذه الرسائل لن تتم ترجمتها في حال تحويل لغة التطبيق للإنجليزية.
