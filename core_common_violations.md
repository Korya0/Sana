# core_common_violations.md - lib/core/common

## 1. انتهاكات: Overlays & Dialogs (High Priority)

### [High] استخدام نصوص Hardcoded (Arabic)
- **الملفات:**
    - `lib/core/common/overlays/bottom_sheet/custom_bottom_sheet_widget.dart` (سطر 14: "تأكيد")
    - `lib/core/common/overlays/bottom_sheet/show_custom_bottom_sheet.dart` (سطر 11: "تأكيد")
    - `lib/core/common/overlays/dialog/custom_confirmation_dialog.dart` (سطر 17، 43: "إلغاء")
- **القاعدة المكسورة:** "All user-facing Arabic text MUST be centralized in a single strings constant." (CLAUDE.md - Rules for AI)
- **الإجراء:** إضافة `AppStrings.confirm` و `AppStrings.cancel` واستخدامهم.

### [High] استخدام قيم سحرية (Magic Numbers) للأبعاد والمسافات
- **الملفات:**
    - `lib/core/common/overlays/bottom_sheet/custom_bottom_sheet_widget.dart` (سطر 66-67: width: 48, height: 6)
    - `lib/core/common/overlays/dialog/custom_dialog.dart` (سطر 13: borderRadius = 16.0، سطر 16-17: horizontal: 40, vertical: 24)
    - `lib/core/common/overlays/dialog/custom_confirmation_dialog.dart` (سطر 77، 81، 90، 104: SizedBox)
- **القاعدة المكسورة:** "DON'T hardcode spacing values. Use AppSpacing."
- **الإجراء:** استخدام `AppSpacing` المناسب وإضافة `.r(context)` للأبعاد الثابتة لضمان التجاوب.

### [Medium] استخدام الودجت Opacity مع النصوص
- **الملف:** `lib/core/common/widgets/card/daily_content_base_card.dart` (سطر 174)
- **القاعدة المكسورة:** "Avoid using the Opacity widget for simple items (Text/Icons); use ARGB colors instead." (CLAUDE.md)
- **الإجراء:** استبدال `Opacity` باستخدام `style: AppTextStyles.xxx.copyWith(color: color.withValues(alpha: 0.7))`.

---

## 2. انتهاكات: Widgets & Layout (Medium Priority)

### [Medium] ألوان Hardcoded مباشرة
- **الملفات:**
    - `lib/core/common/overlays/dialog/custom_confirmation_dialog.dart` (سطر 114: `Colors.red`)
    - `lib/core/common/overlays/dialog/custom_dialog.dart` (سطر 95: `Colors.black54`)
    - `lib/core/common/widgets/app_toggle_list.dart` (سطر 53: `Colors.transparent`)
- **القاعدة المكسورة:** "DON'T use direct colors (Colors.red). Use AppColors."
- **الإجراء:** استبدالها بـ `AppColors.red`, `AppColors.scaffoldBackground.withValues(alpha: 0.54)` الخ.

### [Low] غياب الـ const في SizedBox و Widgets ثابتة
- **الملف:** `lib/core/common/layout/custom_carousel_slider.dart` (سطر 29)
- **القاعدة المكسورة:** "DO always use const constructors for static widgets."
- **الإجراء:** إضافة `const`.

---

## 3. انتهاكات: Clean Architecture (Medium Priority)

### [Medium] وجود منطق Share/Copy داخل الـ UI
- **الملف:** `lib/core/common/overlays/dialog/custom_rich_content_dialog.dart`
- **القاعدة المكسورة:** "Presentation widgets should be as simple and Stateless as possible."
- **الإجراء:** يجب تمرير دوال الـ `onShare` و `onCopy` من الخارج (كما هو متبع في `DailyContentBaseCard`) بدلاً من كتابة المنطق داخلياً.

---

## 4. انتهاكات: Slivers & Animations (Low Priority)

### [Medium] استخدام Hardcoding في AnimatedSliverList
- **الملف:** `lib/core/common/slivers/animated_sliver_list.dart` (سطر 21، 79)
- **القاعدة المكسورة:** "DON'T hardcode spacing values."
- **الإجراء:** استبدال `12` و `16` بـ `AppSpacing.v12` و `AppSpacing.v16`.
