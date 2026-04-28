# 🩺 التشريح المعماري الصارم: ميزة `feedback`

بصفتي المدقق المعماري الصارم للمشروع (Strict Architectural Auditor)، قمت بإجراء فحص تشريحي عميق (Hyper-Strict Deep Dive) لكافة ملفات ميزة `feedback`، ومطابقتها حرفياً مع القواعد الصارمة الموضحة في `CLAUDE.md` و `PROJECT_CONTEXT.md`.

إليك التقرير التشريحي الشامل للانتهاكات المكتشفة:

---

## 1. 🛑 تسريب منطقي (Logic Leak) وكود ميت (Critical)
- **مسار الملف:** `lib/features/feedback/data/repos/feedback_repository.dart`
- **السطر:** 41 وصولاً إلى 62
- **القاعدة المكسورة:** 
  - `Section A.3: Error Handling` (Catch errors at the boundary, no silent failures).
  - `Section A.4: Change Discipline` (Fix root causes).
- **تفاصيل الانتهاك:** 
  تم استخدام دالة الإرسال `unawaited(_remoteDataSource.sendFeedback(...))` بشكل غير متزامن تماماً (Fire and Forget)، ومع ذلك قام المطور بكتابة كتلة `catch` أسفلها تحاول اصطياد أخطاء الشبكة والـ Socket القادمة من Firestore (مثل الاستثناءات التي تحتوي على `unavailable` أو `network`). نظراً لغياب الكلمة المفتاحية `await`، فإن أي خطأ غير متزامن سيضيع في الخلفية (Silent Failure) ولن يمر عبر كتلة الـ `catch` إطلاقاً، مما يجعل كود معالجة الأخطاء مجرد "كود ميت" (Dead Code).
- **الإجراء البرمجي المطلوب:** 
  استبدال السطر 41:
  ```dart
  unawaited(_remoteDataSource.sendFeedback(feedbackModel.toJson()));
  ```
  بالكود المتزامن:
  ```dart
  await _remoteDataSource.sendFeedback(feedbackModel.toJson());
  ```

---

## 2. 🚫 استخدام أدوات توليد الأكواد الممنوعة (High)
- **مسار الملف:** `lib/features/feedback/presentation/cubit/feedback_state.dart` و `feedback_state.freezed.dart`
- **السطر:** كافة محتويات الملفين.
- **القاعدة المكسورة:** `Section C.2: No Code Generation` (No Freezed. No build_runner. Use Dart 3+ native features instead).
- **تفاصيل الانتهاك:** 
  تعتمد حالة الميزة بشكل كامل على مكتبة `Freezed` لبناء الـ States، وهذا يخالف القاعدة الصارمة والحديثة للمشروع التي تفرض استخدام الميزات الأصلية في Dart 3 (`sealed class`) وإلغاء الاعتماد على التوليد البرمجي في الملفات الجديدة.
- **الإجراء البرمجي المطلوب:** 
  1. حذف ملف `feedback_state.freezed.dart` بالكامل من النظام.
  2. إزالة السطر `part 'feedback_state.freezed.dart';` والـ `@freezed`.
  3. إعادة هندسة الحالة باستخدام الـ `sealed class` الأصلي كما يلي:
  ```dart
  sealed class FeedbackState {
    const FeedbackState();
  }
  class FeedbackInitial extends FeedbackState {
    const FeedbackInitial();
  }
  class FeedbackSending extends FeedbackState {
    const FeedbackSending();
  }
  class FeedbackSuccess extends FeedbackState {
    final String message;
    const FeedbackSuccess({required this.message});
  }
  class FeedbackFailure extends FeedbackState {
    final String error;
    const FeedbackFailure({required this.error});
  }
  ```

---

## 3. ⚠️ استخدام أرقام سحرية (Magic Numbers) وتجاهل التحجيم النسبي (Medium)
- **مسار الملف:** `lib/features/feedback/presentation/widgets/feedback_header.dart`
- **السطر:** 33 و 27
- **القاعدة المكسورة:** 
  - `Section C.10: Explicit UI Scaling` (Use .r(context) in the UI only for other dimensions e.g. icons).
  - `Section F: DON'T use magic numbers — extract to named constants`.
- **تفاصيل الانتهاك:** 
  تم إدخال قيم صلبة (Hardcoded) لحجم الأيقونة `size: 40` وسُمك الحواف `width: 2` دون تمريرها عبر نظام التحجيم النسبي `.r(context)` أو عبر المتغيرات المركزية للتصميم (Tokens).
- **الإجراء البرمجي المطلوب:** 
  1. استيراد ملف التحجيم: 
  `import 'package:sana/core/utils/context_extension.dart';`
  2. تعديل حجم الأيقونة (السطر 33) ليكون:
  `size: 40.r(context),`

---

## 4. ⚠️ بناء زينة واجهات عشوائية (Ad-hoc Decorations) (Low)
- **مسار الملف:** `lib/features/feedback/presentation/widgets/feedback_text_field.dart`
- **السطر:** 37 إلى 40، و 45 إلى 49
- **القاعدة المكسورة:** `Section B.1: Common Decorations` (Reuse shared decoration widgets... Never create ad-hoc decorations).
- **تفاصيل الانتهاك:** 
  تم بناء `OutlineInputBorder` وحقن ألوان صلبة مثل `width: 2` بداخل الملف محلياً بدلاً من تفويضها للملف المركزي الخاص بالـ Theme للمشروع `app_theme.dart` (تحديداً داخل `inputDecorationTheme`). هذا يكسر مبدأ توحيد الواجهات (Consistency).
- **الإجراء البرمجي المطلوب:** 
  نقل هندسة الـ `OutlineInputBorder` إلى ملف التصميم المركزي التابع للمشروع والاعتماد على `Theme.of(context).inputDecorationTheme` للحفاظ على نظافة الـ Widget وخلوها من تفاصيل الـ UI الزائدة.
