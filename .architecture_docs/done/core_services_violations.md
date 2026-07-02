# Core Services Architecture Violations

بناءً على الفحص المعماري لخدمات الـ Core (تحديداً `background` و `device_info` و `local_storage`) مقابل `ARCHITECTURE_RUBRIC.md`، تم رصد المخالفات التالية:

## 1. مخالفات قسم `background` (WorkManager) (✅ تم الحل)

### تسريب تفاصيل المكتبات الخارجية في الواجهة (Module 1, 2, 3: Abstraction)
- **المخالفة:** الواجهة المجرّدة `IWorkManagerService` تستورد وتكشف كلاسات تابعة لمكتبة خارجية (`workmanager`) مثل `ExistingPeriodicWorkPolicy` و `Constraints` داخل متطلباتها (Parameters).
- **السبب المعماري:** الواجهة (Interface) يجب أن تكون مستقلة (Agnostic). تغيير مكتبة `workmanager` مستقبلاً سيؤدي لكسر الواجهة.
- **التوصية:** إنشاء Enums و Classes داخلية خاصة بالتطبيق في الواجهة، وتحويلها (Mapping) إلى كلاسات المكتبة حصرياً داخل كلاس التنفيذ (`WorkManagerServiceImpl`).

## 2. مخالفات قسم `device_info` (✅ تم الحل)

### أ. الاعتماد على `Map` بدلاً من النماذج الواضحة (Module 9: State Flow)
- **المخالفة:** الدالة `getDeviceInfo()` تُرجع البيانات على شكل `Future<Map<String, dynamic>>` بدلاً من إرجاع كلاس مُهيكل.
- **السبب المعماري:** استخدام الخرائط (Maps) يكسر ميزة الأمان الكتابي (Type-Safety) ويزيد من الأخطاء الإملائية ويصعب اكتشاف البيانات التلقائي.
- **التوصية:** إنشاء كلاس `DeviceInfoModel` واستخدامه كقيمة للإرجاع.

### ب. تسريب تفاصيل منصة محددة للواجهة العامة (Module 1, 2, 3: Abstraction)
- **المخالفة:** الواجهة الموحدة `IDeviceInfoService` تحتوي على الدالة `getAndroidSdkInt()` الموجهة لـ Android فقط.
- **السبب المعماري:** يجب أن تكون الواجهات عامة (Abstract) ولا تهتم بنوع نظام التشغيل.
- **التوصية:** دمج هذا الرقم داخل `DeviceInfoModel` (مثلاً كمتغير `int? osApiLevel`) وتجنب تخصيص دوال لمنصة محددة في الواجهة العامة.

### ج. عدم توحيد معايير Dart 3 (Module 6: Naming Conventions)
- **المخالفة:** تم تعريف `IDeviceInfoService` كـ `abstract class` فقط.
- **السبب المعماري:** للحفاظ على ثبات هيكلة المشروع (Consistency) ولتطبيق ميزات Dart 3 الجديدة الخاصة بمنع الوراثة (Inheritance).
- **التوصية:** تغيير التعريف ليصبح `abstract interface class IDeviceInfoService` أسوة بباقي الخدمات في التطبيق.

## 3. مخالفات قسم `local_storage` (✅ تم الحل)

بناءً على الفحص المعماري لخدمة `local_storage` مقابل قواعد `ARCHITECTURE_RUBRIC.md`، تُعتبر الخدمة ممتازة من ناحية التجريد (Abstraction) وإخفاء تفاصيل مكتبة Hive تماماً عن باقي أجزاء التطبيق.
ولكن هناك بعض المخالفات المعمارية الدقيقة المتعلقة بنظافة الكود (Clean Code) التي يجب تعديلها:

### أ. عدم الاتساق في تصميم الواجهة (Inconsistent API Design)
- **المخالفة:** دالة `setBoolean` تطلب المتغيرات عن طريق أسماء (Named Parameters) هكذا: `setBoolean({required String key, required bool booleanValue})`. بينما جميع الدوال الأخرى المماثلة في نفس الكلاس (مثل `setString`، `setInt`، `setDouble`) تطلب المتغيرات بشكل مباشر (Positional Parameters).
- **السبب المعماري (UX/DX):** عدم الاتساق (Inconsistency) يكسر مبدأ "التوقع" لدى المطورين ويقلل من جودة تجربة المطور. يجب أن تكون الواجهات البرمجية (APIs) متناسقة وموحدة النمط في طريقة الاستدعاء.
- **التوصية:** تعديل دالة `setBoolean` داخل الـ Interface والـ Implementation لتصبح `Future<void> setBoolean(String key, bool booleanValue);` لتتطابق مع تصميم باقي الدوال.

### ب. عدم توحيد معايير Dart 3 (Module 6: Naming Conventions)
- **المخالفة:** تم تعريف واجهة التخزين كـ `abstract class ILocalStorageService` فقط.
- **السبب المعماري:** للحفاظ على ثبات هيكلة المشروع (Consistency) وتطبيق قواعد Dart 3 الحديثة، يجب إجبار المطورين على استخدام `implements` ومنعهم من استخدام `extends` للواجهات.
- **التوصية:** تعديل التعريف ليصبح `abstract interface class ILocalStorageService` أسوة بباقي الخدمات الحديثة في المشروع.

## 4. قسم `notification` (خدمة الإشعارات)
**النتيجة: مثالية! (0 مخالفات)**
- هذه الخدمة مكتوبة بشكل **ممتاز** معمارياً. الواجهة `INotificationService` نظيفة تماماً ولم تسرب أي تفاصيل أو كلاسات من مكتبة `flutter_local_notifications`، كما أنها التزمت بمعايير Dart 3 واستخدمت `abstract interface class`.

## 5. مخالفات قسم `permissions` (إدارة الصلاحيات) (✅ تم الحل)

### أ. تسريب تفاصيل المكتبات الخارجية في الواجهة (Module 1, 2, 3: Abstraction)
- **المخالفة:** واجهة `IAppPermissionsManager` تعتمد صراحةً على كلاس `Permission` وكلاس `PermissionStatus` واللذان ينتميان لمكتبة خارجية وهي (`permission_handler`).
- **السبب المعماري:** أي ميزة في التطبيق تستدعي الصلاحيات ستكون مرتبطة ارتباطاً وثيقاً بالمكتبة الخارجية. لو قررنا تغيير المكتبة مستقبلاً سينكسر الكود في كل التطبيق (High Coupling).
- **التوصية:** يجب إنشاء Enums خاصة بالتطبيق (مثلاً `AppPermissionType` و `AppPermissionState`) داخل الواجهة، واستخدامها بدلاً من كلاسات المكتبة، على أن يتم تحويلها (Mapping) داخل الـ Implementation فقط.

### ب. عدم توحيد معايير Dart 3 (Module 6: Naming Conventions)
- **المخالفة:** تم تعريف الواجهة كـ `abstract class IAppPermissionsManager` فقط.
- **السبب المعماري:** لضمان الاتساق (Consistency) وتطبيق ميزات Dart 3 لإجبار استخدام الـ `implements` لمنع الوراثة الخاطئة.
- **التوصية:** تعديلها لتصبح `abstract interface class IAppPermissionsManager`.

---
**💡 توضيح معماري هام:** 
- مكان هذه المجلدات (`background`, `device_info`, `local_storage`, `notification`, `permissions`) داخل `lib/core/services/` هو مكان **صحيح تماماً 100%**، لأنها لا تحتوي على طبقة عرض (UI) ولا إدارة حالة (State Management)، بل هي مجرد بنية تحتية (Infrastructure) متاحة لاستخدام كل ميزات التطبيق.
- *تم الاتفاق والنقاش على تجاوز قاعدة (Feature Isolation) فيما يخص كلاس `StorageKeys`، والاحتفاظ به كملف مركزي في الـ Core، نظراً لفائدته العملية القوية في منع تضارب المفاتيح (Key Collisions) وسهولة إدارة التخزين على مستوى التطبيق ككل.*
