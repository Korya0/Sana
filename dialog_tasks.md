# خطة مهام توحيد الحوارات (Dialogs Standardization Tasks)

## الهدف
استبدال واعتماد `AppDialog` كحاوية أساسية مرنة (Wrapper) لجميع حوارات التطبيق بدلاً من الحوارات المتعددة الحالية، مع استثناء `CustomRichContentDialog` فقط، مع الالتزام التام بقواعد `CLAUDE_UI.md`.

## المهام المطلوبة للتنفيذ لاحقاً:

- [x] **1. إنشاء المكون الأساسي (AppDialog)**
  - المسار: `lib/core/common/overlays/dialog/app_dialog.dart`
  - التعديل المطلوب: جعله حاوية عامة تستقبل `Widget child` بدلاً من احتوائه على نصوص وأزرار ثابتة.
  - الالتزام بقواعد UI:
    - **الألوان**: `backgroundColor`: `context.color.secondaryScaffoldBackgroundColor`
    - **الفراغات والحواف**: يُمنع استخدام أرقام صلبة (Magic Numbers). يجب استخدام `AppSpacing`:
      - `borderRadius`: `BorderRadius.circular(AppSpacing.radiusM)` (أو القيمة المناسبة لـ 16)
      - `insetPadding`: `EdgeInsets.symmetric(horizontal: AppSpacing.w24)`
      - `padding` داخلي للـ child: `EdgeInsets.all(AppSpacing.p16)`
    - **التباعد (Gaps)**: استخدام `AppGap` بدلاً من `SizedBox` لأي مسافات داخلية إن وجدت.

- [x] **2. تعديل مكون البنية التحتية القديم (`CustomDialog`)**
  - المسار: `lib/core/common/overlays/dialog/custom_dialog.dart`
  - التعديل المطلوب: تعديله ليقوم ببساطة باستدعاء (أو إرجاع) `AppDialog` كبنية تحتية لتجنب تكرار الكود.

- [x] **3. تحديث `SecretPinDialog`**
  - المسار: `lib/core/common/widgets/secret_pin_dialog.dart`
  - التعديل المطلوب: تغليف محتوى الـ PIN داخل `AppDialog`.
  - الالتزام بقواعد UI: نقل أي نصوص مباشرة إلى `AppStrings`، وعدم استخدام `.copyWith` لتغيير ألوان أو أحجام الخطوط المأخوذة من `AppTextStyles`.

- [x] **4. تحديث `DailyContentExplanationDialog`**
  - المسار: `lib/core/common/overlays/dialog/daily_content_explanation_dialog.dart`
  - التعديل المطلوب: استخدام `AppDialog` وتمرير النص الشرح وزر الإغلاق بداخله كـ `child`.
  - الالتزام بقواعد UI: استخدام `AppStrings` لجميع النصوص، واستخدام `AppGap` للفواصل، وتجنب استخدام `.copyWith(color: ...)`.

- [x] **5. تحديث `CustomConfirmationDialog`**
  - المسار: `lib/core/common/overlays/dialog/custom_confirmation_dialog.dart`
  - التعديل المطلوب: تمرير عنوان التأكيد، الرسالة، وأزرار الاختيار كـ `child` داخل `AppDialog`.
  - الالتزام بقواعد UI: تجنب الأرقام الصلبة في الـ Padding/Spacing داخل الـ `child` واعتماد `AppSpacing`. استخدام `AppGap` للمسافة بين أزرار التأكيد والإلغاء.

- [x] **6. تحديث `CustomInfoDialog`**
  - المسار: `lib/core/common/overlays/dialog/custom_info_dialog.dart`
  - التعديل المطلوب: استخدام `AppDialog` كغلاف، مع تمرير المحتوى التعليمي كـ `child`.
  - الالتزام بقواعد UI: الالتزام بكلاس الألوان `context.color` للأيقونات، وتجنب `.copyWith` للخطوط.

## ملاحظات هامة
- **الاستثناء:** لن يتم إجراء أي تعديل على `CustomRichContentDialog` (`lib/core/common/overlays/dialog/custom_rich_content_dialog.dart`).
- **النصوص:** يمنع منعاً باتاً كتابة أي نصوص عربية مباشرة (inline strings) داخل ملفات UI الدايلوجات؛ جميع النصوص يجب إضافتها واستدعاؤها من `AppStrings`.
- **التباعد والتجاوب:** استخدام `AppGap` بدلاً من `SizedBox`، واستخدام `AppSpacing` للهوامش والتجاوب.
