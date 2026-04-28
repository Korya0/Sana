# 🕵️ تقرير التدقيق المعماري الصارم (Hyper-Strict Audit Report)
**الميزة (Feature):** `home`
**الهدف:** فحص التطابق الحرفي مع قواعد `CLAUDE.md` و `PROJECT_CONTEXT.md`

تم إجراء فحص تشريحي عميق لجميع ملفات ميزة الـ `home`. وُجدت الانتهاكات التالية التي يجب إصلاحها فوراً لضمان نقاء المعمارية والمطابقة الصارمة لقواعد المشروع.

---

### 1. تسريب منطق واجهة المستخدم إلى طبقة البيانات (Layer Bleeding)
* **نوع الانتهاك:** 🔴 **Critical**
* **الملف:** `lib/features/home/data/models/category_item.dart`
* **السطر:** 1 و 21
* **القاعدة المكسورة:** 
  - *Section A — 1) Architecture & Separation of Concerns:* "UI/presentation layer has ZERO business logic... Data access lives in the data layer"
  - *Section C — 3) Domain Layer Purity:* (Data Models should be free of Flutter UI logic).
* **التفاصيل:** استيراد `package:flutter/material.dart` داخل `Model` يتبع لطبقة البيانات (Data Layer)، وتمرير `BuildContext` كجزء من البيانات عبر المتغير `final Future<void> Function(BuildContext)? onTap;`. هذا يربط طبقة البيانات بشكل صريح وخطير بطبقة العرض.
* **الإجراء الدقيق المطلوب:** إزالة استيراد `material.dart` من الموديل وحذف المتغير `onTap`. يجب نقل كافة منطق التنقل والضغط ليُدار كلياً داخل طبقة العرض (Widgets) وليس كبيانات مخزنة داخل الموديل.

---

### 2. تجاوز القواعد الأمنية (Security & Hardcoding)
* **نوع الانتهاك:** 🔴 **Critical**
* **الملف:** `lib/features/home/presentation/widgets/secret_pin_dialog.dart`
* **السطر:** 34
* **القاعدة المكسورة:** 
  - *Section A — 6) Security:* "Never hardcode secrets, tokens, or credentials"
* **التفاصيل:** تم تخزين كود المرور السري الخاص بلوحة التحكم مباشرة داخل الكود: `static const _secretPin = '31903556';`
* **الإجراء الدقيق المطلوب:** إزالة الرقم السري المكتوب يدوياً (Hardcoded). يجب استدعاؤه من متغيرات البيئة `.env`، أو من `Firebase Remote Config`، أو تخزينه مسبقاً بشكل مشفر وآمن.

---

### 3. التعديل غير القانوني على النصوص (Typography Override)
* **نوع الانتهاك:** 🔴 **Critical**
* **الملف:** `lib/features/home/presentation/widgets/sections/home_azkar_category_section.dart`
* **السطر:** 64-66
* **القاعدة المكسورة:** 
  - *Section C — 10) Strict Responsive Sizing & Typography:* "copyWith Restriction: NEVER use `.copyWith` to modify `fontSize`, `fontWeight`, `color`, or `fontFamily`."
* **التفاصيل:** تم استخدام `copyWith(fontSize: 14)` لتعديل حجم خط مركزي: `AppTextStyles.font16W700primary(context).copyWith(fontSize: 14)`
* **الإجراء الدقيق المطلوب:** إزالة استخدام `.copyWith(fontSize: 14)`. يجب استبداله فوراً بالستايل المركزي الصحيح الجاهز: `AppTextStyles.font14W700primary(context)`.

---

### 4. استخدام التوليد البرمجي للملفات الجديدة (Code Generation)
* **نوع الانتهاك:** 🟠 **High**
* **الملفات:** 
  - `lib/features/home/presentation/cubit/features_list_state.dart` (الأسطر 3-10)
  - `lib/features/home/presentation/cubit/features_list_cubit.freezed.dart`
* **القاعدة المكسورة:** 
  - *Section C — 2) No Code Generation:* "No Freezed. No build_runner. Use Dart 3+ native features instead: sealed class for state unions with exhaustive pattern matching"
* **التفاصيل:** تم استخدام حزمة `Freezed` لبناء حالات الـ State للميزة، وهو ما يتعارض مع تحديثات المشروع باستخدام ميزات Dart 3+ الأصلية.
* **الإجراء الدقيق المطلوب:** حذف ملف `*.freezed.dart` بالكامل. إعادة كتابة `FeaturesListState` باستخدام الكلمة المفتاحية `sealed class` الأصلية من Dart 3، وعدم استخدام أي مزخرفات `@freezed`.

---

### 5. استخدام أرقام ثابتة للمسافات (Hardcoded Spacing)
* **نوع الانتهاك:** 🟠 **High**
* **الملف:** `lib/features/home/presentation/widgets/sections/home_daily_wisdom_section.dart`
* **السطر:** 25
* **القاعدة المكسورة:** 
  - *Section C — 10) Strict Responsive Sizing & Typography:* "Column/Row Spacing: NEVER use hardcoded double values for the spacing property in Column or Row. Always use spacing tokens."
* **التفاصيل:** تم استخدام رقم ثابت صريح في مسافات الـ Column: `spacing: 12,`
* **الإجراء الدقيق المطلوب:** استبدال الرقم الثابت `12` بمتغير التصميم المركزي: `spacing: AppSpacing.v12`.

---

### 6. كتابة نصوص عربية صريحة (Inline Strings)
* **نوع الانتهاك:** 🟠 **High**
* **الملف:** `lib/features/home/data/datasources/features_local_data_source.dart`
* **السطر:** 48
* **القاعدة المكسورة:** 
  - *Section B — 2) Text & String Management:* "All user-facing Arabic text MUST be centralized in a single strings constant. No inline Arabic strings allowed."
* **التفاصيل:** تمت كتابة نص عربي مباشر داخل قائمة البيانات: `title: 'تصحيح التلاوة',`
* **الإجراء الدقيق المطلوب:** نقل النص "تصحيح التلاوة" إلى ملف الثوابت `core/constants/app_strings.dart` واستدعاؤه عبر `AppStrings.quranCorrection`.

---

### 7. اختراع مكونات للزينة (Ad-hoc Decorations)
* **نوع الانتهاك:** 🟠 **High**
* **الملف:** `lib/features/home/presentation/widgets/sections/home_settings_section.dart`
* **الأسطر:** 51، 72، 90
* **القاعدة المكسورة:** 
  - *Section B — 1) UI & Design System:* "Common Decorations: Reuse shared decoration widgets for cards, dividers... Never create ad-hoc decorations."
  - *PROJECT_CONTEXT.md - Section C:* "Use CustomAppDivider() for all UI dividers."
* **التفاصيل:** تم استخدام المكون `Divider(...)` التقليدي من فلاتر مع تعيين خصائص مسافات ولون يدوياً عدة مرات متتالية.
* **الإجراء الدقيق المطلوب:** استبدال جميع مكونات الـ `Divider()` بـ `CustomAppDivider()` المركزي المعرف مسبقاً في `core/common/decorations/`.

---

### 8. الفشل الصامت وإخفاء الأخطاء (Silent Error Swallowing)
* **نوع الانتهاك:** 🟠 **High**
* **الملفات:** 
  - `home_features_category_section.dart` (سطر 23)
  - `home_azkar_category_section.dart` (سطر 25)
  - `home_prayer_section.dart` (سطر 17)
* **القاعدة المكسورة:** 
  - *Section E — Error Handling:* "Always handle all 4 UI states in presentation: initial, loading, success, error"
  - *Section F — Do's and Don'ts:* "DON'T swallow errors silently — always log and surface to the user"
* **التفاصيل:** عند حدوث خطأ في الـ State، يتم إرجاع `const SizedBox.shrink()` مما يتسبب في إخفاء تام (ابتلاع) للخطأ دون إبلاغ المستخدم أو عرض واجهة تعويضية.
* **الإجراء الدقيق المطلوب:** يجب عدم استخدام `SizedBox.shrink()` في الحالات الخاطئة، وبدلاً من ذلك إرجاع مكون بديل يوضح وجود مشكلة (مثل `AppErrorView` مبسط أو `AppToast` في حالة الـ UI المحلية).

---

### 9. تعليقات غير مبررة (Unclean Comments)
* **نوع الانتهاك:** 🟡 **Low**
* **الملف:** `lib/features/home/presentation/widgets/sections/home_features_category_section.dart`
* **الأسطر:** 43, 60-63
* **القاعدة المكسورة:** 
  - *Section F — Do's and Don'ts:* "DON'T write comments in code — the code should be self-documenting; use clear naming instead"
* **التفاصيل:** وجود كود معلق بالكامل في مسارات الميزة ومسارات الشروط مثل `//feature.route == AppRoutes.qibla ||`.
* **الإجراء الدقيق المطلوب:** إزالة الكود المكتوب كتعليق فوراً لتنظيف مسارات العمل.
