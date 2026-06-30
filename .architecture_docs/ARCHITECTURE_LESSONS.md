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


## 7. فصل المهام بين الـ Data والـ Presentation (SRP)
**الدرس المستفاد من ميزة App Date**

### ❌ المشكلة
الـ `Cubit` كان يقوم بقراءة وتخزين القيم مباشرة من الـ `SharedPreferences` وهذا يخالف مبدأ المسؤولية الواحدة، حيث يجب ألا يعلم الـ Cubit بأي شيء عن الـ Cache أو الـ Database.
```dart
// ❌ خاطئ
final _sharedPref = sl<SharedPreferences>();
final adj = _sharedPref.getInt('hijri_adj') ?? 0;
```

### ✅ الحل
تم إنشاء طبقة `AppDateRepository` مخصصة للتعامل مع البيانات. وأصبح الـ Cubit يتعامل مع الـ Repository عبر (Interface/Abstract class).
```dart
// ✅ صحيح
final adj = _repository.getHijriAdjustment();
```

---

## 8. التعامل مع الأخطاء بدون الاعتماد على طبقات سفلية
**الدرس المستفاد من ميزة App Date**

### ❌ المشكلة
الـ `Cubit` لا يحتوي على معالجة للأخطاء (Error Handling) ويفترض أن الـ SharedPreferences لن تفشل أبداً، أو يتوقع من المطور كتابة `try-catch` حول الـ SharedPrefs.
```dart
// ❌ خاطئ
await _sharedPref.setInt('hijri_adj', value);
```

### ✅ الحل
تم نقل الـ Error Handling للـ Repository الذي يُرجع النتيجة بشكل آمن (مثل `Result.success` أو `Result.failure`). 

---

## 9. معمارية المجلدات (Feature vs Core)
**الدرس المستفاد من ميزة App Date**

### ❌ المشكلة
ميزة `app_date` كانت موجودة بداخل مجلد `core/services/`. الكور (Core) مخصص فقط للأدوات المشتركة التي لا تحتوي على واجهة مستخدم (UI) ولا تحتوي على Business Logic خاص بميزة معينة.

### ✅ الحل
تم نقل `app_date` ليصبح مجلداً مستقلاً بداخل مجلد `features/`، مقسماً بطريقة البنية النظيفة إلى (Data / Domain / Presentation).

---

## 10. تدفق البيانات أحادي الاتجاه (Unidirectional Data Flow)
**الدرس المستفاد من ميزة App Date**

### ❌ المشكلة
في الـ UI، كان يتم تعديل القيم ثم استدعاء دالة بناءً على ذلك بشكل متتالي من داخل الـ `BlocListener`، مما يؤدي إلى دورة تحديث حالة لا نهائية وتداخل في الـ State.
```dart
// ❌ خاطئ
listener: (context, state) {
  if(state.showVerificationDialog) {
    cubit.updateDate(state.date); // تعديل State من داخل الـ Listener!
  }
}
```

### ✅ الحل
يجب أن يكون تدفق البيانات أحادي الاتجاه. الـ UI يستمع فقط (Listens) ويتفاعل (Reacts)، ولا يجب أن يقوم بتعديل الحالة استجابة لتغير الحالة (No recursive emits). تم فصل الأحداث (Events) عن بيانات الحالة، وإصدار حدث `AppDateVerificationDialogRequested` يتفاعل معه الـ UI بفتح الـ Dialog فقط.

---

## 11. إدارة المهام المتكررة (Background Tasks & Timers)
**الدرس المستفاد من ميزة App Date**

### ❌ المشكلة
الـ `AppDateCubit` كان يحتوي على `Timer` يقوم بتحديث اليوم عند منتصف الليل. الـ Cubit يجب أن يهتم فقط بالـ State الخاصة بالـ UI ولا يجب أن يدير Timers بالخلفية.
```dart
// ❌ خاطئ بداخل الـ Cubit
_timer = Timer(duration, updateDate);
```

### ✅ الحل
تم استخراج الـ Timer في خدمة خارجية `IMidnightTimerService`. هذه الخدمة تراقب الوقت وتطلق حدثاً (Stream Event) يستمع إليه الـ Cubit (أو أي كائن آخر) ليقوم بتحديث الحالة بكل بساطة ونظافة.

---

## 12. فصل حالات الواجهة (Smart vs Dumb Widgets)
**الدرس المستفاد من ميزة App Date**

### ❌ المشكلة
الواجهة `HijriAndGregorianDateWidget` كانت واجهة "ذكية" تحتوي على `initState` وتشغل منطق التحقق (Verification) عند بنائها. الـ Widgets الصغرى يجب أن تكون "غبية" (Dumb) مهمتها فقط العرض.
```dart
// ❌ خاطئ بداخل ويدجت العرض
@override
void initState() {
  context.read<AppDateCubit>().checkMonthlyVerification();
}
```

### ✅ الحل
تم حذف الـ `initState` تماماً من الواجهة. الـ `AppDateCubit` هو المسؤول الأول عن المنطق، لذلك تم استدعاء دالة `checkMonthlyVerification` من داخله فور انتهاء التهيئة، لتبقى الواجهة نقية (Pure UI).

---

## 13. قابلية الاختبار (Testability & Side Effects)
**الدرس المستفاد من ميزة App Date**

### ❌ المشكلة
تشغيل دوال أو `Timers` أو سحب بيانات تلقائياً بداخل الـ `Constructor` الخاص بالـ Cubit.
```dart
// ❌ خاطئ
AppDateCubit() {
  _scheduleMidnightUpdate(); // Side-effect
}
```
هذا يجعل كتابة الـ Unit Tests شبه مستحيلة لأن إنشاء الكائن (Instance) سيبدأ الـ Timer فوراً بدون تحكم.

### ✅ الحل
يجب ألا يحتوي الـ Constructor على أي (Side Effects). يجب استخدام دالة `init()` تُستدعى صراحةً من الخارج، أو التخلص من الـ Side effects بالاعتماد على خدمات (Services) خارجية قابلة لعمل Mock لها (مثل Timer Service).

---

## 14. كفاءة الأداء ونطاق بناء الواجهة (Widget Granularity)
**الدرس المستفاد من ميزة App Date**

### ❌ المشكلة
تغليف واجهة كاملة (Column كامل يحتوي على نصوص وعناصر ثابتة) بداخل `BlocBuilder`.
```dart
// ❌ خاطئ
BlocBuilder<AppDateCubit, AppDateState>(
  builder: (context, state) {
    return Column(
      children: [
        Text("عنوان ثابت لا يتغير"), // سيعاد بناؤه
        Button(state.value),
      ]
    );
  }
)
```

### ✅ الحل
تم إنزال الـ `BlocBuilder` لأسفل الشجرة (Down the tree) ليغلف فقط العنصر (Widget) الذي يتغير فعلياً استناداً للحالة، مما يوفر في الأداء.

---

## 15. تكرار الكود والاعتمادية على تفاصيل التنفيذ (Magic Math & DRY)
**الدرس المستفاد من ميزة App Date**

### ❌ المشكلة
تكرار معادلة رياضية مبهمة (Magic Math) في أكثر من مكان داخل الكود (مثلاً لحساب مُعرّف الشهر).
```dart
// ❌ خاطئ (مكرر في أكثر من مكان)
final currentYearMonth = (hijri.year * 100) + hijri.month;
```

### ✅ الحل
استخراج هذه المعادلة وتغليفها بداخل المودل كـ Getter، بحيث يصبح المودل هو المسؤول عن هذه الحسبة، وأي تعديل عليها سيتم في مكان واحد فقط.
```dart
// ✅ صحيح (بداخل المودل AppDateModel)
int get hijriMonthId => (hijri.year * 100) + hijri.month;
```

---

## 16. التجريد وعزل الحزم الخارجية (Abstraction & Package Encapsulation)
**الدرس المستفاد من ميزة App Date**

### ❌ المشكلة
استخدام كلاسات من حزم (Packages) خارجية بشكل مباشر كخصائص داخل الموديلات الأساسية للتطبيق، وتمريرها بين الطبقات.
```dart
// ❌ خاطئ
import 'package:hijri/hijri_calendar.dart';
class AppDateModel {
  final HijriCalendar hijri; // الاعتماد المباشر على الحزمة الخارجية
}
```
إذا تغيرت الحزمة أو أردنا استبدالها، سنضطر لتعديل عشرات الملفات!

### ✅ الحل
تم إنشاء كلاس وسيط `AppHijriDate` يغلف تماماً الكلاس الخارجي. المودل يعرض فقط الـ `AppHijriDate` للـ UI والـ Services الأخرى، وبهذا تنعزل الحزمة الخارجية ولا يتم استيرادها (Import) إلا في ملف واحد فقط.
```dart
// ✅ صحيح
class AppHijriDate {
  final int year;
  final int month;
  // ...
}
class AppDateModel {
  final AppHijriDate hijri; // الحزمة الخارجية مفصولة تماماً
}
```
