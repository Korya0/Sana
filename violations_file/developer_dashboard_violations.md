# تقرير التدقيق المعماري الصارم: ميزة `developer_dashboard`

تم إجراء فحص تشريحي (Hyper-Strict Deep Dive) لميزة `developer_dashboard` ومطابقتها حرفياً مع المعايير والقواعد الصارمة المحددة في `PROJECT_CONTEXT.md` و `CLAUDE.md`.

فيما يلي قائمة الانتهاكات المعمارية والبرمجية التي تم رصدها:

---

## 1. استخدام مكتبات التوليد (Code Generation Violation)
- **نوع الانتهاك ومدى خطورته**: High 🔴
- **مسار الملف**: `lib/features/developer_dashboard/presentation/cubit/dashboard_state.dart`
- **أرقام الأسطر**: 1 - 17
- **نص القاعدة التي تم كسرها**:
  *Section C, Rule 2) No Code Generation - "No Freezed. No build_runner. Use Dart 3+ native features instead: sealed class for state unions with exhaustive pattern matching"*
- **الإجراء البرمجي الدقيق المطلوب للإصلاح**:
  يجب إزالة مكتبة `@freezed` و `part 'dashboard_state.freezed.dart';`. يجب إعادة كتابة الملف باستخدام ميزة `sealed class` الأصلية في Dart 3 لتعريف الحالات (`DashboardInitial`, `DashboardFeedbacksLoading`, إلخ) بشكل صريح وبدون الاعتماد على توليد الأكواد.

---

## 2. كسر قواعد الـ Typography واستخدام `.copyWith` بشكل غير قانوني
- **نوع الانتهاك ومدى خطورته**: High 🔴
- **مسار الملف**: `lib/features/developer_dashboard/presentation/widgets/feedback_content.dart`
- **أرقام الأسطر**: 42-44, 60-62
- **نص القاعدة التي تم كسرها**:
  *Section C, Rule 10) Strict Responsive Sizing & Typography - "NEVER use `.copyWith` to modify `fontSize`, `fontWeight`, `color`, or `fontFamily`. Use it ONLY for secondary properties (e.g., `height` for line spacing)."*
- **الإجراء البرمجي الدقيق المطلوب للإصلاح**:
  إزالة `.copyWith(color: AppColors.textPrimary)` تماماً. يجب استخدام الـ Text Style المناسب مباشرة من `AppTextStyles` (مثل `AppTextStyles.font12W700Primary`)، وإذا لم يكن موجوداً يجب إضافته إلى الملف المركزي `app_text_styles.dart` لضمان مركزية الخطوط.

---

## 3. تسريب قيم ثابتة للمسافات والهوامش (Hardcoding Spacing/Padding)
- **نوع الانتهاك ومدى خطورته**: High 🔴
- **مسار الملفات وأرقام الأسطر**:
  1. `feedbacks_list_view.dart` (الأسطر: 49, 54) -> استخدام القيم `16`.
  2. `admin_feedback_actions.dart` (السطر: 33) -> استخدام القيم `16`, `8`.
  3. `feedback_content.dart` (الأسطر: 110, 117, 118) -> استخدام القيمة `8` بداخل `SizedBox`.
  4. `share_card/feedback_share_card.dart` (الأسطر: 32, 33, 36, 41, 47, 49) -> استخدام القيم `10`, `20`, `150`, `24`, `40`, `32`.
- **نص القاعدة التي تم كسرها**:
  *Section C, Rule 10) Strict Responsive Sizing & Typography - "NEVER use hardcoded double values for the spacing property in Column or Row. Always use spacing tokens." & Section F - "DON'T hardcode colors, spacing, or font sizes"*
- **الإجراء البرمجي الدقيق المطلوب للإصلاح**:
  استبدال كافة الأرقام الثابتة بالقيم المركزية المطابقة لها من `AppSpacing` (مثل: `AppSpacing.v16`, `AppSpacing.v8`, `AppSpacing.v24`). وفي حال الحاجة لقيم ضخمة مثل `150` يجب تعريفها كـ Constant أو استخدام نسبة مئوية، وعدم كتابتها كرقم ثابت في الـ UI.

---

## 4. تجاهل التصميمات المشتركة المركزية (UI Decoration Violation)
- **نوع الانتهاك ومدى خطورته**: Medium 🟠
- **مسار الملف**: `lib/features/developer_dashboard/presentation/widgets/feedback_admin_card.dart`
- **أرقام الأسطر**: 21 - 27
- **نص القاعدة التي تم كسرها**:
  *Section C (Project-Specific UI Rules) - Common Decorations. "Use `featureCardDecoration()` from `core/common/decorations/feature_card_decoration.dart` for all feature-specific cards and interactive containers."*
- **الإجراء البرمجي الدقيق المطلوب للإصلاح**:
  إزالة تعريف `BoxDecoration` اليدوي ذو الحواف المعرفة الثابتة `Border.all` و `BorderRadius`، واستبداله باستخدام دالة `featureCardDecoration(context)` الجاهزة والمركزية لضمان توحيد تصميم البطاقات في كامل المشروع.

---

## 5. تسريب منطق معالجة البيانات إلى طبقة العرض (Logic Leak to UI)
- **نوع الانتهاك ومدى خطورته**: Medium 🟠
- **مسار الملف**: `lib/features/developer_dashboard/presentation/widgets/feedback_content.dart`
- **أرقام الأسطر**: 24 - 27
- **نص القاعدة التي تم كسرها**:
  *Section C, Rule 9) Data Transformation & Layer Purity. "Move all data transformation or parsing logic (e.g. string formatting, Regex parsing) from the UI layer to the Data Layer (Models)."*
- **الإجراء البرمجي الدقيق المطلوب للإصلاح**:
  نقل المنطق الخاص بتحويل سلسلة الوقت (`DateTime.tryParse`) وتنسيقه (`DateFormat`) من دالة الـ `build()` بالواجهة إلى Data Model (`DashboardFeedbackModel`). يجب تعريف `getter` في الـ Model يرجع التاريخ المنسق مباشرة بحيث يستلم الـ Widget قيمة `String` جاهزة للعرض فقط (Stateless data reception).

---

> **ملاحظة:** بناء الميزة يعتبر متوافقاً مع طبقات الـ Tier 2 Architecture (Data -> Presentation) لعدم وجود طبقة الـ Domain لكون المنطق البرمجي بسيطاً، وهو ما يتوافق مع القواعد المعتمدة للمشروع.
