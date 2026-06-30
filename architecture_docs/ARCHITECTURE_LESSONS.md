# 📚 دروس معمارية أثناء التطوير (Learn While Coding)

هذا الملف مخصص لتوثيق كل المبادئ المعمارية والقرارات البرمجية التي اتخذناها أثناء تنظيف وتطوير التطبيق. الهدف منه هو أن يكون مرجعاً تعليمياً لك ولأي مطور يعمل على هذا المشروع لفهم "لماذا" قمنا بكتابة الكود بهذه الطريقة وليس فقط "كيف".

---

## 1. الكلاسات الثابتة (Static Classes) مقابل الدوال الحرة (Top-level Functions) والـ (Extensions)
**المكان الذي طبقنا فيه هذا المبدأ:** مجلد `core/utils` ومجلد `core/networking`

### ❌ المشكلة (أسلوب Java القديم)
في اللغات القديمة مثل Java، يجب أن يكون كل شيء داخل كلاس. لذلك اعتاد المبرمجون على إنشاء كلاسات وهمية (Utility Classes) تحتوي فقط على دوال `static` مثل:
```dart
class AppFeedback {
  AppFeedback._();
  static void playVibrate() { ... }
}
```
هذا الأسلوب يُعتبر **Anti-Pattern** (ممارسة سيئة) في الدليل الرسمي للغة Dart لأنه يضيف كوداً زائداً لا داعي له، والكلاسات صُممت في الأساس ليُؤخذ منها نسخ (Instances) وتحتفظ بحالة (State). هذا الأسلوب جيد فقط في مجلد `constants` لتنظيم النصوص الكثيرة.

### ✅ الحل (الطريقة الموصى بها في Dart & Flutter)
لغة Dart قوية جداً وتدعم الدوال الحرة، والأسلوب الموصى به لمعمارية حديثة هو:
1. **استخدام الدوال المباشرة (Top-level Functions):** للمهام المستقلة تماماً.
   ```dart
   void playVibrate() { ... }
   ```
2. **استخدام الإضافات (Extensions):** إذا كانت الدالة تُعدل على نوع موجود (مثل `DateTime` أو `String` أو `BuildContext`).
   ```dart
   extension VersionComparison on String {
     bool isVersionLessThan(String latest) { ... }
   }
   ```
   **ميزة الـ Extensions:** تجعل استكشاف الدوال (Discoverability) أسهل بكثير! بمجرد أن تكتب `text.` سيقترح عليك الـ IDE الدالة `isVersionLessThan()`، والكود يقرأ بشكل طبيعي جداً (كاللغة الإنجليزية).

---

## 2. تبسيط جمل الـ Switch وتقليل التكرار (Simplicity & OCP Principle)
**المكان الذي طبقنا فيه هذا المبدأ:** `api_error_handler.dart` و `religious_event_display_names.dart`

### ❌ المشكلة
كتابة `switch` طويلة جداً تقوم في النهاية بإرجاع نفس الكائن أو عمل نفس الوظيفة باختلافات طفيفة. هذا الكود يصعب قراءته ويزيد من حجم الملف بلا مبرر.
```dart
switch (statusCode) {
  case 400:
  case 401:
    return ServerFailure(message: "خطأ", statusCode: statusCode);
  case 500:
    return ServerFailure(message: "خطأ", statusCode: statusCode);
}
```

### ✅ الحل
* **في حالة الـ API:** إذا كانت كل حالات الردود الخاطئة تُرجع `ServerFailure`، قمنا بالاستغناء عن الـ `switch` بالكامل وإرجاع الخطأ مباشرة، فالتبسيط هو أحد أهم قواعد الـ Clean Code.
* **في حالة تحويل النصوص (مثل ReligiousEvent):** الأفضل هو استخدام `Enum` مدمج ببيانات، أو `Map` بدلاً من الـ `switch` ليصبح البحث `O(1)` (مباشر) بدلاً من المرور على شروط كثيرة، وهذا يحقق مبدأ (Open/Closed Principle).

---

## 3. التخلص من الـ Factory Constructors الزائدة مع Sealed Classes
**المكان الذي طبقنا فيه هذا المبدأ:** `failure.dart`

### ❌ المشكلة
في السابق (قبل Dart 3)، كان المبرمجون يستخدمون `factory constructors` لمحاكاة الـ (Union Types) لأن لغة Dart لم تكن تدعمها بشكل كامل. ولكن مع دعم Dart 3 للـ `sealed classes`، أصبح هذا التكرار عبئاً. وجود دالة `Factory` مهمتها الوحيدة هي إعادة توجيهك إلى الكلاس الموروث يسبب تشتتاً للمبرمجين (هل أستخدم Factory أم الكلاس مباشرة؟).

### ✅ الحل
حذف كل دوال الـ `factory` من الكلاس الأساسي والاعتماد المباشر الموحد على الكلاسات الموروثة (Subclasses) مثل `NetworkFailure`. هذا يوحد طريقة كتابة الكود (Standardization) عبر المشروع بأكمله ويقلل الأسطر المكتوبة بنسبة كبيرة.

---

## 4. ❌ Anti-Pattern: Side-effects في Cubit Constructors [G2]
**المخالفة المرصودة في:** `AzkarCategoriesCubit`, `DailyContentCubit`, `ReminderCubit`, `HadithFavoritesCubit`

### ❌ المشكلة
```dart
// ❌ خاطئ — side-effect في الـ constructor
MyFeatureCubit(this._repo) : super(const MyFeatureInitial()) {
  unawaited(loadData()); // يُشغَّل فور إنشاء الـ Cubit!
}
```
استدعاء عملية async في الـ constructor يجعل Unit Testing شبه مستحيل — أي اختبار يُنشئ الـ Cubit سيُشغّل العملية فوراً كـ side-effect غير متحكَّم فيه. كما أنه يخفي اعتمادات الـ Cubit ويجعل التتبع أصعب.

### ✅ الحل الصحيح الموحد
```dart
// ✅ صحيح — إطلاق التحميل من BlocProvider.create في الـ Route
BlocProvider(
  create: (context) => sl<MyFeatureCubit>()..loadData(),
  child: const MyFeatureView(),
)
```
هذا يُبقي الـ Cubit نظيفاً قابلاً للاختبار ويعطي التحكم للـ Presenter/Route بدلاً من الـ Cubit نفسه.

---

## 5. ⚠️ قاعدة واجبة: `isClosed` check قبل كل `emit` async [G3]
**المخالفة المرصودة في:** `AzkarCategoriesCubit`, `AzkarCategoryLoaderCubit`, `PrayerTimesCubit`, `DailyContentCubit`

### ❌ المشكلة
```dart
Future<void> loadData() async {
  emit(const Loading());
  final result = await _repository.getData(); // ← await هنا!
  // ⚠️ إذا تم إغلاق الـ Cubit أثناء الـ await، هذا كراش:
  emit(Loaded(result)); // StateError: Cannot emit after close
}
```
**هذا كراش حقيقي في الـ Production** — يحدث عند Navigation سريعة أو إغلاق مفاجئ للـ Widget.

### ✅ القاعدة الواجبة
**أي Cubit يقوم بعملية async يجب دائماً إضافة `if (isClosed) return;` بعد كل نقطة `await`:**
```dart
Future<void> loadData() async {
  if (isClosed) return; // ← في البداية
  emit(const Loading());
  final result = await _repository.getData();
  if (isClosed) return; // ← بعد كل await
  emit(Loaded(result)); // آمن الآن ✅
}
```
كذلك في Timer callbacks:
```dart
Timer(duration, () {
  if (isClosed) return; // ← ضروري قبل أي شيء
  unawaited(loadData());
});
```

---

## 6. 🔧 Cross-Cutting: `Clipboard.setData` يجب أن يكون عبر Service موحد [G5]
**المخالفة المرصودة في:** `asma_ul_husna`, `azkar`, `daily_content`, `developer_dashboard`, `hadith_search`, `prayer`

### ❌ المشكلة — مكررة في 6+ ميزات
```dart
// في كل ميزة بشكل مستقل وبدون error handling:
Future<void> _copyText(BuildContext context) async {
  await Clipboard.setData(ClipboardData(text: text));
  // ❌ لا try/catch — لا SnackBar — لا AppLogger — لا mounted check!
}
```

### ✅ الحل الموحد — `ClipboardService` في `core/services/`
```dart
// core/services/clipboard/clipboard_service.dart
class ClipboardService {
  static Future<bool> copyText(
    BuildContext context,
    String text, {
    String? successMessage,
  }) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      if (context.mounted) {
        AppToast.showSuccess(context, successMessage ?? AppStrings.copied);
      }
      return true;
    } on Exception catch (e, stack) {
      unawaited(AppLogger.error('Copy failed', error: e, stackTrace: stack));
      return false;
    }
  }
}
```
هذا يحل المشكلة **في كل الميزات بتعديل مركزي واحد** بدلاً من إصلاح 6+ أماكن بشكل متفرق.

---

