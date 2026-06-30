# تقرير تدقيق معماري — `feedback`
**مقارنة بـ ARCHITECTURE_RUBRIC.md | مستوى التدقيق: أقصى دقة**

---

## 📊 ملخص تنفيذي

| الوحدة | الحالة | عدد المخالفات |
|--------|--------|--------------|
| Module 1-3: Fundamentals & SOLID | ⚠️ جزئي | 2 |
| Module 4-5: Software Quality | ⚠️ جزئي | 3 |
| Module 6: Project Organization | ✅ جيد | 0 |
| Module 7: Layering | ❌ مخالفة | 2 |
| Module 8: Flutter Internal | ❌ مخالفة | 2 |
| Module 9: Data & Communication Flow | ⚠️ جزئي | 1 |
| Module 10: Widget Composition | ✅ جيد | 0 |
| Module 11: Reusability & Design System | ✅ جيد | 0 |
| Module 12: Cross-Cutting Concerns | ❌ مخالفة | 2 |
| Module 13: Performance | ✅ جيد | 0 |
| Module 14: Readability | ✅ جيد | 0 |
| **المجموع** | | **15 مخالفة** _(بعد الجولة الثانية)_ |

### ✅ ما هو ممتاز في هذا الفيتشر:
- ✅ الـ DI مسجل بشكل صحيح ومكتوب بأسلوب tear-offs (`FeedbackRemoteDataSource.new`).
- ✅ الكود مقسم بشكل ممتاز بأسلوب Dumb Widgets مثل `FeedbackTextField` و `FeedbackHeader` و `FeedbackForm`.
- ✅ استخدام الـ `AutovalidateMode.onUserInteraction` مما يعطي استجابة فورية للمستخدم أثناء الكتابة.
- ✅ الـ Cubit مغلق على مستوى الـ Route كـ local BlocProvider مما يمنع تسريب الذاكرة (Memory Leaks).

---

## 🏗️ Module 1-3: Fundamentals, Object Design & SOLID

### ❌ مخالفة #1 — SOLID (DIP): الـ DataSource يعتمد على Singleton مباشر للـ Firestore
**الملف:** [feedback_remote_data_source.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/data/datasources/feedback_remote_data_source.dart#L9-L10)

```dart
FeedbackRemoteDataSource({FirebaseFirestore? firestore})
  : _firestore = firestore ?? FirebaseFirestore.instance; // ⚠️ استدعاء Singleton مباشر!
```

**المشكلة:** بدلاً من حقن (Injecting) الـ `FirebaseFirestore` من الـ Service Locator، تعتمد الـ DataSource على القيمة الافتراضية للـ Singleton الكلي `FirebaseFirestore.instance` في حال لم يُمرر الوسيط. هذا يكسر مبدأ عكس التبعية (Dependency Inversion Principle) ويصعب عملية الـ Mocking أثناء الـ Unit Testing.

**الحل:** تمرير الـ Dependency إجبارياً في الباني:
```dart
FeedbackRemoteDataSource(this._firestore);
```
وتسجيله في الـ DI:
```dart
sl.registerLazySingleton<IFeedbackRemoteDataSource>(
  () => FeedbackRemoteDataSource(sl<FirebaseFirestore>()),
);
```

---

### ❌ مخالفة #2 — Database Design Violation: تسريب نصوص واجهة معربة إلى قاعدة البيانات
**الملف:** [feedback_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/data/repos/feedback_repository.dart#L36)

```dart
final feedbackModel = FeedbackModel(
  message: message,
  contactInfo: contactInfo ?? AppStrings.notAvailable, // ⚠️ حفظ نص عربي "غير متوفر حالياً" بقاعدة البيانات!
  ...
);
```

**المشكلة:** يتم حفظ نص الواجهة المعرب `'غير متوفر حالياً'` (AppStrings.notAvailable) في قاعدة البيانات عند غياب حقل التواصل. هذا يمنع دعم لغات أخرى مستقبلاً ويعوق معالجة البيانات من قبل الإدارة بالخلفية.

**الحل:** تخزين قيمة فارغة `null` أو نص ثابت محايد مثل `'N/A'` وترك ترجمة القيمة للواجهة الرسومية عند العرض.

---

## 🌟 Module 4-5: Software Quality & Scalability

### ❌ مخالفة #3 — Crash/Race Condition: محاولة الـ `emit` بعد إغلاق صفحة الـ Feedback
**الملف:** [feedback_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/presentation/cubit/feedback_cubit.dart#L11-L34)

```dart
Future<void> sendFeedback({ ... }) async {
  emit(const FeedbackSending());
  final result = await repository.sendFeedback(...); // ⚠️ عملية انتظار async
  // ⚠️ إذا خرج المستخدم من الشاشة أثناء الانتظار، سيتم إغلاق الـ Cubit
  switch (result) {
    case Success():
      emit(const FeedbackSuccess(...)); // 💥 كراش StateError في الـ Production!
    ...
  }
}
```

**المشكلة الحرجة:** الـ Cubit معرّف محلياً في صفحة الـ View. إذا قام المستخدم بالضغط على زر الإرسال، ثم تراجع أو أغلق الصفحة أثناء انتظار الشبكة (Await)، سيتم استدعاء `close()` على الـ Cubit. عند اكتمال عملية الشبكة، سيحاول الكود إطلاق `emit` لحالة النجاح أو الفشل على كائن مغلق مما يسبب كراش `StateError: Cannot emit new states after calling close`.

**الحل:** إضافة شرط التأكد من بقاء الـ Cubit مفتوحاً:
```dart
if (isClosed) return;
switch (result) { ... }
```

---

### ❌ مخالفة #4 — Uncaught TypeErrors: الـ Repository يصطاد الـ `Exception` فقط
**الملف:** [feedback_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/data/repos/feedback_repository.dart#L46-L70)

```dart
} on Exception catch (e, stack) {
  // ⚠️ يمسك Exception فقط!
}
```

**المشكلة:** إذا حدث خطأ غير متوقع في محرك جلب معلومات الجهاز (مثال: رمي `TypeError` أثناء تحويل الـ Device Info أو الـ casting)، فلن يتم اصطياد الخطأ لأنه يرث من `Error` في Dart وليس `Exception`. سيتسبب هذا في تعليق الواجهة في وضع الإرسال `FeedbackSending` للأبد دون أن يعلم المستخدم بفشل العملية.

**الحل:** اصطياد الـ `Object` كحالة عامة:
```dart
} on Object catch (e, stack) {
```

---

### ❌ مخالفة #5 — UI State: غياب الـ Value-Based Equality في الـ State
**الملف:** [feedback_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/presentation/cubit/feedback_state.dart#L1-L22)

**المشكلة:** الـ Sealed Classes للـ State لا تقم بعمل override لدالتي `==` و `hashCode`. هذا يعني أنه لو تم إطلاق نفس الحالة مرتين (مثلاً إطلاق خطأين متتاليين بنفس الرسالة)، ستتم إعادة بناء شجرة الـ Widgets بلا أي داعٍ.

---

## 🧱 Module 7: Layering Concepts

### ❌ مخالفة #6 — Layer Violation: الـ Presentation تعتمد مباشرة على الـ Data Models
**الملف:** [feedback_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/presentation/cubit/feedback_cubit.dart#L3) و [feedback_form.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/presentation/widgets/feedback_form.dart#L10)

**المشكلة:** يفتقر الفيتشر لطبقة Domain وسيطة، مما يدفع الـ Cubit والـ Form إلى التعامل مباشرة مع الـ Data Repositories والـ Models الخاصة بطبقة الـ Data.

---

### ❌ مخالفة #7 — Loose Boundaries: استيراد كلاسات الـ Firestore داخل الـ Datasources
**الملف:** [feedback_remote_data_source.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/data/datasources/feedback_remote_data_source.dart#L1)

**المشكلة:** استيراد `cloud_firestore` مباشرة داخل الـ Remote DataSource يربط الكود بقاعدة بيانات Firestore بشكل صلب، مما يزيد من صعوبة الانتقال لمحرك شبكة آخر (مثل REST API أو Supabase).

---

## 🌳 Module 8: Flutter Internal Architecture

### ❌ مخالفة #8 — BuildContext across async gap: كراش تأكيدي عند استخدام سياق غير نشط بعد الـ Pop
**الملف:** [feedback_issue_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/presentation/views/feedback_issue_view.dart#L32-L37)

```dart
if (state is FeedbackSuccess) {
  context.pop(); // ⚠️ يتم إغلاق الصفحة أولاً وتدمير الـ context!
  AppToast.show(context, state.message); // ⚠️ محاولة استخدام الـ context المدمر!
}
```

**المشكلة الحرجة:** عند نجاح العملية، يستدعي المستمع `context.pop()` مما يغلق الصفحة فوراً ويجعل الـ context الحالي غير نشط (Unmounted / Deactivated). محاولة استدعاء `AppToast.show(context, ...)` بعد ذلك مباشرة باستخدام نفس الـ context ستؤدي إلى أخطاء متعلقة بفشل العثور على الـ Overlay الخاص بالـ Toastification، أو كراش صريح في حال حاول الـ Toast قراءة الـ Theme من الـ context المدمر.

**الحل:** عرض الـ Toast أولاً ثم إغلاق الصفحة:
```dart
if (state is FeedbackSuccess) {
  AppToast.show(context, state.message);
  context.pop();
}
```

---

### ❌ مخالفة #9 — BuildContext across async gap: استدعاء الـ Vibrate والـ Submit معاً بشكل متزامن
**الملف:** [feedback_form.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/presentation/widgets/feedback_form.dart#L88-L91)

```dart
onPressed: () {
  unawaited(playVibrate());
  unawaited(_handleSubmit()); // ⚠️ إطلاق العملية دون انتظار أو حماية
}
```

**المشكلة:** بالرغم من حماية الـ Loading، فإن غياب حجب الـ `onPressed` محلياً داخل الزر لبعض الأجزاء من الثانية قد يسمح بنقرات مزدوجة سريعة للمستخدم تؤدي لإطلاق الطلب مرتين متتاليتين للشبكة قبل إعادة بناء الزر.

---

## 🔄 Module 9: Data & Communication Flow

### ❌ مخالفة #10 — Fragile State Flow: الاعتماد على الـ String Matching للتعرف على أخطاء الشبكة
**الملف:** [feedback_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/data/repos/feedback_repository.dart#L55-L57)

```dart
if (e.toString().contains(FeedbackFirestoreKeys.unavailable) ||
    e.toString().contains(FeedbackFirestoreKeys.network) ||
    e.toString().contains(FeedbackFirestoreKeys.socketException))
```

**المشكلة:** فحص رسالة الخطأ النصية باستخدام `e.toString().contains(...)` هو أسلوب هش جداً. لو تغيرت رسالة الخطأ النصية التي يلقيها نظام التشغيل أو الـ SDK، سينهار كشف انقطاع الإنترنت وسيعتقد التطبيق أنه خطأ داخلي ويعرض رسالة "حدث خطأ فني" للمستخدم بدلاً من "تحقق من اتصالك بالإنترنت".

**الحل:** صيد الـ `FirebaseException` وفحص الـ `error code` الخاص به، أو استخدام باقة مثل `InternetConnectionChecker`.

---

## ⚙️ Module 12: Cross-Cutting Concerns

### ❌ مخالفة #11 — Unhandled Exception Risk: اهتزاز الجهاز (playVibrate) بلا حماية
**الملف:** [feedback_form.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/presentation/widgets/feedback_form.dart#L89)

```dart
unawaited(playVibrate()); // ⚠️ قد يفشل على المتصفح أو الأنظمة المقيدة بدون حماية
```

**المشكلة:** استدعاء محرك الاهتزاز قد يرمي خطأ استثناء على بعض منصات الويب أو الأجهزة التي لا تدعم الهزاز إذا لم يكن محاطاً بـ try/catch داخلي.

---

### ❌ مخالفة #12 — Hardcoded Layout Spacing: أبعاد هوامش ثابتة في الـ Column
**الملف:** [feedback_issue_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/presentation/views/feedback_issue_view.dart#L46-L50)

```dart
child: Column(
  spacing: AppSpacing.v24, // ⚠️ الهوامش ثابتة بدلاً من استخدام Spacer مرن
  ...
)
```

**المشكلة:** يقلل هذا التصميم من مرونة الواجهة الرسومية عند فتحها على أجهزة ذات شاشات صغيرة جداً، حيث قد يحدث Overflow بسبب عدم مرونة توزيع المساحات الفارغة.

---

## 🔍 جولة ثانية — مخالفات إضافية

### 🔴 مخالفة #13 — Bug: حفظ بيانات التواصل بمسافات زائدة (Missing trim on contactInfo)
**الملف:** [feedback_form.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/presentation/widgets/feedback_form.dart#L45-L49)

```dart
await context.read<FeedbackCubit>().sendFeedback(
  issueDescription: _issueController.text,
  contactInfo: _contactController.text.trim().isEmpty
      ? null
      : _contactController.text, // ⚠️ يتم إرسال النص غير الممسوح (untrimmed)!
);
```

**المشكلة:** يقوم الكود بالتحقق من الحقل باستخدام `.trim().isEmpty` ولكن عند تمرير القيمة، يمرر `_contactController.text` بشكل خام. لو قام المستخدم بإدخال بريد إلكتروني مع مسافة زائدة في النهاية (وهو أمر شائع جداً مع الإكمال التلقائي للهواتف)، سيتم إرساله وحفظه بمسافته في Firestore، مما قد يعيق الإدارة عند محاولة النقر لمراسلته.

**الحل:** تمرير القيمة ممسوحة:
```dart
contactInfo: _contactController.text.trim().isEmpty
    ? null
    : _contactController.text.trim(),
```

---

### 🟠 مخالفة #14 — UX: إمكانية تعديل المدخلات أثناء تشغيل الـ Loader (Active inputs during send)
**الملف:** [feedback_form.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/presentation/widgets/feedback_form.dart#L64-L80)

**المشكلة:** يظل حقل الوصف وحقل بيانات التواصل فعالين ومفتوحين للكتابة أو الحذف أثناء حالة `FeedbackSending` (تحميل إرسال الفورم). يجب تعطيل الحقول لمنع إدخال بيانات جديدة أو تعديل النص بعد ضغط الزر وبدء المعالجة.

**الحل:** تمرير حالة التمكين `enabled` للـ `FeedbackTextField`:
```dart
enabled: state is! FeedbackSending,
```

---

### 🟡 مخالفة #15 — SOLID (DIP): التخفي في حقن الـ Firestore بـ Constructor Tear-off
**الملف:** [feedback_di.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/di/feedback_di.dart#L9-L11)

```dart
sl..registerLazySingleton<IFeedbackRemoteDataSource>(
  FeedbackRemoteDataSource.new, // ⚠️ يستعمل Constructor tear-off دون تمرير Firestore بشكل صريح!
)
```

**المشكلة:** استخدام `FeedbackRemoteDataSource.new` مع باني يعتمد على Singleton داخلي افتراضي (`FirebaseFirestore.instance`) يلتف على الـ Service Locator ويمنع حقن Firestore وهمي (Mock) للاختبار بشكل نظيف وموحد مثل بقية الـ DataSources.



# ملحق جولة ثانية — مخالفات feedback
**يُكمل: FEEDBACK_VIOLATIONS.md**

---

## 🔍 ملخص ما تم اكتشافه في الجولة الثانية لـ `feedback`

| # | المخالفة | التصنيف | الخطورة |
|---|----------|---------|---------|
| FB1 | **حفظ بيانات التواصل بمسافات زائدة (Missing trim on contactInfo)** | Bug/Data Integrity 🔴 | عالي |
| FB2 | **إمكانية تعديل حقول النص أثناء إرسال الفورم (Active input during loading)** | UX 🟠 | متوسط |
| FB3 | **التخفي في حقن الـ Firestore بـ Constructor Tear-off** | SOLID/DIP 🟡 | منخفض |

---

## 🔍 التفاصيل الفنية للمخالفات الإضافية

### 🔴 مخالفة FB1 — Bug: عدم عمل trim للمدخلات قبل الإرسال (Data Formatting Corruption)
**الملف:** [feedback_form.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/presentation/widgets/feedback_form.dart#L45-L49)

```dart
await context.read<FeedbackCubit>().sendFeedback(
  issueDescription: _issueController.text,
  contactInfo: _contactController.text.trim().isEmpty
      ? null
      : _contactController.text, // ⚠️ يتم إرسال النص غير الممسوح (untrimmed)!
);
```

**المشكلة:** يقوم الكود بالتحقق من الحقل باستخدام `.trim().isEmpty` ولكن عند تمرير القيمة، يمرر `_contactController.text` بشكل خام. لو قام المستخدم بإدخال بريد إلكتروني مع مسافة زائدة في النهاية (وهو أمر شائع جداً مع الإكمال التلقائي للهواتف)، سيتم إرساله وحفظه بمسافته في Firestore، مما قد يعيق الإدارة عند محاولة النقر لمراسلته.

**الحل:** تمرير القيمة ممسوحة:
```dart
contactInfo: _contactController.text.trim().isEmpty
    ? null
    : _contactController.text.trim(),
```

---

### 🟠 مخالفة FB2 — UX: إمكانية تعديل المدخلات أثناء تشغيل الـ Loader (Active inputs during send)
**الملف:** [feedback_form.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/presentation/widgets/feedback_form.dart#L64-L80)

**المشكلة:** يظل حقل الوصف وحقل بيانات التواصل فعالين ومفتوحين للكتابة أو الحذف أثناء حالة `FeedbackSending` (تحميل إرسال الفورم). يجب تعطيل الحقول لمنع إدخال بيانات جديدة أو تعديل النص بعد ضغط الزر وبدء المعالجة.

**الحل:** تمرير حالة التمكين `enabled` للـ `FeedbackTextField`:
```dart
enabled: state is! FeedbackSending,
```

---

### 🟡 مخالفة FB3 — SOLID (DIP): التخفي في حقن الـ Firestore بـ Constructor Tear-off
**الملف:** [feedback_di.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/feedback/di/feedback_di.dart#L9-L11)

```dart
sl..registerLazySingleton<IFeedbackRemoteDataSource>(
  FeedbackRemoteDataSource.new, // ⚠️ يستعمل Constructor tear-off دون تمرير Firestore بشكل صريح!
)
```

**المشكلة:** استخدام `FeedbackRemoteDataSource.new` مع باني يعتمد على Singleton داخلي افتراضي (`FirebaseFirestore.instance`) يلتف على الـ Service Locator ويمنع حقن Firestore وهمي (Mock) للاختبار بشكل نظيف وموحد مثل بقية الـ DataSources.
