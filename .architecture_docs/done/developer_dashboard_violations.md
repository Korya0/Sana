# تقرير تدقيق معماري — `developer_dashboard`
**مقارنة بـ ARCHITECTURE_RUBRIC.md | مستوى التدقيق: أقصى دقة**

---

## 📊 ملخص تنفيذي

| الوحدة | الحالة | عدد المخالفات |
|--------|--------|--------------|
| Module 1-3: Fundamentals & SOLID | ⚠️ جزئي | 3 |
| Module 4-5: Software Quality | ⚠️ جزئي | 2 |
| Module 6: Project Organization | ✅ جيد | 0 |
| Module 7: Layering | ❌ مخالفة | 2 |
| Module 8: Flutter Internal | ⚠️ جزئي | 2 |
| Module 9: Data & Communication Flow | ⚠️ جزئي | 2 |
| Module 10: Widget Composition | ⚠️ جزئي | 1 |
| Module 11: Reusability & Design System | ✅ جيد | 0 |
| Module 12: Cross-Cutting Concerns | ❌ مخالفة | 3 |
| Module 13: Performance | ⚠️ جزئي | 1 |
| Module 14: Readability | ✅ جيد | 0 |
| **المجموع** | | **20 مخالفة** _(بعد الجولة الثانية)_ |

### ✅ ما هو ممتاز في هذا الفيتشر:
- ✅ الـ DI نظيف ومقسم بشكل جيد مع `registerFactory` للـ Cubit.
- ✅ استخدام Optimistic Updates عند حذف الـ Feedback مما يمنح المستخدم تجربة سريعة وخالية من اللمسات الانتظارية.
- ✅ استخدام `RepaintBoundary` لعزل رسم كل كارت Feedback عن الآخرين لضمان سلاسة التمرير.
- ✅ تقسيم الكروت بشكل ذكي ومقروء مثل `FeedbackContent` و `AdminFeedbackActions`.

---

## 🏗️ Module 1-3: Fundamentals, Object Design & SOLID

### ✅ تم الحل #1 — OOP/Equality: `DashboardFeedbackModel` لا يحتوي على `==` و `hashCode`
**الملف:** [dashboard_feedback_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/data/models/dashboard_feedback_model.dart#L4-L38)

```dart
class DashboardFeedbackModel {
  // لا يوجد == override
  // لا يوجد hashCode override
}
```

**المشكلة:** عند مقارنة كائنات الـ Feedback في القوائم أو عند تصفية العناصر (مثال: `currentState.feedbacks.firstWhere((f) => f.id == id)`)، لا تعتمد المقارنة على محتوى الكائن بل على الـ identity الخاصة به بالذاكرة. هذا يصعب من كتابة اختبارات آلية موثوقة (Unit Tests).

**الحل:** توليد دالتي الـ Equality والـ HashCode يدوياً أو باستخدام باقة مثل `equatable`.

---

### ✅ تم الحل #2 — SOLID (SRP): `DashboardCubit` يدمج معالجة الأخطاء والتسجيل وحذف الـ Feedback
**الملف:** [dashboard_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/cubit/dashboard_cubit.dart#L25-L56)

**المشكلة:** الـ Cubit مسؤول عن تحديث حالة الواجهة (UI State) ولكنه يقوم في نفس الوقت بإدارة الـ offline rollback للبيانات وتنسيق عمليات الفشل يدوياً وإعادة الترتيب.

**الحل:** نقل منطق معالجة التراجع (Rollback/Sorting) ليكون داخل الـ Repository أو استخدام State Management مخصص لإدارة طوابير العمليات (Queue Operations).

---

### ✅ تم الحل #3 — Database Design Violation: تسريب نصوص UI معربة إلى قاعدة البيانات
**الملف:** [feedback_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/data/repos/feedback_repository.dart#L36) و [feedback_content.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/widgets/feedback_content.dart#L94-L95)

```dart
// في feedback_repository.dart:
contactInfo: contactInfo ?? AppStrings.notAvailable, // ⚠️ حفظ نص عربي "غير متوفر حالياً" بقاعدة البيانات!

// في feedback_content.dart:
if (feedback.contactInfo.isNotEmpty &&
    feedback.contactInfo != AppStrings.notAvailable)
```

**المشكلة الحرجة:** يتم تخزين ثوابت الواجهة المحلية (Localized UI Strings) مثل `'غير متوفر حالياً'` داخل Firestore. هذا يمنع إمكانية دعم لغات أخرى مستقبلاً (مثل الإنجليزية)، حيث ستظهر البيانات في لوحة الإدارة باللغة العربية دائماً، بالإضافة إلى كونه خرقاً لمبدأ فصل البيانات عن العرض (Separation of Concerns).

**الحل:** حفظ قيمة فارغة `null` أو نص ثابت غير معرب مثل `''` أو `'N/A'` في قاعدة البيانات، وترك مهمة الترجمة للواجهة الرسومية عند القراءة.

---

## 🌟 Module 4-5: Software Quality & Scalability

### ✅ تم الحل #4 — Crash/Race Condition: محاولة الـ `emit` بعد إغلاق الـ Cubit
**الملف:** [dashboard_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/cubit/dashboard_cubit.dart#L35-L54)

```dart
unawaited(
  _repository.deleteFeedback(id).then((result) async {
    switch (result) {
      ...
      case ApiFailure(:final failure):
        // ⚠️ إذا خرج المستخدم من صفحة لوحة الإدارة وتم تدمير الـ Cubit:
        // سيتم استدعاء emit وسيصطدم التطبيق بـ StateError في الـ Production!
        emit(DashboardFeedbacksLoaded(...));
    }
  }),
);
```

**المشكلة الحرجة:** دالة حذف الـ Feedback تستخدم `unawaited` وتنتظر النتيجة من الشبكة عبر `.then()`. إذا قام المستخدم بحذف تعليق ثم ضغط زر "رجوع" فوراً للخروج من الصفحة، يتم إغلاق الـ Cubit. عند اكتمال عملية الشبكة (سواء بالفشل أو النجاح وبدء التراجع Rollback)، سيحاول الـ Cubit إطلاق `emit` على كائن مغلق مما يسبب كراش صريح (`StateError: Cannot emit new states after calling close`).

**الحل:** إضافة شرط التحقق قبل الـ `emit`:
```dart
if (isClosed) return;
emit(DashboardFeedbacksLoaded(...));
```

---

### ✅ تم الحل #5 — Hardcoded Fallback: قيم افتراضية مشفرة في كود الـ Model
**الملف:** [dashboard_feedback_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/data/models/dashboard_feedback_model.dart#L19-L23)

```dart
message: json[FeedbackFirestoreKeys.message] as String? ?? '',
contactInfo: json[FeedbackFirestoreKeys.contactInfo] as String? ?? '',
```

**المشكلة:** استخدام السلاسل الفارغة `''` مباشرة في نموذج البيانات كقيم بديلة افتراضية بدلاً من تمثيلها كـ `nullable` (مثل `String?`).

---

## 🧱 Module 7: Layering Concepts

### ✅ تم الحل #6 — Layer Violation: اعتماد مباشر للـ Presentation على الـ Data Models
**الملف:** [feedback_admin_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/widgets/feedback_admin_card.dart#L4)

```dart
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';
```

**المشكلة:** يفتقر هذا الفيتشر لطبقة الـ Domain. تعتمد الواجهات (Widgets) بشكل مباشر على الـ Data Models المسؤولة عن الـ Serialization والـ JSON parsing.

**الحل:** تقديم `Feedback` Entity مستقلة ومجردة في طبقة Domain، وجعل نموذج `DashboardFeedbackModel` يمتد منها في طبقة الـ Data.

---

### ✅ تم الحل #7 — Layer Violation: الـ DI يربط الـ Presentation بـ Firestore عبر الـ DataSource
**الملف:** [dashboard_di.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/di/dashboard_di.dart#L10)

```dart
..registerLazySingleton<IDashboardRemoteDataSource>(
  () => DashboardRemoteDataSource(sl<FirebaseFirestore>()),
)
```

**المشكلة:** على الرغم من صحة الـ Dependency Injection، فإن تسريب كائنات Firestore مباشرة إلى الـ Remote DataSource دون وسيط للشبكة يعقد استبدال محرك البيانات مستقبلاً.

---

## 🌳 Module 8: Flutter Internal Architecture

### ✅ تم الحل #8 — BuildContext across async gap: تمرير الـ Context في عمليات الحذف والنسخ والمشاركة
**الملف:** [admin_feedback_actions.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/widgets/admin_feedback_actions.dart#L59-L90)

```dart
// في دالة المشاركة:
void _shareFeedback(BuildContext context) {
  unawaited(
    WidgetToImageHelper.shareWidget(
      context: context, // ⚠️ خطر فجوة برمجية متزامنة!
      widget: shareChild,
      imageName: 'feedback_${feedback.id}',
    ),
  );
}
```

**المشكلة:** يتم تمرير الـ `context` إلى دوال مشاركة وتصوير الـ Widgets التي تستغرق وقتاً طويلاً للمعالجة بشكل غير متزامن دون فحص `context.mounted`. إذا تم تدمير الـ Widget أثناء معالجة الصورة، قد يؤدي ذلك إلى أخطاء متعلقة بـ memory leaks أو كراش بسبب استخدام سياق غير صالح.

**الحل:** استخدام `if (!context.mounted) return;` قبل أي عملية تستعمل الـ `context` بعد انتظار الـ async.

---

### ✅ تم الحل #9 — Redundant Rebuilds: عدم استخدام `const` في الـ `SizedBox` والـ `SliverToBoxAdapter`
**الملف:** [feedbacks_list_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/widgets/feedbacks_list_view.dart#L64)

```dart
return const SliverToBoxAdapter(child: SizedBox.shrink()); // ⚠️ تم تصحيحها ولكن يجب الانتباه للـ SizedBox الأخرى
```

---

## 🔄 Module 9: Data & Communication Flow

### ✅ تم الحل #10 — Unidirectional Flow: معالجة حالة الـ Toast من داخل الـ Dialog وليس الـ Bloc
**الملف:** [admin_feedback_actions.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/widgets/admin_feedback_actions.dart#L66-L72)

```dart
onConfirm: () {
  context.read<DashboardCubit>().deleteFeedback(feedback.id);
  AppToast.show( // ⚠️ إطلاق رسالة النجاح فورياً ومن داخل الـ View!
    context,
    AppStrings.deletedSuccessfully,
  );
},
```

**المشكلة:** يتم عرض رسالة النجاح (Toast) بمجرد طلب الحذف دون انتظار تأكيد من الـ Cubit أو الـ Repository بنجاح العملية حقيقةً، وبصرف النظر عن حالة الفشل اللاحقة (التي ستقوم بعمل Rollback سري دون إعلام المستخدم بـ Toast آخر يعلمه بفشل الحذف!).

**الحل:** يجب أن يرسل الـ Cubit حالة نجاح/فشل (UI Side Effect) وتستمع لها الـ View لعرض الرسالة المناسبة.

---

### ✅ تم الحل #11 — State Equality missing: الـ UI سيعيد البناء بشكل غير ضروري
**الملف:** [dashboard_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/cubit/dashboard_state.dart#L3-L24)

```dart
sealed class DashboardState {
  const DashboardState();
}
// ⚠️ لا يوجد Equatable أو overrides لدالتي == و hashCode!
```

**المشكلة:** أي استدعاء لـ `emit` لحالة شبيهة بالحالة الحالية سيتسبب في إعادة بناء كامل شجرة واجهة المستخدم بلا فائدة لأن Dart سيعتبرهما حالتين مختلفتين بناءً على عنوان الذاكرة.

---

## 🧩 Module 10: Widget Composition

### ✅ تم الحل #12 — Tight Coupling: الـ Card مرتبطة مباشرةً بهيكل الـ Actions
**الملف:** [feedback_admin_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/widgets/feedback_admin_card.dart#L34-L39)

```dart
AdminFeedbackActions(
  feedback: feedback,
  shareChild: FeedbackShareCard(
    feedback: feedback,
  ),
),
```

**المشكلة:** الكارت يعلم بشكل تفصيلي بالـ `AdminFeedbackActions` والـ `FeedbackShareCard`. هذا يصعب إعادة استخدام نفس الكرت لعرض الـ Feedback في شاشات أخرى لا تتطلب الحذف أو المشاركة (مثلاً لوحة عرض سريعة للمستخدم).

---

## ⚙️ Module 12: Cross-Cutting Concerns

### ✅ تم الحل #13 — Unhandled Security Risk: مسار GoRouter للوحة الإدارة مكشوف تماماً وبدون حماية (Guard Bypass)
**الملف:** [developer_dashboard_routes.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/routes/developer_dashboard_routes.dart#L10-L27)

```dart
GoRoute(
  path: AppRoutes.developerDashboard,
  name: AppRoutes.developerDashboard,
  pageBuilder: (context, state) => AppTransitions.fade(
    ...
    child: BlocProvider(
      create: (context) => sl<DashboardCubit>()..getFeedbacks(), // ⚠️ يفتح ويحمل فوراً!
      child: const DeveloperDashboardView(),
    ),
  ),
)
```

**المشكلة الحرجة:** بينما تحتوي صفحة الإعدادات على حماية حركية عبر `SecretPinDialog` قبل إطلاق الـ navigation، فإن المسار الفعلي في الـ GoRouter `/developer-dashboard` لا يحتوي على **أي حماية أو Middleware**. أي مستخدم يقوم بعمل deep-link أو يكتب الرابط مباشرة بالمتصفح (kIsWeb) سيستطيع الدخول للوحة الإدارة وقراءة وحذف تعليقات المستخدمين وسيرفراتهم دون أيPIN.

**الحل:** وضع `redirect` guard داخل الـ Route نفسه للتحقق من مصادقة الـ PIN أو تخزين حالة أمان داخل الـ Session.

---

### ✅ تم الحل #14 — Unhandled Exception Risk: عمليات الـ Clipboard و الـ Share بلا حماية أو صيد للأخطاء
**الملف:** [admin_feedback_actions.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/widgets/admin_feedback_actions.dart#L76-L90)

```dart
void _copyFeedbackToClipboard(BuildContext context) {
  unawaited(
    Clipboard.setData(ClipboardData(text: feedback.message)), // ⚠️ قد تفشل على الويب أو الأجهزة المقيدة بدون صيد!
  );
}
```

**المشكلة:** لا يوجد `try/catch` للتعامل مع الفشل عند النسخ أو المشاركة بالـ GPU.

---

### ✅ تم الحل #15 — UX Violation: غياب إشعار تأكيد النسخ للذاكرة المؤقتة (No Clipboard Toast)
**الملف:** [admin_feedback_actions.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/widgets/admin_feedback_actions.dart#L86-L90)

**المشكلة:** عند ضغط زر النسخ، يتم نسخ النص ولكن دون إظهار أي إشعار أو SnackBar يعلم الإدارة بأن النص تم نسخه بنجاح، مما يربك تجربة المستخدم.

---

## 🚀 Module 13: Performance-Oriented Architecture

### ✅ تم الحل #16 — Performance Waste: إنشاء كروت المشاركة بشكل مسبق ومسرف (Eager Instantiation)
**الملف:** [feedback_admin_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/widgets/feedback_admin_card.dart#L36-L38)

```dart
AdminFeedbackActions(
  feedback: feedback,
  shareChild: FeedbackShareCard( // ⚠️ يُنشأ لكل كارت بالقائمة مسبقاً!
    feedback: feedback,
  ),
),
```

**المشكلة:** دالة المشاركة تحتاج الـ `FeedbackShareCard` فقط عند الضغط على زر المشاركة. ولكن الكود الحالي يقوم بإنشاء كائن الـ Widget المعقد `FeedbackShareCard` بشكل مسبق ومباشر لكل عنصر يظهر في القائمة (حتى لو لم يضغط المسؤول على زر المشاركة أبداً). هذا يستهلك الذاكرة والـ CPU بلا داعٍ.

**الحل:** استبدال الـ Widget بـ callback أو دالة بناء كسولة (Lazy Builder) أو إنشاؤه داخل دالة المشاركة ذاتها:
```dart
// في admin_feedback_actions.dart:
void _shareFeedback(BuildContext context) {
  unawaited(
    WidgetToImageHelper.shareWidget(
      context: context,
      widget: FeedbackShareCard(feedback: feedback), // يُنشأ فقط عند الطلب!
      imageName: 'feedback_${feedback.id}',
    ),
  );
}
```

---

## 🔍 جولة ثانية — مخالفات إضافية

### ✅ تم الحل #17 — Bug حقيقي: كراش صامت للـ Repository عند حدوث `TypeError` في الـ JSON Parsing
**الملف:** [dashboard_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/data/repos/dashboard_repository.dart#L20-L36)

```dart
@override
Future<ApiResult<List<DashboardFeedbackModel>>> getFeedbacks() async {
  try {
    final feedbacks = await _remoteDataSource.getFeedbacks();
    return ApiResult.success(feedbacks);
  } on Exception catch (e, stack) { // ⚠️ يمسك Exception فقط!
    ...
  }
}
```

**المشكلة الحرجة:** الـ Remote DataSource يقوم بعمل parsing للـ JSON بداخل دالة `getFeedbacks`. إذا احتوت إحدى الوثائق في Firestore على بيانات غير متطابقة أو نوع خاطئ، ستقوم دالة الـ factory برمي `TypeError` (وهو من نوع `Error` في Dart وليس `Exception`). لأن الـ Repo يمسك الـ `Exception` فقط، سيتخطى الخطأ الـ try/catch وينهار تدفق البيانات بالكامل دون إصدار `ApiResult.failure`. سيظل الـ Cubit عالقاً في حالة `DashboardFeedbacksLoading` (تحميل مستمر) ولن يعلم المستخدم بحدوث خطأ.

**الحل:** تغيير الصيد ليمسك `Object` بدلاً من `Exception`:
```dart
} on Object catch (e, stack) {
```

---

### ✅ تم الحل #18 — Type Safety: Casting غير آمن للـ Metadata في الـ Model
**الملف:** [dashboard_feedback_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/data/models/dashboard_feedback_model.dart#L22-L23)

```dart
metadata:
    json[FeedbackFirestoreKeys.metadata] as Map<String, dynamic>? ?? {},
```

**المشكلة:** في Firebase SDK على الويب أو بعض المنصات، قد يتم تمثيل الخرائط المتداخلة كـ `Map<dynamic, dynamic>` بدلاً من `Map<String, dynamic>`. إجراء cast مباشر بـ `as Map<String, dynamic>?` سيتسبب في إلقاء `TypeCastException` وكراش صريح للـ parsing.

**الحل:** استخدام دالة تحويل آمنة:
```dart
metadata: json[FeedbackFirestoreKeys.metadata] != null
    ? Map<String, dynamic>.from(json[FeedbackFirestoreKeys.metadata] as Map)
    : {},
```

---

### ✅ تم الحل #19 — UX: كتم أخطاء حذف الـ Feedback عند التراجع (Silent Rollback)
**الملف:** [dashboard_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/cubit/dashboard_cubit.dart#L41-L52)

```dart
case ApiFailure(:final failure):
  // ⚠️ يكتفي بطباعة السجل في الـ AppLogger بصمت دون إخبار الإدري في الواجهة!
  await AppLogger.error(...);
  emit(DashboardFeedbacksLoaded(...)); // التراجع وإرجاع العنصر المحذوف
```

**المشكلة:** عند فشل حذف الـ Feedback من السيرفر، يقوم الـ Cubit بإعادة العنصر المحذوف للقائمة (Rollback) بصمت دون إظهار أي SnackBar أو رسالة تحذيرية للمسؤول تشرح أن عملية الحذف فشلت بسبب انقطاع الشبكة أو غيره. سيجد المسؤول العنصر قد عاد فجأة وكأنه شبح!

**الحل:** إطلاق Side Effect للواجهة لإظهار إشعار خطأ يوضح سبب التراجع.

---

### ✅ تم الحل #20 — Clean Code: استخدام redundantly لـ `unawaited` بالواجهات
**الملف:** [admin_feedback_actions.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/widgets/admin_feedback_actions.dart#L76-L91)

```dart
void _shareFeedback(BuildContext context) {
  unawaited( // ⚠️ دالة shareWidget هي بالفعل unawaited أو لا ترجع Future مستقبلي يجب انتظاره هنا
    WidgetToImageHelper.shareWidget(...),
  );
}
```

**المشكلة:** يزدحم كود الواجهة بـ `unawaited` دون داعٍ حقيقي لأن الدوال المستدعاة لا تحتاج لـ await في السياق المحلي للـ Widget.

```


# ملحق جولة ثانية — مخالفات developer_dashboard
**يُكمل: DEVELOPER_DASHBOARD_VIOLATIONS.md**

---

## 🔍 ملخص ما تم اكتشافه في الجولة الثانية لـ `developer_dashboard`

| # | المخالفة | التصنيف | الخطورة |
|---|----------|---------|---------|
| DD1 | **كراش صامت وتعليق واجهة التحميل عند حدوث TypeError في الـ Parsing** | Bug حقيقي 🔴 | عالي |
| DD2 | **Casting غير آمن لخرائط Firestore المتداخلة (Type Cast Exception)** | Type Safety 🔴 | عالي |
| DD3 | **كتم أخطاء الحذف عن المستخدم عند التراجع (Silent Rollback)** | User Experience 🟠 | متوسط |
| DD4 | **تكرار غير مبرر لـ unawaited في الواجهات** | Clean Code 🟡 | منخفض |

---

## 🔍 التفاصيل الفنية للمخالفات الإضافية

### ✅ تم الحل DD1 — Bug حقيقي: كراش صامت للـ Repository عند حدوث `TypeError`
**الملف:** [dashboard_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/data/repos/dashboard_repository.dart#L20-L36)

```dart
@override
Future<ApiResult<List<DashboardFeedbackModel>>> getFeedbacks() async {
  try {
    final feedbacks = await _remoteDataSource.getFeedbacks();
    return ApiResult.success(feedbacks);
  } on Exception catch (e, stack) { // ⚠️ يمسك Exception فقط!
    ...
  }
}
```

**المشكلة الحرجة:** الـ Remote DataSource يقوم بعمل parsing للـ JSON بداخل دالة `getFeedbacks`. إذا احتوت إحدى الوثائق في Firestore على بيانات غير متطابقة أو نوع خاطئ، ستقوم دالة الـ factory برمي `TypeError` (وهو من نوع `Error` في Dart وليس `Exception`). لأن الـ Repo يمسك الـ `Exception` فقط، سيتخطى الخطأ الـ try/catch وينهار تدفق البيانات بالكامل دون إصدار `ApiResult.failure`. سيظل الـ Cubit عالقاً في حالة `DashboardFeedbacksLoading` (تحميل مستمر) ولن يعلم المستخدم بحدوث خطأ.

**الحل:**
تغيير الصيد ليمسك `Object` بدلاً من `Exception`:
```dart
} on Object catch (e, stack) {
```

---

### ✅ تم الحل DD2 — Type Safety: Casting غير آمن للـ Metadata
**الملف:** [dashboard_feedback_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/data/models/dashboard_feedback_model.dart#L22-L23)

```dart
metadata:
    json[FeedbackFirestoreKeys.metadata] as Map<String, dynamic>? ?? {},
```

**المشكلة:** في Firebase SDK على الويب أو بعض المنصات، قد يتم تمثيل الخرائط المتداخلة كـ `Map<dynamic, dynamic>` بدلاً من `Map<String, dynamic>`. إجراء cast مباشر بـ `as Map<String, dynamic>?` سيتسبب في إلقاء `TypeCastException` وكراش صريح للـ parsing.

**الحل:** استخدام دالة تحويل آمنة:
```dart
metadata: json[FeedbackFirestoreKeys.metadata] != null
    ? Map<String, dynamic>.from(json[FeedbackFirestoreKeys.metadata] as Map)
    : {},
```

---

### ✅ تم الحل DD3 — UX: كتم أخطاء حذف الـ Feedback عند التراجع (Silent Rollback)
**الملف:** [dashboard_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/cubit/dashboard_cubit.dart#L41-L52)

```dart
case ApiFailure(:final failure):
  // ⚠️ يكتفي بطباعة السجل في الـ AppLogger بصمت دون إخبار الإدري في الواجهة!
  await AppLogger.error(...);
  emit(DashboardFeedbacksLoaded(...)); // التراجع وإرجاع العنصر المحذوف
```

**المشكلة:** عند فشل حذف الـ Feedback من السيرفر، يقوم الـ Cubit بإعادة العنصر المحذوف للقائمة (Rollback) بصمت دون إظهار أي SnackBar أو رسالة تحذيرية للمسؤول تشرح أن عملية الحذف فشلت بسبب انقطاع الشبكة أو غيره. سيجد المسؤول العنصر قد عاد فجأة وكأنه شبح!

**الحل:** إطلاق Side Effect للواجهة لإظهار إشعار خطأ يوضح سبب التراجع.

---

### ✅ تم الحل DD4 — Clean Code: استخدام redundantly لـ `unawaited` بالواجهات
**الملف:** [admin_feedback_actions.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/widgets/admin_feedback_actions.dart#L76-L91)

```dart
void _shareFeedback(BuildContext context) {
  unawaited( // ⚠️ دالة shareWidget هي بالفعل unawaited أو لا ترجع Future مستقبلي يجب انتظاره هنا
    WidgetToImageHelper.shareWidget(...),
  );
}
```

**المشكلة:** يزدحم كود الواجهة بـ `unawaited` دون داعٍ حقيقي لأن الدوال المستدعاة لا تحتاج لـ await في السياق المحلي للـ Widget.
