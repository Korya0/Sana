# تقرير شامل بمخالفات معمارية الكود (Sharing Service)

تم إجراء **فحص عميق بثلاث مراحل متتالية (3 Passes Exhaustive Review)** على جميع ملفات قسم `sharing` ومطابقتها حرفياً مع معايير `ARCHITECTURE_RUBRIC.md`.

إليك النتيجة الشاملة بنسبة 100% للمخالفات المعمارية في هذا القسم:

## 💡 التوصية المعمارية الرئيسية

كما هو الحال مع `location_manager`، يحتوي قسم `sharing` على مجلد `presentation` مليء بالـ Widgets. وجود واجهة مستخدم (UI) داخل `core/services` يتنافى مع مبدأ أن الخدمات يجب أن تكون (Pure Logic Utilities). 
**يجب نقل مكونات الواجهة إلى `core/common/widgets` أو تحويل القسم لـ Feature مستقلة.**

---

## 📋 قائمة المخالفات المكتشفة

### 🏗️ Module 1 & 7: Layering Concepts & Separation of Concerns

1. **مخالفة (Semantic Layer Boundaries) وخلط مفاهيم الشبكة بالمحلي:**
   - **الملف:** `i_share_service.dart` و `share_service.dart`
   - **السبب:** واجهة `IShareService` ترجع النتيجة كـ `Future<ApiResult<bool>>`. استخدام `ApiResult` (المخصص حصرياً لردود الشبكة والـ APIs) لعملية مشاركة محلية على نظام التشغيل (OS Intent) هو كسر صريح لمسؤوليات الطبقات ومفاهيمها المعمارية. يجب استخدام نوع `Result` أو `Either` عام بدلاً من `ApiResult`.

2. **مخالفة (Separation of Concerns) وتنفيذ أوامر في طبقة العرض:**
   - **الملف:** `widget_to_image_helper.dart` (في دالة `shareWidget`)
   - **السبب:** هذا الكلاس موجود في `presentation/utils/`، ويفترض أن تكون مسؤوليته الوحيدة التقاط صورة من الـ Widget (UI Utility). ولكنه يتجاوز مسؤوليته ويقوم باستدعاء خدمة المشاركة `sl<IShareService>().shareImage`! يجب أن يكتفي بالالتقاط، ويترك لمنطق الـ Cubit مسؤولية إرسال الصورة للمشاركة.

### 🌟 Module 4 & 5: Software Quality & Scalability

3. **مخالفة (Testability) و (Dependency Injection):**
   - **الملف:** `widget_to_image_helper.dart`
   - **السبب:** استخدام مباشر לـ Service Locator من خلال `sl<IShareService>()` داخل كلاس مساعد للواجهة (UI Helper). هذا يكسر مبدأ حقن الاعتماديات (DI) ويجعل الكلاس صعباً جداً في الـ Unit Testing.

4. **مخالفة (Race Conditions & Timer Leaks) والتأثير على حالة الواجهة:**
   - **الملف:** `combined_share_copy_button.dart` (سطر 41)
   - **السبب:** عند النقر، يتم إطلاق مؤقت `Future.delayed(const Duration(seconds: 2))` دون إدارته. إذا قام المستخدم بالنقر عدة مرات متتالية، سيتم إطلاق عدة مؤقتات تتسابق لتغيير الـ State (`_showCopyIcon`) بشكل فوضوي. كان يجب استخدام متغير `Timer` وإلغاؤه `timer?.cancel()` عند كل نقرة جديدة لضمان (Predictability).

5. **مخالفة (Maintainability) واستخدام (Magic Numbers):**
   - **الملفات:** موزعة في القسم.
   - **السبب:** 
     - مدة `2 seconds` في `combined_share_copy_button.dart`.
     - تأخيرات `500ms` و `100ms` مقولبة كأرقام سحرية في دالة الالتقاط.
     - قياسات `_kDefaultWidth = 500` في حاوية الكروت.

6. **مخالفة (Predictability & Error Handling):**
   - **الملف:** `share_service.dart`
   - **السبب:** دالة `shareImage` تلتقط أي استثناء `Exception` وتحوله فوراً إلى خطأ مجهول `UnknownFailure` مع رسالة عامة `AppStrings.sharingError`. هذا يخفي السبب الجذري للخطأ (مثل رفض المستخدم للصلاحية أو فشل الذاكرة) عن باقي التطبيق.

7. **مخالفة (High Cohesion) والاعتماد المباشر على الإضافات:**
   - **الملف:** `share_service.dart`
   - **السبب:** الاعتماد الثابت والمباشر على `SharePlus.instance.share` داخلياً بدلاً من حقنه أو تغليفه، مما يجعل من المستحيل عمل Unit Test لكلاس `ShareServiceImpl` بدون عمل Mock عميق لمكتبة خارجية ثابتة (Static).

9. **مخالفة (Hardcoded Values in Models):**
   - **الملف:** `share_config.dart`
   - **السبب:** يحتوي المودل على قيمة افتراضية ثابتة `imageName = 'shared_content'`. وضع قيم ثابتة (Hardcoded Defaults) داخل النماذج يقلل من قابليتها للاستخدام في سيناريوهات مختلفة، وكان يجب أن تأتي من طبقة الـ Configuration الثابتة.

10. **مخالفة (Testability / Dependency Injection) في مكونات الالتقاط:**
    - **الملف:** `widget_to_image_helper.dart`
    - **السبب:** دالة `capture` تقوم بإنشاء كائن الالتقاط داخلياً `final controller = ScreenshotController();`. هذا التكوين المباشر (Hardcoded Instantiation) يمنع حقن الاعتماديات (DI) ويجعل الـ Unit Testing شبه مستحيل.

11. **مخالفة (Platform Constraints Leakage):**
    - **الملف:** `widget_to_image_helper.dart`
    - **السبب:** الكود يحتوي على فحص صريح للمنصة `kIsWeb` لتحديد مدة التأخير `delay`. تسريب تفاصيل المنصة (Platform Checks) داخل كود عام للواجهة يُعتبر مخالفة معمارية، وكان الأفضل تمرير قيمة التأخير كـ Parameter من مكان أعلى.

12. **مخالفة (Hardware Side-Effects in UI Components):**
    - **الملف:** `combined_share_copy_button.dart`
    - **السبب:** يقوم الـ Widget باستدعاء دوال اهتزاز الجهاز (Hardware Haptics) مباشرة `playVibrate()` و `playDoubleVibrate()`. طبقة الـ Presentation يجب ألا تتعامل مع العتاد مباشرة، بل ترسل الحدث أو تستخدم خدمة Haptic محقونة.

13. **مخالفة (Design System Consistency / Color Tokens):**
    - **الملف:** `app_info_share.dart`
    - **السبب:** الكود يقوم بتوليد ألوان ودرجات شفافية جديدة برمجياً باستخدام `withValues(alpha: 0.3)`. هذا يخالف معيار (Design System)؛ حيث يجب أن تكون الدرجات معرّفة مسبقاً في الـ Theme كـ Tokens لضمان توحيد التصميم.

14. **مخالفة (Predictability in Factory Methods):**
    - **الملف:** `share_config.dart`
    - **السبب:** الـ Factory method المسمى `from` يقوم بإرجاع `null` بدلاً من كائن إذا كانت المدخلات مطابقة للقيم الافتراضية. هذا السلوك مبهم (Unexpected Behavior) ويؤدي إلى أخطاء (Null Pointer) في الأجزاء التي تتوقع كائناً.

15. **مخالفة (Responsive UI & Screen Overflow):**
    - **الملف:** `share_card_container.dart`
    - **السبب:** تحديد عرض ثابت `width: 500.r` سيتسبب حتماً في طفح الشاشة (RenderFlex Overflow) على الأجهزة الصغيرة (عرضها 320-430 بكسل). كان يجب الاعتماد على القيود المرنة `BoxConstraints(maxWidth: ...)` أو نسبة من عرض الشاشة.

16. **مخالفة (UI/UX Error Feedback & Error Swallowing):**
    - **الملف:** `widget_to_image_helper.dart`
    - **السبب:** عند فشل عملية المشاركة `ApiFailure()`، تقوم دالة `shareWidget` بإرجاع `false` بصمت تام (Swallowing the Error) دون عرض أي إشعار (Snackbar/Toast) للمستخدم، مما يخالف معايير التغذية الراجعة (Feedback).

17. **مخالفة (Return Type Abstraction & Result Hiding):**
    - **الملف:** `widget_to_image_helper.dart`
    - **السبب:** اختزال نتيجة العمليات المعقدة في `Future<bool>` يمنع الطبقة الأعلى من معرفة سبب الخطأ الفعلي (مثل رفض الصلاحية أو امتلاء الذاكرة). كان يجب إرجاع `Result Object` أو رمي Exception مخصص.

### 📂 Module 6: Flutter Project Organization

8. **مخالفة (Barrel Files & Export Strategy):**
   - **الملفات:** المجلد ككل.
   - **السبب:** لا يوجد أي ملف `index.dart` لتجميع الـ Exports. يتم استدعاء الكلاسات (الـ Widgets والـ Config والـ Service) بمساراتها العميقة من قِبل الأقسام الأخرى.

---
**خلاصة الفحص الثلاثي:** تم تأكيد أن هذا القسم يعاني أيضاً من مشاكل في فصل الطبقات (استدعاء الـ Services من الـ UI Helpers)، وتسريب مفاهيم الشبكة إلى الوظائف المحلية للعتاد، مع وجود ثغرات في أداء الـ UI عبر استخدام `Future.delayed` غير مدارة.
