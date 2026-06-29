# تقرير تدقيق معماري — `asma_ul_husna`
**مقارنة بـ ARCHITECTURE_RUBRIC.md | مستوى التدقيق: أقصى دقة**

---

## 📊 ملخص تنفيذي

| الوحدة | الحالة | عدد المخالفات |
|--------|--------|--------------|
| Module 1-3: Fundamentals & SOLID | ⚠️ جزئي | 4 |
| Module 4-5: Software Quality | ⚠️ جزئي | 4 |
| Module 6: Project Organization | ⚠️ جزئي | 3 |
| Module 7: Layering | ❌ مخالفة | 3 |
| Module 8: Flutter Internal | ⚠️ جزئي | 3 |
| Module 9: Data & Communication Flow | ❌ مخالفة | 3 |
| Module 10: Widget Composition | ⚠️ جزئي | 2 |
| Module 11: Reusability & Design System | ✅ جيد | 0 |
| Module 12: Cross-Cutting Concerns | ❌ مخالفة | 4 |
| Module 13: Performance | ⚠️ جزئي | 3 |
| Module 14: Readability | ⚠️ جزئي | 1 |
| **المجموع** | | **32 مخالفة** _(بعد الجولة الثانية)_ |

---

## 🏗️ Module 1-3: Fundamentals, Object Design & SOLID

### ❌ مخالفة #1 — SRP: `AsmaUlHusnaLocalDataSource` تحمل مسؤوليتين
**الملف:** [asma_ul_husna_local_data_source.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart#L8-L13)

```dart
// السطر 8-13: دالة parsing خارج الكلاس تمامًا (top-level function)
List<AsmaulHusnaModel> _parseAsmaUlHusnaJson(String jsonString) { ... }

// ثم الكلاس يستخدمها عبر compute
// المشكلة: الـ parsing logic وال data fetching في نفس الـ class
```

**المشكلة:** الـ `DataSource` مسؤولة عن جلب البيانات من `rootBundle` **و** عن parsing الـ JSON **و** عن الـ caching. هذه ثلاث مسؤوليات.

**الحل:** فصل الـ parsing إلى `AsmaulHusnaModelMapper` أو نقلها داخل الـ `fromJson` في الـ model.

---

### ❌ مخالفة #2 — High Coupling: `AsmaUlHusnaRepoImpl` يستدعي DataSource مباشرةً بدون abstraction
**الملف:** [asma_ul_husna_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart#L18)

```dart
// السطر 18: استدعاء static method مباشر
final names = await AsmaUlHusnaLocalDataSource.getNames();
```

**المشكلة:** الـ `RepoImpl` مرتبط مباشرةً بـ `AsmaUlHusnaLocalDataSource` كـ concrete class ولا يمكن استبدالها (مثلاً بـ RemoteDataSource مستقبلاً) دون تعديل الـ Repo. هذا يكسر مبدأ **Dependency Inversion**.

**الحل:**
```dart
// يجب وجود:
abstract class IAsmaUlHusnaLocalDataSource {
  Future<List<AsmaulHusnaModel>> getNames();
}
// ثم inject عبر constructor
class AsmaUlHusnaRepoImpl implements IAsmaUlHusnaRepository {
  AsmaUlHusnaRepoImpl(this._localDataSource);
  final IAsmaUlHusnaLocalDataSource _localDataSource;
}
```

---

### ❌ مخالفة #3 — SRP + OCP: الـ `getNameOfTheDay` logic في الـ Repository
**الملف:** [asma_ul_husna_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart#L36-L45)

```dart
// السطر 40-42: حساب "اسم اليوم" داخل الـ Repository
final now = DateTime.now();
final dayOfYear = now.difference(DateTime(now.year)).inDays;
return ApiResult.success(names[dayOfYear % names.length]);
```

**المشكلة:** هذا **business logic** (كيف نختار اسم اليوم) موجود في طبقة الـ Data. الـ Repository يجب أن يكون مسؤولاً فقط عن استرجاع البيانات، وليس عن قواعد الأعمال.

**الحل:** نقل هذا الحساب إلى الـ Cubit أو إلى `UseCase` مستقلة.

---

### ❌ مخالفة #4 — SRP: `AsmaUlHusnaCard` تحمل مسؤولية sharing و copying
**الملف:** [asma_ul_husna_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart#L25-L37)

```dart
// السطر 25-31: share logic في widget
Future<void> _shareCard() async {
  await WidgetToImageHelper.shareWidget(...);
}
// السطر 33-37: copy logic في widget
Future<void> _copyToClipboard() async {
  await Clipboard.setData(...);
}
```

**المشكلة:** الـ Widget تحمل UI logic + sharing business logic + clipboard logic. كان يجب أن يكون هذا في الـ Cubit أو service layer.

---

## 🌟 Module 4-5: Software Quality & Scalability

### ❌ مخالفة #5 — Testability: `AsmaUlHusnaLocalDataSource` غير قابلة للاختبار
**الملف:** [asma_ul_husna_local_data_source.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart#L15-L16)

```dart
class AsmaUlHusnaLocalDataSource {
  static List<AsmaulHusnaModel>? _cachedNames; // static state!
  static Future<List<AsmaulHusnaModel>> getNames() async { ... }
```

**المشكلة:** الـ class تعتمد على `static` methods و `static` state. هذا يجعلها:
1. **غير قابلة للـ mock** في الاختبارات
2. **مشتركة** بين كل instances مما يسبب side-effects بين الاختبارات
3. **مرتبطة** بـ `rootBundle` مباشرة (Flutter dependency مصعّبة للاختبار)

---

### ❌ مخالفة #6 — Predictability: الـ `_cachedNames` static يسبب global mutable state
**الملف:** [asma_ul_husna_local_data_source.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart#L16)

```dart
static List<AsmaulHusnaModel>? _cachedNames; // global mutable state
```

**المشكلة:** هذا الـ cache يبقى حيًّا طوال عمر التطبيق ولا يمكن clear-ه. لو تغيرت البيانات (مثلاً update للـ assets) لا يمكن تحديث الـ cache.

---

### ❌ مخالفة #7 — Testability: `getNameOfTheDay` تستخدم `DateTime.now()` مباشرةً
**الملف:** [asma_ul_husna_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart#L40)

```dart
final now = DateTime.now(); // hardcoded dependency على الوقت الحالي
```

**المشكلة:** لا يمكن كتابة unit test يتحكم في التاريخ. يجب inject `DateTimeProvider` أو مشابه.

---

### ❌ مخالفة #8 — Code Duplication: منطق اختيار اسم اليوم مكرر في مكانين
**الملفان:**
- [asma_ul_husna_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart#L40-L42) — السطر 40-42
- [daily_asma_ul_husna_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/card/daily_asma_ul_husna_card.dart#L26-L28) — السطر 26-28

```dart
// في Repository:
final now = DateTime.now();
final dayOfYear = now.difference(DateTime(now.year)).inDays;
return ApiResult.success(names[dayOfYear % names.length]);

// في DailyAsmaUlHusnaCard:
final now = DateTime.now();
final dayOfYear = now.difference(DateTime(now.year)).inDays;
name = state.names[dayOfYear % state.names.length];
```

**المشكلة:** نفس المنطق مكتوب مرتين. لو تغير الحساب (مثلاً استخدام timezone) يجب تعديل مكانين.

---

## 📂 Module 6: Flutter Project Organization

### ❌ مخالفة #9 — Naming Inconsistency: `AsmaulHusnaModel` vs `AsmaUlHusna`
**الملف:** [asmaul_husna_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/data/models/asmaul_husna_model.dart)

**المشكلة:** اسم الملف `asmaul_husna_model.dart` (بدون underscore بين asmaul) بينما كل باقي الملفات تستخدم `asma_ul_husna_*`. يجب أن يكون `asma_ul_husna_model.dart` للـ consistency.

---

### ❌ مخالفة #10 — Missing Barrel Files: لا يوجد export file على مستوى الفيتشر
**الملف:** `asma_ul_husna/` (المجلد الجذر)

**المشكلة:** لا يوجد `index.dart` أو barrel file يُصدّر المكونات العامة للفيتشر (مثل `DailyAsmaUlHusnaCard` الذي يُستخدم من features أخرى). الـ imports من خارج الفيتشر مباشرة إلى ملفات داخلية.

**الدليل:** في [daily_asma_ul_husna_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/card/daily_asma_ul_husna_card.dart) — هذا الـ widget يُستخدم على الأرجح من الـ Dashboard feature مما يعني imports مباشرة لمسارات داخلية.

---

### ❌ مخالفة #11 — Feature Isolation: `daily_asma_ul_husna_card.dart` موجودة في مجلد `widgets/card/` بدون تمييز واضح
**الملف:** [daily_asma_ul_husna_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/card/daily_asma_ul_husna_card.dart)

**المشكلة:** هذا الـ Widget يحتاجه الـ Dashboard feature ولكنه مدفون داخل `asma_ul_husna/presentation/widgets/card/`. مكانه الصحيح إما في `core/common/widgets` أو في `asma_ul_husna` مع barrel file واضحة تُصدّره للعالم الخارجي.

---

## 🧱 Module 7: Layering Concepts

### ❌ مخالفة #12 — Layer Violation: الـ State يعتمد على Data Model مباشرةً
**الملف:** [asma_ul_husna_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/cubit/asma_ul_husna_state.dart#L1)

```dart
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
// الـ presentation layer تستورد من data layer مباشرة!
```

**المشكلة:** طبقة الـ Presentation (الـ State) تعتمد مباشرةً على `AsmaulHusnaModel` من طبقة الـ Data. هذا يكسر مبدأ **Layer Independence** ويعني أن أي تغيير في الـ Data Model يُؤثر مباشرةً على الـ Presentation layer.

**الحل:** يجب وجود **Domain layer** بـ Entity منفصلة، أو على الأقل الـ Model يعمل كـ Entity نظيفة لا تحمل `fromJson`.

---

### ❌ مخالفة #13 — Layer Violation: الـ View تستورد من Data layer مباشرةً
**الملف:** [asma_ul_husna_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/views/asma_ul_husna_view.dart#L8)

```dart
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
// View تعرف عن Data Model!
```

**المشكلة:** الـ View تستورد `AsmaulHusnaModel` من `data/models` مباشرةً. الـ View يجب أن تتعامل فقط مع ما يأتيها من الـ State.

---

### ❌ مخالفة #14 — Layer Violation: الـ DI يستورد الـ Cubit مباشرةً بدلاً من interface
**الملف:** [asma_ul_husna_di.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/di/asma_ul_husna_di.dart#L8)

```dart
..registerFactory<AsmaUlHusnaCubit>(
  () => AsmaUlHusnaCubit(sl<IAsmaUlHusnaRepository>()),
);
```

**المشكلة:** الـ Cubit مسجّل كـ `Factory` مما يعني إنشاء instance جديد في كل مرة. لكن في [asma_ul_husna_view.dart السطر 21](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/views/asma_ul_husna_view.dart#L21) يتم `sl<AsmaUlHusnaCubit>()` داخل `BlocProvider.create`. هذا صحيح من حيث الـ lifecycle ولكن الـ `DailyAsmaUlHusnaCard` الذي يبدو أنه يستخدم `context.read<AsmaUlHusnaCubit>()` يعتمد على أن الـ Cubit مُدار من Ancestor — وهذا coupling غير صريح.

---

## 🌳 Module 8: Flutter Internal Architecture

### ❌ مخالفة #15 — BlocBuilder Scope: `BlocBuilder` يغطي كامل الشجرة
**الملف:** [asma_ul_husna_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/views/asma_ul_husna_view.dart#L26-L53)

```dart
BlocBuilder<AsmaUlHusnaCubit, AsmaUlHusnaState>(
  builder: (context, state) {
    return CustomScrollView( // كامل الـ ScrollView يُعاد بناؤه!
      slivers: [
        const CommonSliverAppBar(...), // لا يحتاج rebuild ولكنه يُعاد بناؤه
        if (state is AsmaUlHusnaLoading) ...
        ...
      ],
    );
  },
),
```

**المشكلة:** الـ `CommonSliverAppBar` لا يعتمد على أي state، ولكنه يُعاد بناؤه في كل مرة يتغير فيها الـ State. الـ `BlocBuilder` يجب أن يكون أضيق نطاقاً.

---

### ❌ مخالفة #16 — BuildContext across async gaps
**الملف:** [asma_ul_husna_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart#L25-L31)

```dart
Future<void> _shareCard() async {
  await WidgetToImageHelper.shareWidget(
    context: context, // context used after potential async gap
    widget: AsmaUlHusnaShareCard(name: widget.name),
    ...
  );
}
```

**المشكلة:** الـ `context` يُمرّر إلى `async` function. إذا تم unmount الـ widget أثناء العملية، سيصبح الـ `context` غير صالح. يجب التحقق من `mounted` قبل الاستخدام.

---

### ❌ مخالفة #17 — BuildContext across async gaps في `DailyAsmaUlHusnaCard`
**الملف:** [daily_asma_ul_husna_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/card/daily_asma_ul_husna_card.dart#L39-L43)

```dart
onSharePressed: () async => WidgetToImageHelper.shareWidget(
  context: context, // context from BlocBuilder - async gap risk
  widget: AsmaUlHusnaShareCard(name: name!),
  ...
),
```

**المشكلة:** نفس المشكلة السابقة — `context` يُستخدم داخل `async` callback بدون `mounted` check.

---

## 🔄 Module 9: Data & Communication Flow

### ❌ مخالفة #18 — Unidirectional Flow مكسور: الـ Cubit لديه حالتان متعارضتان
**الملف:** [asma_ul_husna_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/cubit/asma_ul_husna_state.dart#L15-L29)

```dart
class AsmaUlHusnaLoaded extends AsmaUlHusnaState {
  final List<AsmaulHusnaModel> names;
}

class DailyAsmaUlHusnaLoaded extends AsmaUlHusnaState {
  final AsmaulHusnaModel name;
}
```

**المشكلة:** `AsmaUlHusnaCubit` مسؤول عن **حالتين مستقلتين** تمامًا:
1. تحميل قائمة الأسماء الكاملة (`AsmaUlHusnaLoaded`)
2. تحميل اسم اليوم (`DailyAsmaUlHusnaLoaded`)

هذا يعني أن الـ Cubit الواحد يُستخدم لصفحتين مختلفتين تمامًا (الصفحة الرئيسية للأسماء + الـ Dashboard). مخالفة لـ SRP وتسبب **state conflicts**: لو أُصدر `DailyAsmaUlHusnaLoaded` بينما الـ View الرئيسي مفتوح، ستختفي القائمة!

---

### ❌ مخالفة #19 — State Modeling: لا يستخدم Freezed
**الملف:** [asma_ul_husna_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/cubit/asma_ul_husna_state.dart)

```dart
// Manual sealed classes بدون Freezed
sealed class AsmaUlHusnaState { ... }
class AsmaUlHusnaInitial extends AsmaUlHusnaState { ... }
// لا copyWith، لا == override، لا toString override
```

**المشكلة:** الـ Rubric ينص على: *"State clearly modeled using Freezed or sealed classes"*. الـ sealed classes موجودة لكن بدون:
- `==` و `hashCode` override (الـ `BlocBuilder` لا يستطيع مقارنة States بشكل صحيح)
- `copyWith` للـ partial updates
- `toString` للـ debugging

---

### ❌ مخالفة #20 — Cubit: `loadDailyName` لا يُصدر Loading state
**الملف:** [asma_ul_husna_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart#L22-L30)

```dart
Future<void> loadDailyName() async {
  // لا يوجد emit(const AsmaUlHusnaLoading()) هنا!
  final result = await _repository.getNameOfTheDay();
  ...
}
```

**المشكلة:** `loadNames()` تُصدر `Loading` state ولكن `loadDailyName()` لا تفعل ذلك. هذا inconsistency في الـ state flow — المستخدم لن يرى أي loading indicator لاسم اليوم.

---

## 🧩 Module 10: Widget Composition

### ❌ مخالفة #21 — Smart vs Dumb: `DailyAsmaUlHusnaCard` يخلط الـ UI مع الـ State logic
**الملف:** [daily_asma_ul_husna_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/card/daily_asma_ul_husna_card.dart#L22-L29)

```dart
// منطق اختيار اسم اليوم داخل الـ Widget!
AsmaulHusnaModel? name;
if (state is DailyAsmaUlHusnaLoaded) {
  name = state.name;
} else if (state is AsmaUlHusnaLoaded) {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year)).inDays;
  name = state.names[dayOfYear % state.names.length];
}
```

**المشكلة:** الـ Widget يحتوي على business logic (كيف يختار اسم اليوم من state مختلفة). هذا يجعله Smart Widget بشكل غير مقبول — يجب أن يكون الـ Cubit هو من يحسم ماذا يُصدر.

---

### ❌ مخالفة #22 — Deep Composition: `AsmaUlHusnaShareCard` يبني layout معقد داخل نفسه
**الملف:** [asma_ul_husna_share_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/share_card/asma_ul_husna_share_card.dart#L17-L150)

**المشكلة:** الـ widget ملف واحد بـ 151 سطر يبني كامل الـ share card layout بدون فصل المكونات الفرعية. الـ divider row (السطر 98-123) والـ header row (السطر 55-93) يمكن استخراجهما كـ private widgets أو methods.

---

## ⚙️ Module 12: Cross-Cutting Concerns

### ❌ مخالفة #23 — Error Handling: `Clipboard.setData` بدون error handling
**الملفان:**
- [asma_ul_husna_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart#L33-L37) — السطر 33-37
- [daily_asma_ul_husna_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/card/daily_asma_ul_husna_card.dart#L44-L48) — السطر 44-48

```dart
// في AsmaUlHusnaCard:
Future<void> _copyToClipboard() async {
  await Clipboard.setData(ClipboardData(text: textToCopy));
  // لا يوجد try/catch، لا feedback للمستخدم، لا AppLogger
}

// في DailyAsmaUlHusnaCard:
onCopyPressed: () async {
  await Clipboard.setData(ClipboardData(text: text.trim()));
  // نفس المشكلة
},
```

**المشكلة:** لو فشل `setData` لأي سبب، لن يعلم المستخدم. كذلك لا يوجد SnackBar أو أي feedback للمستخدم بعد النسخ.

---

### ❌ مخالفة #24 — Error Handling: `WidgetToImageHelper.shareWidget` بدون error handling
**الملف:** [asma_ul_husna_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart#L25-L31)

```dart
Future<void> _shareCard() async {
  await WidgetToImageHelper.shareWidget(
    context: context,
    widget: AsmaUlHusnaShareCard(name: widget.name),
    imageName: 'share_asma_${widget.name.id}',
  );
  // لا يوجد try/catch
}
```

**المشكلة:** لو فشلت عملية المشاركة (permissions، disk space، إلخ) لن يُعالج الخطأ.

---

### ❌ مخالفة #25 — Logging: لا يوجد AppLogger في `loadDailyName`
**الملف:** [asma_ul_husna_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart)

```dart
// getNames() تستخدم AppLogger ✅
unawaited(AppLogger.error('GetNames Error', error: e, stackTrace: stack));

// getNameOfTheDay() تفوّض لـ getNames() فقط — لو حدث خطأ آخر لن يُسجَّل ❌
```

**المشكلة:** `getNameOfTheDay` لا تحتوي على أي `try/catch` أو logging خاص. لو حدث خطأ غير متوقع لن يُسجَّل.

---

### ❌ مخالفة #26 — Localization: String literals مدموجة في الكود
**الملف:** [asma_ul_husna_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart#L29)

```dart
imageName: 'share_asma_${widget.name.id}', // string literal
```

**المشكلة:** اسم الملف المشارك مبني كـ string literal مباشر. على الرغم من أنه اسم ملف وليس نصًا مرئيًا، من الأفضل تعريف هذه القيمة في constants.

---

## 🚀 Module 13: Performance-Oriented Architecture

### ❌ مخالفة #27 — BlocBuilder Granularity: `BlocBuilder` يُعيد بناء `CommonSliverAppBar`
**الملف:** [asma_ul_husna_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/views/asma_ul_husna_view.dart#L26-L53)

**المشكلة:** (موضّحة في #15) - الـ `CommonSliverAppBar` يُعاد بناؤه مع كل State change لأنه داخل الـ BlocBuilder.

**الحل:**
```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      const CommonSliverAppBar(title: AppStrings.asmaUlHusna), // خارج BlocBuilder
      BlocBuilder<AsmaUlHusnaCubit, AsmaUlHusnaState>(
        builder: (context, state) => _buildContent(state),
      ),
    ],
  ),
)
```

---

### ❌ مخالفة #28 — Rebuild Awareness: `SkeletonizerLoadingAsmaUlHusnaView` تُنشئ `dummyList` في كل build
**الملف:** [skeletonizer_loading_asma_ul_husna_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/skeletonizer_loading_asma_ul_husna_view.dart#L15-L23)

```dart
@override
Widget build(BuildContext context) {
  final dummyList = List.generate( // يُنشأ في كل build!
    _skeletonItemCount,
    (index) => const AsmaulHusnaModel(...),
  );
```

**المشكلة:** `dummyList` يُنشأ من جديد في كل مرة يتم فيها `build`. يجب أن يكون `static const` أو على الأقل `late final`.

**الحل:**
```dart
static final List<AsmaulHusnaModel> _dummyList = List.generate(
  _skeletonItemCount,
  (index) => const AsmaulHusnaModel(...),
);
```

---

### ❌ مخالفة #29 — const Constructor: `AsmaUlHusnaCard` ليست `const` رغم إمكانية ذلك
**الملف:** [asma_ul_husna_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/views/asma_ul_husna_view.dart#L47)

```dart
itemContentBuilder: (context, name, index) =>
    AsmaUlHusnaCard(name: name), // لا يوجد const
```

**المشكلة:** بما أن `AsmaUlHusnaCard` هي `StatefulWidget`، لا يمكنها أن تكون `const` في هذا السياق نظرًا لأن `name` متغير. لكن المشكلة الأكبر أن الـ card نفسها `StatefulWidget` حيث أن `_isExpanded` يمكن إدارته عبر `ValueNotifier` أو `BlocBuilder` بدلاً من `setState`.

---

## 📊 Module 14: Final Architecture Evaluation

### ❌ مخالفة #30 — Discoverability: هيكل المجلدات غير واضح لـ `card/` و`share_card/`
**الملف:** `presentation/widgets/` structure

```
widgets/
├── asma_ul_husna_card.dart       # ← الكارد الرئيسي
├── skeletonizer_loading_...dart   # ← loading
├── card/
│   └── daily_asma_ul_husna_card.dart  # ← كارد اليومي
└── share_card/
    └── asma_ul_husna_share_card.dart  # ← كارد المشاركة
```

**المشكلة:** `asma_ul_husna_card.dart` في الجذر بينما `daily_asma_ul_husna_card.dart` في `card/` subfolder. هذا يخلق inconsistency — إما كلها في الجذر أو كلها في subfolders.

---

## 🏆 ملخص المخالفات حسب الأولوية

### 🔴 عالية الخطورة (يجب إصلاحها فورًا)
| # | المخالفة | الملف |
|---|----------|-------|
| #2 | DataSource بدون abstraction — يكسر DI | `asma_ul_husna_repository.dart` |
| #5 | Static class غير قابلة للاختبار | `asma_ul_husna_local_data_source.dart` |
| #12 | Presentation تستورد من Data layer | `asma_ul_husna_state.dart` |
| #18 | Cubit واحد لمسؤوليتين — state conflicts! | `asma_ul_husna_state.dart` |
| #20 | `loadDailyName` بدون Loading state | `asma_ul_husna_cubit.dart` |

### 🟠 متوسطة الخطورة
| # | المخالفة | الملف |
|---|----------|-------|
| #1 | SRP مكسور في DataSource | `asma_ul_husna_local_data_source.dart` |
| #3 | Business logic في Repository | `asma_ul_husna_repository.dart` |
| #8 | منطق اسم اليوم مكرر في مكانين | `repository` + `daily_card` |
| #16 | Context across async gap | `asma_ul_husna_card.dart` |
| #17 | Context across async gap | `daily_asma_ul_husna_card.dart` |
| #19 | States بدون Freezed (no `==` override) | `asma_ul_husna_state.dart` |
| #21 | Business logic داخل Widget | `daily_asma_ul_husna_card.dart` |
| #27 | `CommonSliverAppBar` يُعاد بناؤه | `asma_ul_husna_view.dart` |
| #28 | `dummyList` يُنشأ في كل build | `skeletonizer_loading_...dart` |

### 🟡 منخفضة الخطورة
| # | المخالفة | الملف |
|---|----------|-------|
| #4 | Share/Copy logic في Widget | `asma_ul_husna_card.dart` |
| #6 | Global mutable static cache | `asma_ul_husna_local_data_source.dart` |
| #7 | `DateTime.now()` hardcoded | `asma_ul_husna_repository.dart` |
| #9 | Naming inconsistency | `asmaul_husna_model.dart` |
| #10 | لا يوجد barrel files | المجلد الجذر |
| #11 | Daily card في مكان غير مناسب | `widgets/card/` |
| #13 | View تستورد من Data layer | `asma_ul_husna_view.dart` |
| #22 | Widget طويل بلا تقسيم | `asma_ul_husna_share_card.dart` |
| #23 | Copy بدون error handling وبدون feedback | `asma_ul_husna_card.dart` + `daily_card` |
| #24 | Share بدون error handling | `asma_ul_husna_card.dart` |
| #25 | لا logging في `loadDailyName` | `asma_ul_husna_repository.dart` |
| #26 | String literal في الكود | `asma_ul_husna_card.dart` |
| #29 | StatefulWidget حيث StatelessWidget يكفي | `asma_ul_husna_card.dart` |
| #30 | هيكل مجلدات غير متسق | `presentation/widgets/` |
| #31 | `AsmaUlHusnaView` لا تُعالج `Initial` و`DailyAsmaUlHusnaLoaded` — شاشة فارغة! | `asma_ul_husna_view.dart` |
| #32 | `overflow: TextOverflow.ellipsis` مع `maxLines: null` — redundant code | `asma_ul_husna_card.dart` |

---

## 🔍 جولة ثانية — مخالفات إضافية

### 🔴 مخالفة #31 — Unhandled States: `AsmaUlHusnaView` تُخرج شاشة فارغة لحالتين
**الملف:** [asma_ul_husna_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/views/asma_ul_husna_view.dart#L32-L49)

```dart
BlocBuilder<AsmaUlHusnaCubit, AsmaUlHusnaState>(
  builder: (context, state) {
    return CustomScrollView(
      slivers: [
        const CommonSliverAppBar(...),
        if (state is AsmaUlHusnaLoading) ...[ ... ]
        else if (state is AsmaUlHusnaError) ...[ ... ]
        else if (state is AsmaUlHusnaLoaded) ...[ ... ],
        // ← لا يوجد else! حالتان غير معالجتان:
        // 1. AsmaUlHusnaInitial → شاشة فارغة مع AppBar فقط
        // 2. DailyAsmaUlHusnaLoaded → شاشة فارغة تماماً!
      ],
    );
  },
),
```

**المشكلة الحرجة:** توجد **5 حالات** في `AsmaUlHusnaState` ولكن الـ View تُعالج 3 فقط:
- ✅ `AsmaUlHusnaLoading`
- ✅ `AsmaUlHusnaError`
- ✅ `AsmaUlHusnaLoaded`
- ❌ `AsmaUlHusnaInitial` → يُخرج `CustomScrollView` فارغاً (AppBar بدون محتوى)
- ❌ `DailyAsmaUlHusnaLoaded` → **شاشة فارغة!** لو كان المستخدم في الـ Dashboard ثم فتح صفحة الأسماء، سيجدها **فارغة ولن تبدأ الـ loading!**

**السيناريو الحرج:**
1. المستخدم في الـ Dashboard → `loadDailyName()` يُصدر `DailyAsmaUlHusnaLoaded`
2. المستخدم يفتح صفحة الأسماء → الـ Cubit state لا يزال `DailyAsmaUlHusnaLoaded`
3. الـ View تُظهر AppBar فارغاً بدون محتوى ← **UX مكسور!**

**الحل:**
```dart
} else if (state is AsmaUlHusnaInitial || state is DailyAsmaUlHusnaLoaded) ...[
  const SkeletonizerLoadingAsmaUlHusnaView(), // أو إعادة استدعاء loadNames
],
```

---

### 🟡 مخالفة #32 — Redundant Code: `overflow: TextOverflow.ellipsis` مع `maxLines: null`
**الملف:** [asma_ul_husna_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart#L62-L63)

```dart
Text(
  widget.name.meaningBrief,
  maxLines: _isExpanded ? null : 2,       // null عند التوسع
  overflow: TextOverflow.ellipsis,         // ← دائماً مضبوطة حتى مع null!
),
```

**المشكلة:** عند `_isExpanded = true`، الـ `overflow` لا تأثير لها مع `maxLines: null`، لكنها كود مُضلِّل.

**الحل:**
```dart
maxLines: _isExpanded ? null : 2,
overflow: _isExpanded ? null : TextOverflow.ellipsis,
```
