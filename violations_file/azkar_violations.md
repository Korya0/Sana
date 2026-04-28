# ⚠️ تقرير التدقيق المعماري الصارم: ميزة `azkar` ⚠️

بناءً على الفحص العميق (Hyper-Strict Deep Dive) لكافة ملفات ميزة `azkar` ومطابقتها حرفياً مع المعايير والقواعد المنصوص عليها في `PROJECT_CONTEXT.md` و `CLAUDE.md`، تم رصد الانتهاكات التالية:

---

## 1. تسريب واجهة المستخدم إلى طبقة البيانات (UI Layer Bleed into Data Layer) 🚨
- **مستوى الخطورة:** Critical
- **الملفات:** 
  - `lib/features/azkar/data/datasources/azkar_local_data_source.dart` (الأسطر 15-39, 46)
  - `lib/features/azkar/data/models/azkar_category_model.dart` (الأسطر 16, 21, 32)
- **القاعدة المخترقة:** 
  - *Section A.1 (CLAUDE.md):* "UI/presentation layer has ZERO business logic... Data access... lives in the data layer".
  - *Section C.9 (CLAUDE.md):* "Data Transformation & Layer Purity".
- **الوصف:** طبقة البيانات تقوم باستيراد مكاتب خاصة بواجهة المستخدم مثل `flutter/material.dart` و `solar_icons` لربط المعرفات `id` بأيقونات `IconData`. كذلك الـ Model `AzkarCategoryModel` يحتوي على حقل `IconData`. هذا انتهاك صارخ لمبدأ فصل الاهتمامات (Separation of Concerns)، حيث لا يجب أن تعرف طبقة البيانات أي شيء عن كيفية عرض البيانات على الشاشة.
- **الإجراء البرمجي المطلوب:** 
  1. إزالة أي استيراد لـ `flutter/material.dart` و `IconData` من طبقة الـ Data.
  2. حذف حقل `icon` من `AzkarCategoryModel`.
  3. نقل خريطة الأيقونات (`_categoryIcons`) إلى طبقة الـ Presentation (مثلاً كـ `Extension` على الموديل أو كـ Helper UI Widget يقوم بإرجاع الأيقونة المناسبة بناءً على `category.id`).

---

## 2. انتهاك النقاء الطباعي وتعديل الخطوط برمجياً (Typography Purity Violation) 🚨
- **مستوى الخطورة:** High
- **الملفات:** 
  - `lib/features/azkar/presentation/widgets/zikr_card/zikr_content.dart` (السطر 32: `fontSize: 18`, السطر 42: `fontSize: isSharing ? 16 : 14`, السطر 43: `color: ...`)
  - `lib/features/azkar/presentation/widgets/zikr_card/zikr_counter.dart` (السطر 77: `fontSize: remainingCount > 99 ? 18 : 24`)
- **القاعدة المخترقة:** 
  - *Section C.10 (CLAUDE.md):* "NEVER use `.copyWith` to modify `fontSize`, `fontWeight`, `color`, or `fontFamily`. Use it ONLY for secondary properties (e.g., `height` for line spacing)."
- **الوصف:** يتم استخدام `.copyWith` على الخطوط المركزية (Centralized Text Styles) لتعديل أحجام الخطوط وألوانها بشكل ديناميكي (Hardcoded overrides) بناءً على شروط معينة.
- **الإجراء البرمجي المطلوب:** يجب إضافة أنماط الخطوط والألوان المطلوبة (مثل `font18W600White` أو `font14W500GreyWhite70`) في ملف `AppTextStyles` المركزي، ثم استخدام جملة شرطية للاختيار بين الـ TextStyles الجاهزة بدلاً من التعديل عليها باستخدام `copyWith`.

---

## 3. استخدام قيم ثابتة للمسافات (Hardcoded Spacing Values) 🚨
- **مستوى الخطورة:** High
- **الملفات:**
  - `lib/features/azkar/presentation/widgets/zikr_card/zikr_actions_row.dart` (السطر 35: `right: 10`)
  - `lib/features/azkar/presentation/widgets/share_card/zikr_share_card.dart` (السطر 42: `horizontal: 24, vertical: 40`، الأسطر 48, 50: `height: 32`)
  - `lib/features/azkar/presentation/widgets/zikr_card/zikr_content.dart` (السطر 21: `spacing: isSharing ? 24 : 32`)
- **القاعدة المخترقة:**
  - *Section C.10 (CLAUDE.md):* "NEVER use hardcoded double values for the spacing property in Column or Row. Always use spacing tokens."
  - *Section F (CLAUDE.md):* "DON'T hardcode spacing".
- **الوصف:** يتم استخدام أرقام ثابتة من نوع Double بشكل مباشر لعمل Margins و Paddings و Spacing بدلاً من استخدام التصميمات المركزية `AppSpacing`.
- **الإجراء البرمجي المطلوب:** استبدال جميع الأرقام الثابتة بالثوابت المطابقة من `AppSpacing` (على سبيل المثال استبدال 24 بـ `AppSpacing.v24` أو `AppSpacing.h24`).

---

## 4. انتظار تفاعلات الاهتزاز (Awaiting AppFeedback) ⚠️
- **مستوى الخطورة:** Medium
- **الملفات:**
  - `lib/features/azkar/presentation/widgets/zikr_item_card.dart` (الأسطر 45, 59)
- **القاعدة المخترقة:**
  - *Section D DO (PROJECT_CONTEXT.md):* "DO use `unawaited(AppFeedback.playVibrate())` for standard interactions".
- **الوصف:** تم استخدام `await` مع دالة `playVibrate`، مما يكسر قاعدة المشروع التي تنص بوضوح على وجوب استخدام `unawaited` لعدم تعطيل مسار الـ UI (Main Thread).
- **الإجراء البرمجي المطلوب:** إزالة الـ `await` ولف الدالة داخل `unawaited(AppFeedback.playVibrate());`.

---

## 5. استخدام مكتبة Freezed وتجاهل ميزات Dart 3 Native ⚠️
- **مستوى الخطورة:** Medium
- **الملفات:**
  - كافة ملفات الـ Cubit States (مثلاً `azkar_list_state.dart`، `azkar_categories_cubit.dart`)
  - كافة ملفات الـ Models (مثلاً `zikr_model.dart`، `azkar_category_model.dart`)
- **القاعدة المخترقة:**
  - *Section C.2 (CLAUDE.md):* "No Freezed. No build_runner. Use Dart 3+ native features instead: sealed class..."
- **الوصف:** رغم أن القاعدة تسمح بالإبقاء على ملفات Freezed القديمة، إلا أن التدقيق المعماري الصارم يفضل ترقية جميع الكيانات (States و Models) لتعتمد كلياً على `sealed classes` و `records` الخاصة بـ Dart 3.
- **الإجراء البرمجي المطلوب:** ترحيل الـ States لتعمل بـ Native Sealed Classes بدلاً من Freezed، وتحويل الـ Models لـ Classes قياسية مع دوال `copyWith` و `Equatable` يدوية أو التخلي عن Freezed تماماً لمطابقة الـ Tier 2 Architecture بأعلى جودة.

---

## 6. إغفال استخدام `.r(context)` للأحجام المخصصة (Missing Responsive Dimensions) 🔍
- **مستوى الخطورة:** Low
- **الملفات:**
  - `lib/features/azkar/presentation/widgets/zikr_card/zikr_counter.dart` (السطر 18: `const double size = 60;`، السطر 71: `size: 32`)
  - `lib/features/azkar/presentation/widgets/share_card/zikr_share_card.dart` (السطر 37: `size: 150`)
- **القاعدة المخترقة:**
  - *Section C.10 (CLAUDE.md):* "Use `.r(context)` in the UI only for other dimensions (e.g., icons, custom container sizes, image heights)."
- **الوصف:** تم إعطاء قيم Double ثابتة لأحجام الأيقونات وحاويات الرسوم البيانية بدلاً من استخدام دالة التحجيم المتجاوب `.r(context)`.
- **الإجراء البرمجي المطلوب:** يجب إعطاء الحجم الديناميكي عبر `60.r(context)` للأحجام المخصصة والحاويات والأيقونات لضمان تناسبها مع جميع الشاشات.
