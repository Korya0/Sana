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
