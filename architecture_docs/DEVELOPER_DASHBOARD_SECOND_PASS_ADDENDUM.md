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

### 🔴 مخالفة DD1 — Bug حقيقي: كراش صامت للـ Repository عند حدوث `TypeError`
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

### 🔴 مخالفة DD2 — Type Safety: Casting غير آمن للـ Metadata
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

### 🟠 مخالفة DD3 — UX: كتم أخطاء حذف الـ Feedback عند التراجع (Silent Rollback)
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

### 🟡 مخالفة DD4 — Clean Code: استخدام redundantly لـ `unawaited` بالواجهات
**الملف:** [admin_feedback_actions.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/developer_dashboard/presentation/widgets/admin_feedback_actions.dart#L76-L91)

```dart
void _shareFeedback(BuildContext context) {
  unawaited( // ⚠️ دالة shareWidget هي بالفعل unawaited أو لا ترجع Future مستقبلي يجب انتظاره هنا
    WidgetToImageHelper.shareWidget(...),
  );
}
```

**المشكلة:** يزدحم كود الواجهة بـ `unawaited` دون داعٍ حقيقي لأن الدوال المستدعاة لا تحتاج لـ await في السياق المحلي للـ Widget.
