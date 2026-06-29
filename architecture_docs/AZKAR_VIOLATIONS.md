# تقرير تدقيق معماري — `azkar`
**مقارنة بـ ARCHITECTURE_RUBRIC.md | مستوى التدقيق: أقصى دقة**

---

## 📊 ملخص تنفيذي

| الوحدة | الحالة | عدد المخالفات |
|--------|--------|--------------|
| Module 1-3: Fundamentals & SOLID | ⚠️ جزئي | 4 |
| Module 4-5: Software Quality | ⚠️ جزئي | 4 |
| Module 6: Project Organization | ⚠️ جزئي | 2 |
| Module 7: Layering | ❌ مخالفة | 3 |
| Module 8: Flutter Internal | ⚠️ جزئي | 3 |
| Module 9: Data & Communication Flow | ⚠️ جزئي | 2 |
| Module 10: Widget Composition | ✅ جيد جداً | 0 |
| Module 11: Reusability & Design System | ✅ جيد | 0 |
| Module 12: Cross-Cutting Concerns | ⚠️ جزئي | 3 |
| Module 13: Performance | ⚠️ جزئي | 1 |
| Module 14: Readability | ✅ جيد | 0 |
| **المجموع** | | **27 مخالفة** _(بعد الجولة الثانية)_ |

> **ملاحظة:** مقارنةً بـ `asma_ul_husna` (30 مخالفة)، الـ `azkar` feature أفضل تصميماً بشكل ملحوظ. أبرز التحسينات:
> - ✅ يوجد `IAzkarLocalDataSource` (interface للـ DataSource)
> - ✅ الـ DI صحيح ويستخدم interface
> - ✅ تقسيم الـ Cubits لمسؤوليات منفصلة (3 cubits لـ 3 مهام)
> - ✅ `buildWhen` مُستخدم في `ZikrItemCard`
> - ✅ Widget decomposition ممتاز في `zikr_card/`

---

## 🏗️ Module 1-3: Fundamentals, Object Design & SOLID

### ❌ مخالفة #1 — SRP: `AzkarLocalDataSource` تحمل مسؤولية الـ sorting
**الملف:** [azkar_local_data_source.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/data/datasources/azkar_local_data_source.dart#L36-L57)

```dart
// السطر 36-57: sorting logic داخل DataSource!
final priorityIds = {'2', '3', '5', '4', '1'};
final sortedList = <AzkarCategoryModel>[];
final othersList = <AzkarCategoryModel>[];
// ...
_cachedCategories = [...sortedList, ...othersList];
```

**المشكلة:** الـ DataSource مسؤوليتها **جلب البيانات الخام فقط**. منطق الترتيب (أيّ الفئات تأتي أولاً) هو **business logic** يجب أن يكون في الـ Repository أو UseCase. لو تغيّر ترتيب الأولويات، يجب تعديل الـ DataSource وهذا خطأ.

**الحل:** إرجاع البيانات الخام من الـ DataSource، ونقل sorting logic إلى `AzkarRepoImpl.getAllCategories()`.

---

### ❌ مخالفة #2 — SRP: `ZikrItemCard` تحمل مسؤولية الـ sharing
**الملف:** [zikr_item_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/widgets/zikr_item_card.dart#L70-L79)

```dart
Future<void> _shareCard() async {
  await WidgetToImageHelper.shareWidget(
    context: context,
    widget: ZikrShareCard(...),
    imageName: 'zikr_share',
  );
}
```

**المشكلة:** الـ Widget Card تحتوي على sharing logic مباشرةً. هذا يجعلها Smart Widget بأكثر من مسؤولية: عرض الذكر + التفاعل مع العداد + المشاركة.

---

### ❌ مخالفة #3 — SRP: `ZikrActionsRow` تحتوي على Clipboard logic مباشرةً
**الملف:** [zikr_actions_row.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/widgets/zikr_card/zikr_actions_row.dart#L30-L32)

```dart
onCopyPressed: () async {
  await Clipboard.setData(ClipboardData(text: text)); // مباشر في Widget
},
```

**المشكلة:** منطق النسخ موجود مباشرةً في الـ Widget بدلاً من أن يُمرَّر كـ callback من الخارج (مثلما يُمرَّر `onShare`). هذا inconsistency في التصميم: `onShare` يأتي من الخارج ولكن `onCopy` مُدمج داخلياً.

**الحل:** إضافة `onCopy` كـ parameter مثل `onShare` ثم تمريره من `ZikrItemCard`.

---

### ❌ مخالفة #4 — OCP مكسور: `AzkarUIHelpers` يستخدم hardcoded String IDs
**الملف:** [azkar_ui_helpers.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/utils/azkar_ui_helpers.dart#L10-L34)

```dart
static const Map<String, IconData> _categoryIcons = {
  '1': FlutterIslamicIcons.solidTasbihHand,
  '2': SolarIconsBold.sunrise,
  // ... IDs كـ String literals '1', '2', '3'...
};
```

**المشكلة:**
1. استخدام **String IDs مباشرة** (`'1'`, `'2'`) بدلاً من constants. لو تغيّر الـ ID في الـ JSON، لن يكون هناك خطأ في compile-time.
2. لإضافة فئة جديدة يجب تعديل هذا الـ Map (يكسر Open/Closed Principle).
3. يجب تعريف IDs كـ constants في `AzkarKeys`.

---

## 🌟 Module 4-5: Software Quality & Scalability

### ❌ مخالفة #5 — Testability: الـ `_cachedCategories` static يسبب global mutable state
**الملف:** [azkar_local_data_source.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/data/datasources/azkar_local_data_source.dart#L21)

```dart
static List<AzkarCategoryModel>? _cachedCategories;
```

**المشكلة:** الـ static cache يعني:
1. لا يمكن إنشاء instances منفصلة لاختبارات مستقلة (state يتسرب بين tests).
2. الـ cache لا يمكن تفريغه أو إبطاله.
3. في بيئة الاختبار، لو اختبار حمّل البيانات، الاختبار التالي سيجد الـ cache ممتلئاً.

**الحل:** تحويل الـ cache إلى instance variable بدلاً من static.

---

### ❌ مخالفة #6 — Testability: `AzkarCategoriesCubit` يُطلق `loadAzkar()` في الـ constructor
**الملف:** [azkar_categories_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/cubit/azkar_categories_cubit.dart#L32-L34)

```dart
AzkarCategoriesCubit(this._repository)
  : super(const AzkarCategoriesInitial()) {
  unawaited(loadAzkar()); // side effect في الـ constructor!
}
```

**المشكلة:** أي side-effect في الـ constructor يجعل unit testing أصعب. `unawaited` داخل constructor خطير لأنه لا يمكن awaiting-ه في الاختبارات.

**الحل:** إطلاق الـ load من الـ `BlocProvider.create` في الـ View:
```dart
create: (context) => AzkarCategoriesCubit(sl<IAzkarRepository>())..loadAzkar(),
```

---

### ❌ مخالفة #7 — Code Inconsistency: State classes مدموجة في ملف الـ Cubit في ملفين
**الملفات:**
- [azkar_categories_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/cubit/azkar_categories_cubit.dart#L8-L28)
- [azkar_category_loader_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/cubit/azkar_category_loader_cubit.dart#L7-L27)

**المشكلة:** اتساق الكود مكسور:
- `AzkarListCubit` ← له `azkar_list_state.dart` منفصل ✅
- `AzkarCategoriesCubit` ← States مدموجة في نفس الملف ❌
- `AzkarCategoryLoaderCubit` ← States مدموجة في نفس الملف ❌

---

### ❌ مخالفة #8 — BUG حقيقي: `firstWhere` يرمي `StateError` غير مُصطاد
**الملف:** [azkar_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/data/repos/azkar_repository.dart#L47-L59)

```dart
try {
  final item = categories.firstWhere((e) => e.id == id);
  return ApiResult.success(item);
} on Exception catch (e, stack) {
  // ⚠️ يصطاد Exception فقط!
  // لكن firstWhere يرمي StateError (يرث من Error وليس Exception)!
  ...
}
```

**المشكلة الحرجة:** `firstWhere` عند عدم وجود العنصر يرمي **`StateError`** وهو `Error` وليس `Exception`. `on Exception catch` **لن يصطاده** مما يُسبّب crash غير معالج.

**الحل:**
```dart
final item = categories.firstWhereOrNull((e) => e.id == id);
if (item == null) {
  return const ApiResult.failure(MissingDataFailure(...));
}
return ApiResult.success(item);
```

---

## 📂 Module 6: Flutter Project Organization

### ❌ مخالفة #9 — Naming Inconsistency: State classes في ملفات الـ Cubit
راجع مخالفة #7 — نفس المشكلة من منظور التنظيم.

---

### ❌ مخالفة #10 — Missing Barrel Files: لا توجد barrel files
**المشكلة:** لا يوجد `index.dart` على مستوى الفيتشر. لو أراد فيتشر آخر استخدام أي widget أو cubit من `azkar`، سيضطر للـ import المباشر لمسارات داخلية.

---

## 🧱 Module 7: Layering Concepts

### ❌ مخالفة #11 — Layer Violation: Presentation States تستورد Data Models
**الملف:** [azkar_categories_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/cubit/azkar_categories_cubit.dart#L4)

```dart
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
// Presentation layer تعتمد مباشرة على Data Model!
```

**المشكلة:** الـ State تحمل `List<AzkarCategoryModel>` من `data/models`. أي تغيير في الـ Model يؤثر مباشرةً على الـ State وعلى كل الـ Widgets.

---

### ❌ مخالفة #12 — Layer Violation: `AzkarListView` تستورد `AzkarCategoryModel` من Data layer
**الملف:** [azkar_list_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/views/azkar_list_view.dart#L8)

```dart
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
```

**المشكلة:** الـ View تستورد وتحمل `AzkarCategoryModel` كـ parameter. الـ View يجب أن تتلقى البيانات من الـ State فقط.

---

### ❌ مخالفة #13 — Layer Violation: الـ Routes تفحص نوع Data Model
**الملف:** [azkar_routes.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/routes/azkar_routes.dart#L5-L22)

```dart
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
...
if (extra is AzkarCategoryModel) { ... } // فحص Data Model في Router!
```

**المشكلة:** الـ Router يفحص نوع بيانات من Data layer. هذا coupling بين الـ Routing layer وتفاصيل الـ Data layer.

---

## 🌳 Module 8: Flutter Internal Architecture

### ❌ مخالفة #14 — BuildContext across async gaps: `_handleExit`
**الملف:** [azkar_list_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/views/azkar_list_view.dart#L69-L93)

```dart
Future<void> _handleExit(BuildContext context) async {
  final state = context.read<AzkarListCubit>().state;
  if (hasProgress && !isCompleted) {
    await CustomConfirmationDialog.show( // ← async gap
      context, // ← context بعد await!
      ...
      onConfirm: () => context.pop(), // ← context بعد async gap
    );
  }
}
```

**المشكلة:** `context` يُستخدم بعد `await` بدون `mounted` check.

---

### ❌ مخالفة #15 — BuildContext across async gaps: `_shareCard`
**الملف:** [zikr_item_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/widgets/zikr_item_card.dart#L70-L79)

```dart
Future<void> _shareCard() async {
  await WidgetToImageHelper.shareWidget(
    context: context, // بدون mounted check
    ...
  );
}
```

**المشكلة:** `context` يُمرَّر لعملية async بدون `if (!mounted) return;`.

---

### ❌ مخالفة #16 — Widget Lifecycle: `animateTo` بعد async gap داخل `Future.delayed`
**الملف:** [azkar_list_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/views/azkar_list_view.dart#L42-L66)

```dart
Future<void>.delayed(const Duration(milliseconds: 300), () async {
  if (!mounted) return; // check أولي ✅
  if (_scrollController.hasClients) {
    ...
    await _scrollController.animateTo(...); // async بعد الـ check!
    // لو تم dispose أثناء animation؟
  }
}),
```

**المشكلة:** يوجد `mounted` check قبل الـ animation (✅)، لكن لو تم dispose الـ widget أثناء الـ animation نفسها، سيستخدم controller مُدمَّر.

---

## 🔄 Module 9: Data & Communication Flow

### ❌ مخالفة #17 — State Modeling: States بدون Freezed (غياب `==` و `hashCode`)
**الملفات:** كل ملفات الـ State

**المشكلة:** الـ Rubric ينص على: *"State clearly modeled using Freezed or sealed classes"*. الـ `sealed classes` موجودة لكن بدون `==` و `hashCode` override. هذا يعني أن `BlocBuilder` لا يستطيع مقارنة states بشكل صحيح.

> **استثناء جزئي:** `AzkarListInProgress` لديها `copyWith` مما يُشير لمحاولة تطبيق الـ pattern، لكن بشكل غير مكتمل.

---

### ❌ مخالفة #18 — State Flow: `AzkarDetailsLoaderView` يُساوي Initial بـ Loading في الـ UI
**الملف:** [azkar_details_loader_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/views/azkar_details_loader_view.dart#L43-L45)

```dart
// AzkarCategoryLoaderInitial تُعالَج مثل Loading:
return const Scaffold(
  body: Center(child: CircularProgressIndicator()), // نفس معالجة Loading!
);
```

**المشكلة:** `Initial` و `Loading` حالتان مختلفتان دلالياً. معاملتهما بنفس الطريقة في الـ UI يُخفي أخطاء محتملة — لو لم يتم استدعاء `loadCategory` لأي سبب، سيظل المستخدم يرى loading للأبد.

---

## ⚙️ Module 12: Cross-Cutting Concerns

### ❌ مخالفة #19 — Error Handling: `Clipboard.setData` بدون error handling أو feedback
**الملف:** [zikr_actions_row.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/widgets/zikr_card/zikr_actions_row.dart#L30-L32)

```dart
onCopyPressed: () async {
  await Clipboard.setData(ClipboardData(text: text));
  // لا try/catch، لا SnackBar، لا AppLogger
},
```

---

### ❌ مخالفة #20 — Error Handling: `_shareCard` بدون error handling
**الملف:** [zikr_item_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/widgets/zikr_item_card.dart#L70-L79)

```dart
Future<void> _shareCard() async {
  await WidgetToImageHelper.shareWidget(...);
  // لا try/catch
}
```

---

### ❌ مخالفة #21 — Error Handling: `AzkarLocalDataSource` تُرجع `[]` بدلاً من رمي Exception
**الملف:** [azkar_local_data_source.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/data/datasources/azkar_local_data_source.dart#L59-L68)

```dart
} on Exception catch (e, stackTrace) {
  unawaited(AppLogger.error(...));
  return []; // خطأ مُخفَى! الـ Repository سيعتبره missing data
}
```

**المشكلة:** إرجاع `[]` يُخفي الخطأ الحقيقي. يجب رمي Exception أو تعريف Exception مخصصة لتُعالَج في الـ Repository بشكل صحيح.

---

## 🚀 Module 13: Performance-Oriented Architecture

### ❌ مخالفة #22 — Widget Design: `ZikrContent` يستخدم `isSharing` flag بدلاً من subclasses
**الملف:** [zikr_content.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/widgets/zikr_card/zikr_content.dart#L11-L55)

```dart
class ZikrContent extends StatelessWidget {
  const ZikrContent({
    ...
    this.isSharing = false, // flag يُغيّر سلوك الـ Widget كلياً
  });
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isSharing
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          style: isSharing
              ? AppTextStyles.fontQuran26W400White(context)...
              : AppTextStyles.font20W700(context)...,
```

**المشكلة:** استخدام `isSharing` boolean flag يجعل الـ Widget تحمل حالتين مختلفتين تماماً. يُفضَّل استخدام composition أو named constructor أو widget منفصل للـ sharing context.

---

## 🏆 ملخص المخالفات حسب الأولوية

### 🔴 عالية الخطورة (يجب إصلاحها فورًا)
| # | المخالفة | الملف |
|---|----------|-------|
| **#8** | `firstWhere` يرمي `StateError` غير مُصطاد — **BUG حقيقي!** | `azkar_repository.dart` |
| **#11** | Presentation States تستورد Data Models مباشرةً | `azkar_categories_cubit.dart` |
| **#14** | `context` بعد async gap بدون `mounted` check | `azkar_list_view.dart` |

### 🟠 متوسطة الخطورة
| # | المخالفة | الملف |
|---|----------|-------|
| **#1** | Sorting logic في DataSource | `azkar_local_data_source.dart` |
| **#5** | Static cache — global mutable state | `azkar_local_data_source.dart` |
| **#6** | Side-effect في constructor | `azkar_categories_cubit.dart` |
| **#12** | View تستورد Data Model | `azkar_list_view.dart` |
| **#13** | Routes تفحص نوع Data Model | `azkar_routes.dart` |
| **#15** | `context` في async بدون `mounted` | `zikr_item_card.dart` |
| **#17** | States بدون `==` override | كل ملفات الـ State |
| **#21** | DataSource تُرجع `[]` بدلاً من Exception | `azkar_local_data_source.dart` |

### 🟡 منخفضة الخطورة
| # | المخالفة | الملف |
|---|----------|-------|
| **#2** | Share logic مدموج في Widget | `zikr_item_card.dart` |
| **#3** | Copy logic مدموج داخلياً (inconsistency) | `zikr_actions_row.dart` |
| **#4** | Hardcoded String IDs | `azkar_ui_helpers.dart` |
| **#7** | State classes في ملف الـ Cubit | `azkar_categories_cubit.dart` + `loader_cubit.dart` |
| **#10** | لا barrel files | المجلد الجذر |
| **#16** | Scroll animation بدون mounted check كافٍ | `azkar_list_view.dart` |
| **#18** | Initial = Loading في UI | `azkar_details_loader_view.dart` |
| **#19** | Copy بدون error handling | `zikr_actions_row.dart` |
| **#20** | Share بدون error handling | `zikr_item_card.dart` |
| **#22** | `isSharing` flag يُغيّر Widget كلياً | `zikr_content.dart` |

---

## 📈 مقارنة مع `asma_ul_husna`

| الجانب | asma_ul_husna | azkar | التقييم |
|--------|--------------|-------|---------|
| DataSource Interface | ❌ لا يوجد | ✅ `IAzkarLocalDataSource` | azkar أفضل |
| DI صحيح | ⚠️ جزئي | ✅ كامل | azkar أفضل |
| تقسيم الـ Cubits | ❌ Cubit واحد لمسؤوليتين | ✅ 3 cubits منفصلة | azkar أفضل |
| `buildWhen` | ❌ غائب | ✅ موجود في `ZikrItemCard` | azkar أفضل |
| Widget Decomposition | ⚠️ متوسط | ✅ ممتاز (`zikr_card/`) | azkar أفضل |
| State files منفصلة | ✅ دائماً | ⚠️ أحياناً | asma_ul_husna أفضل |
| Layer Violations | 3 | 3 | متساويان |
| Static Cache | ❌ | ❌ | كلاهما يحتاج إصلاح |
| Error Handling | ❌ | ❌ | كلاهما يحتاج إصلاح |
| **عدد المخالفات** | **30** | **22** | **azkar أفضل بـ 8 مخالفات** |

---

## 🔍 جولة ثانية — مخالفات إضافية

### 🔴 مخالفة #23 — Anti-Pattern: `AzkarListState` base class تحتوي على methods تخص subclass فقط
**الملف:** [azkar_list_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/cubit/azkar_list_state.dart#L3-L49)

```dart
sealed class AzkarListState {
  // ← كل هذه الـ methods تعمل فقط لو `this is AzkarListInProgress`!
  bool isZikrCompleted(int index) {
    if (this is AzkarListInProgress) { ... } // تفحص subclass من الـ base!
    return false;
  }
  bool get isAllCompleted {
    if (this is AzkarListInProgress) { ... }
    return false;
  }
  bool get hasProgress { ... }    // نفس النمط
  int getCurrentCount(int index) { ... }  // نفس النمط
  double getProgress(int index) { ... }   // نفس النمط
}
```

**المشكلة:** هذا **انتهاك صريح للـ OOP**:
1. الـ base class تعرف عن تفاصيل subclass معينة (`AzkarListInProgress`) وتفحصها بـ `is`
2. هذه الـ methods لا معنى لها في `AzkarListInitial` أو `AzkarListCompleted` — ترجع `false/0` دائماً
3. المكان الصحيح هو نقلها إلى `AzkarListInProgress` مباشرة

**الحل:**
```dart
// نقل كل الـ methods إلى AzkarListInProgress:
class AzkarListInProgress extends AzkarListState {
  bool isZikrCompleted(int index) { ... } // معناها واضح الآن
  bool get isAllCompleted { ... }
  // ...
}
// واستخدام pattern matching في الـ widget:
if (state case AzkarListInProgress s) {
  final isCompleted = s.isZikrCompleted(widget.index);
}
```

---

### 🟠 مخالفة #24 — Performance: **Double `RepaintBoundary`** يُلغي فائدته
**الملفان:**
- [azkar_list_content.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/widgets/azkar_list_content.dart#L21) — السطر 21
- [zikr_item_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/widgets/zikr_item_card.dart#L102) — السطر 102

```dart
// في AzkarListContent:
itemContentBuilder: (context, zikr, index) => RepaintBoundary( // ← RepaintBoundary #1
  child: ZikrItemCard(...),
),

// داخل ZikrItemCard.build():
return RepaintBoundary( // ← RepaintBoundary #2 (مكرر!)
  child: GestureDetector(...),
);
```

**المشكلة:** طبقتان متضاختتان من `RepaintBoundary` تعني ضعف compositing layers في الـ GPU بدون فائدة.

**الحل:** حذف `RepaintBoundary` من `AzkarListContent` والاعتماد على الموجود في `ZikrItemCard`:
```dart
itemContentBuilder: (context, zikr, index) => ZikrItemCard(...), // بدون RepaintBoundary
```

---

### 🟠 مخالفة #25 — Performance/UX: `TweenAnimationBuilder` يبدأ من 0 في كل rebuild
**الملف:** [zikr_counter.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/widgets/zikr_card/zikr_counter.dart#L37-L38)

```dart
TweenAnimationBuilder<double>(
  tween: Tween<double>(begin: 0, end: progress), // ← begin دائماً 0!
  duration: const Duration(milliseconds: 300),
)
```

**المشكلة:** في كل ضغطة، تنشأ `Tween` جديد بـ `begin: 0` خلاف القيمة الحالية — النتيجة: animation regression في كل ضغطة.

**الحل:** تحويل `ZikrCounter` إلى `StatefulWidget` مع `AnimationController` للتحكم الكامل في الـ tween begin/end.

---

### 🟡 مخالفة #26 — DI Bypass: `AzkarListCubit()` يُنشأ مباشرةً بدون `sl<>`
**الملف:** [azkar_list_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/presentation/views/azkar_list_view.dart#L98)

```dart
create: (context) => AzkarListCubit()..loadAzkar(widget.category),
// ← تجاوز sl<AzkarListCubit>() رغم تسجيله في DI!
```

**بينما في `azkar_di.dart`:**
```dart
..registerFactory<AzkarListCubit>(AzkarListCubit.new), // مسجّل ولكن لا يُستخدم!
```

**المشكلة:** inconsistency واضح مع باقي الـ Views في نفس الفيتشر.

**الحل:**
```dart
create: (context) => sl<AzkarListCubit>()..loadAzkar(widget.category),
```

---

### 🟡 مخالفة #27 — Magic Values: Priority IDs كـ hardcoded Set
**الملف:** [azkar_local_data_source.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/azkar/data/datasources/azkar_local_data_source.dart#L37)

```dart
final priorityIds = {'2', '3', '5', '4', '1'}; // ← magic strings!
```

**المشكلة:** IDs مكتوبة يدوياً دون constants — لو تغيّر الـ JSON لن يكون هناك compile-time error.

**الحل:** تعريفها كـ constants في `AzkarKeys`:
```dart
static const Set<String> priorityCategoryIds = {'1', '2', '3', '4', '5'};
```
