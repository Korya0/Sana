# خطة عمل نظام السمات المزدوج المحدثة — التنفيذ التدريجي الآمن (Safe Phased Feature Plan)

تمت إعادة هيكلة خطة العمل بالكامل وتوحيدها لتجمع بين **لوحة الألوان المصفاة المعتمدة (9 ألوان)** و**استراتيجية التنفيذ التدريجي الآمن** لمنع أي تراجع أو تغير بصري مفاجئ في واجهات التطبيق الحالية، مع تحديث ملفات القواعد البرمجية لضمان الامتثال المستقبلي.

---

## 🏛️ استراتيجية التنفيذ على مراحل (Phased Roadmap)

### 📌 المرحلة 1: دمج وتصفية الألوان في الملف الحالي (`app_colors.dart`)
**الهدف:** تقليص عدد الألوان في الملف الحالي وإلغاء الألوان المكررة أو الهامشية واستبدالها في الكود البرمجي بالكامل، لضمان عدم حدوث أي تغيير غير مرغوب في مظهر التطبيق الحالي (تجنب الـ Regression البصري).
- دمج الألوان الزائدة والمكررة وتهيئتها برمجياً (كما هو مفصل في جدول التصفية أدناه).
- **النتيجة:** سيصبح كلاس `AppColors` الحالي شديد النقاء ويحتوي فقط على الألوان الأساسية المعتمدة، وسيبني التطبيق ويعمل بنفس المظهر القديم تماماً.

### 📌 المرحلة 2: تجربة وضبط الألوان من قِبل المستخدم (User Testing & Tweaking)
**الهدف:** إتاحة الفرصة لك لتعديل درجات الألوان يدوياً وتجربة تحويل الخلفيات للأبيض وضبط درجات المظهر الجديد (Tweaking) للوصول للدرجات الفاتحة المطلوبة بدقة دون القلق من تغير أسماء المتغيرات.
- تقوم يدوياً بتعديل الألوان وتجربتها على الواجهة لرؤية المظهر الجديد والتأكد من تناسق درجات الذهبي والأخضر مع الخلفية البيضاء.
- بمجرد استقرارك على الدرجات المطلوبة للمظهرين، ننتقل للمرحلة التالية.

### 📌 المرحلة 3: تأسيس البنية المعمارية للسمات (Theme Architecture & Extensions)
**الهدف:** نقل الألوان المستقرة والنهائية إلى المعمارية المزدوجة باستخدام `ThemeExtension` و `BuildContext` المقتبسة من مشروع `shebtqs`.
- إنشاء `colors_dark.dart` و `colors_light.dart` لوضع الألوان المستقرة بداخلها.
- إنشاء الملحقات `MyColors` و `MyAssets` لإدارة الألوان والشعارات ديناميكياً.
- تعديل `ContextExtension` لإتاحة الاستدعاء السريع `context.color` و `context.image`.

### 📌 المرحلة 4: دمج السمات وتحديث الخطوط (Theme & Styles Integration)
- تعديل `app_theme.dart` لإنشاء وضبط سمة الظلام وسمة الإضاءة وإدراج الملحقات.
- تحديث `app_text_styles.dart` لتقرأ الألوان ديناميكياً من الـ `context` بدلاً من الثوابت الجامدة.

### 📌 المرحلة 5: الهجرة الشاملة للواجهات والتعديل البرمجي (UI Migration)
- تعديل مشيدات الـ `CustomPainter` (البوصلة وغيرها) لاستلام الألوان ديناميكياً.
- الاستبدال المنظم والشامل لـ `AppColors.something` بـ `context.color.something` في كافة واجهات التطبيق (حوالي 300 مكان).

### 📌 المرحلة 6: التخزين المحلي وإدارة الحالة (State Management & Local Storage)
- تعديل `storage_keys.dart` وإضافة مفتاح السمة.
- إنشاء `app_cubit.dart` و `app_state.dart` للتكامل مع الـ `ILocalStorageService` (Hive) لتخزين واستعادة السمة المختارة محلياً عند الإقلاع.

### 📌 المرحلة 7: تحديث ملفات القواعد البرمجية (.agent/ Rules Update)
- تعديل ملفات القوانين في مجلد `.agent/` لتوثيق استخدام السمة الجديدة ومنع المساعدين من كتابة كود يعتمد على `AppColors` القديم مستقبلاً.

---

## 🎨 استراتيجية دمج وتوحيد الألوان (Strategy A - Standardized & Unified)
تقليص وتصفية لوحة الألوان بالكامل لتنظيف الكود المصدري وتأسيس نظام سمات شديد البساطة والمرونة يعتمد على **9 خواص رئيسية فقط** بدلاً من 20 لوناً سابقاً:

### 1. الألوان الأساسية للخلفيات والبراند:
- `scaffoldBackground`: الخلفية الأساسية للتطبيق (أسود ناصع `0xFF000000` في الظلام / رمادي فاتح جداً `0xFFF9FAFB` في الإضاءة).
- `secondaryBackground`: خلفية الكروت والحاويات (رمادي iOS داكن `0xFF1C1C1E` في الظلام / أبيض ناصع `0xFFFFFFFF` في الإضاءة).
- `primary`: اللون الذهبي الأساسي المميز للتطبيق (البراند).
- `secondry` (مع الاحتفاظ بالتهجئة الحالية): اللون الأخضر الفرعي الفخم للتطبيق (وسيتم دمج درجات الأخضر الفرعية `success` فيه بالكامل).
- `red`: اللون الأحمر للأخطاء أو الحذف (وسيتم دمج `iconRed` فيه).

### 2. الألوان الديناميكية للنصوص والرموز (Strategy A):
- `textPrimary`: النص الأساسي للجسم (يتحول تلقائياً: **أبيض** في الظلام / **أسود داكن** في الإضاءة). *[تسمية بديلة لـ `textWhite` و `white` السابقين]*.
- `textSecondary`: النص الوصفي والثانوي (يتحول تلقائياً: **رمادي فاتح** في الظلام / **رمادي داكن** في الإضاءة). *[تسمية بديلة لـ `textGrey` و `grey` السابقين]*.
- `textAccent`: النص الملون بالذهبي (اللون الأساسي للبراند) وتتغير درجته ديناميكياً للتباين مع الخلفيات. *[تسمية بديلة لـ `textPrimary` القديم الذي كان يرمز للذهبي]*.
- `iconAccent`: الرموز الملونة ديناميكياً بالذهبي المميز للبراند. *[تسمية بديلة لـ `iconPrimary` القديم]*.

### ❌ جدول الألوان المحذوفة والمدمجة في الكود:
* **دمج** `success` و `textSuccess` و `iconSuccess` في **`secondry`** (الأخضر).
* **دمج** `appCardGreen` في **`secondaryBackground`** (أو تدرج مشتق من `secondry.withValues(alpha: 0.1)`).
* **دمج** `warning` في **`primary`** أو تعويضه.
* **حذف** `facebookBlue` من الثوابت ونقله مباشرة كقيمة صلبة داخل الـ Widget المخصصة له.
* **حذف** `white` و `grey` ودمجهما في النصوص `textPrimary` و `textSecondary`.

---

## 📂 الكلاسات والملفات الجديدة والمعدلة بالتفصيل

### 1. طبقة الألوان الأساسية (Colors Layer)
- [NEW] `ColorsDark` (في `lib/core/theme/style/colors/colors_dark.dart`):
  - كلاس ثابت يحتوي على ثوابت الألوان المصفاة والموحدة لوضع الظلام الحالي.
- [NEW] `ColorsLight` (في `lib/core/theme/style/colors/colors_light.dart`):
  - كلاس ثابت يحتوي على درجات ألوان وضع الإضاءة المصفاة والموحدة المتناسقة تماماً مع الخلفية البيضاء.

### 2. طبقة الملحقات (Extensions Layer)
- [NEW] `MyColors` (في `lib/core/theme/style/theme/color_extension.dart`):
  - يمتد من `ThemeExtension<MyColors>` ليربط درجات الألوان التسعة الثنائية ويوفر ميزة الـ `lerp` السلسة.
- [NEW] `MyAssets` (في `lib/core/theme/style/theme/assets_extension.dart`):
  - يمتد من `ThemeExtension<MyAssets>` ليربط أصول الصور الديناميكية للوغو (`app_logo_light.jpg` في الإضاءة / `app_logo_dark.jpg` في الظلام).
- [MODIFY] `ContextExtension` (في `lib/core/utils/context_extension.dart`):
  - تعديل ملف الملحقات الموجود مسبقاً لإضافة خصائص `color` و `image` للوصول السريع والآمن من الـ Context.

### 3. طبقة السمة الكلية والخطوط (Theme & Typography Layer)
- [MODIFY] `AppTheme` (في `lib/core/theme/style/app_theme.dart`):
  - تفعيل ميثودز `themeLight()` و `themeDark()` وتطعيمها بملحقات الألوان والصور.
- [MODIFY] `AppTextStyles` (في `lib/core/theme/fonts/app_text_styles.dart`):
  - تحديث كود الخطوط ليقرأ الألوان ديناميكياً من `context.color.textPrimary` و `context.color.textSecondary` و `context.color.textAccent` بدلاً من الألوان الثابتة السابقة.

### 4. طبقة الواجهات والرسامات (UI & Painters Migration)
- هجرة شاملة لجميع استدعاءات `AppColors.` في الواجهات إلى `context.color.`.
- تمرير الألوان للـ `CustomPainters` عبر الـ Constructors من الـ Widgets التي تملك الـ Context.

### 5. طبقة حفظ الحالة وإدارة السمة محلياً (State Management & Storage)
- [MODIFY] `StorageKeys` (في `lib/core/services/local_storage/storage_keys.dart`):
  - إضافة مفتاح تخزين السمة `themeMode` لتخزينه محلياً.
- [NEW] `AppCubit` (في `lib/core/app/cubit/app_cubit.dart`):
  - كلاس Cubit لإدارة السمة واللغات، يقرأ ويكتب إعدادات السمة محلياً عبر `ILocalStorageService` (المتواجدة بالفعل في المشروع).
- [NEW] `AppState` (في `lib/core/app/cubit/app_state.dart`):
  - كلاس الحالات لـ `AppCubit` لمعالجة تغيرات السمة ديناميكياً.

---

## 📜 تحديث وتعديل قواعد المساعد الذكي (.agent/ Rules Update)

لتفادي كتابة المساعدين الأكواد بـ `AppColors` القديم مستقبلاً، سنقوم بالتعديلات البرمجية التالية على قواعد الوكيل الذكي:

### 1. تعديل [CLAUDE_UI.md](file:///d:/flutter/flutter_Projects/muslim_app/.agent/CLAUDE_UI.md):
- **السطر 70 (الوضع القديم):**
  `- **DO** استخدم توكنات نظام التصميم المركزية للخطوط والألوان والتفاصيل (`AppColors`, `AppSpacing`, `AppTextStyles`).`
- **تحديث إلى (الوضع الجديد):**
  `- **DO** استخدم ألوان السمة الديناميكية عبر `context.color.colorName` و `AppSpacing` للفراغات و `AppTextStyles` للخطوط.`

### 2. تعديل [PROJECT_CONTEXT.md](file:///d:/flutter/flutter_Projects/muslim_app/.agent/PROJECT_CONTEXT.md):
- **السطر 182 (الوضع القديم):**
  `- **Colors**: `AppColors` in `core/theme/style/app_colors.dart``
- **تحديث إلى (الوضع الجديد):**
  `- **Colors**: ألوان السمة عبر `context.color` المعرفة في `MyColors` في `core/theme/style/theme/color_extension.dart``
- **السطر 207 (الوضع القديم):**
  `- **DO** use `AppColors`, `AppSpacing`, `AppTextStyles` for all styling (defined in `core/theme/`).`
- **تحديث إلى (الوضع الجديد):**
  `- **DO** use `context.color` for colors (defined in `MyColors`), and `AppSpacing`, `AppTextStyles` for styling (defined in `core/theme/`).`

### 3. تعديل [CLAUDE.md](file:///d:/flutter/flutter_Projects/muslim_app/.agent/CLAUDE.md):
- **السطر 102 (الوضع القديم):**
  `| Constants classes | `App` prefix + `PascalCase` | `AppColors`, `AppSpacing` |`
- **تحديث إلى (الوضع الجديد):**
  `| Constants classes | `App` prefix + `PascalCase` | `MyColors` (ThemeExtension), `AppSpacing` |`
- **السطر 111 (الوضع القديم):**
  `| Static constants | `camelCase` | `AppColors.scaffoldBackground` |`
- **تحديث إلى (الوضع الجديد):**
  `| Static constants | `camelCase` | `AppSpacing.md` |`

---

## 📋 قائمة المهام التفصيلية للتنفيذ (Checklist)

### 📌 المرحلة 1: دمج وتصفية الألوان في الملف الحالي (`app_colors.dart`)
- [x] استبدال درجات `success` و `textSuccess` و `iconSuccess` بـ `secondry` في كامل الكود المصدري.
- [x] استبدال `appCardGreen` بـ `secondry` أو `secondaryBackground` في الكروت المعنية.
- [x] استبدال `warning` بـ `primary` أو درجات مناسبة في الكود.
- [x] نقل لون الفيسبوك `facebookBlue` محلياً داخل واجهته وحذفه من المجلد المركزي.
- [x] تنظيف ملف `app_colors.dart` الحالي ليحتوي فقط على الألوان التسعة الأساسية المعتمدة للظلام.
- [x] فحص بناء التطبيق والتأكد البصري من مطابقة المظهر للنسخة السابقة تماماً.

### 📌 المرحلة 2: تجربة وضبط الألوان من قِبل المستخدم (User Testing & Tweaking)
- [x] توقف المساعد الذكي بالكامل لإتاحة الفرصة للمستخدم لتعديل درجات الألوان ورؤية النتائج بصرياً في وضع الإضاءة وتثبيت لوحة الألوان النهائية.

### 📌 المرحلة 3: تأسيس البنية المعمارية للملحقات والسمة المزدوجة
- [x] إنشاء ملف `colors_dark.dart`
- [x] إنشاء ملف `colors_light.dart`
- [x] إنشاء ملف `color_extension.dart` في `lib/core/theme/style/theme/`
- [x] إنشاء ملف `assets_extension.dart` في `lib/core/theme/style/theme/`
- [x] تعديل `context_extension.dart` في `lib/core/utils/`

### 📌 المرحلة 4: دمج السمات والخطوط (Theme & Styles)
- [x] تعديل `app_theme.dart` لتعديل سمة الظلام وإنشاء سمة الإضاءة وإدراج الملحقات
- [x] تعديل `app_text_styles.dart` لتعتمد الألوان فيه على نظام الألوان الديناميكي

### 📌 المرحلة 5: هجرة الرسامين وهجرة الواجهات
- [x] فحص وتعديل `compass_background_painter.dart` لاستلام الألوان عبر المشيد
- [x] استبدال كافة استدعاءات `AppColors.` في الواجهات بـ `context.color.` عبر طبقات التطبيق

### 📌 المرحلة 6: التخزين المحلي وإدارة الحالة
- [x] تعديل `storage_keys.dart` وإضافة مفتاح `themeMode`.
- [x] إنشاء `app_cubit.dart` و `app_state.dart` وإضافتهما لـ `service_locator.dart` و `main.dart`.
- [x] التحقق النهائي من تذكر السمة وحفظها محلياً في الـ Hive.

### 📌 المرحلة 7: تحديث القواعد المصدرية للوكيل الذكي (.agent/ Rules)
- [x] تعديل ملف [CLAUDE_UI.md](file:///d:/flutter/flutter_Projects/muslim_app/.agent/CLAUDE_UI.md) لتحديث قاعدة توكنات التصميم (السطر 70) من `AppColors` إلى `context.color`.
- [x] تعديل ملف [PROJECT_CONTEXT.md](file:///d:/flutter/flutter_Projects/muslim_app/.agent/PROJECT_CONTEXT.md) لتحديث تعريف ألوان السمة (السطر 182) من `AppColors` إلى `MyColors`.
- [x] تعديل ملف [PROJECT_CONTEXT.md](file:///d:/flutter/flutter_Projects/muslim_app/.agent/PROJECT_CONTEXT.md) لتحديث قاعدة دمج ألوان الخطوط (السطر 207) لاستخدام `context.color` بدلاً من `AppColors`.
- [x] تعديل ملف [CLAUDE.md](file:///d:/flutter/flutter_Projects/muslim_app/.agent/CLAUDE.md) لتحديث كلاسات الثوابت (السطر 102) من `AppColors` إلى `MyColors`.
- [x] تعديل ملف [CLAUDE.md](file:///d:/flutter/flutter_Projects/muslim_app/.agent/CLAUDE.md) لتحديث أمثلة الثوابت الثابتة (السطر 111) من `AppColors.scaffoldBackground` إلى `AppSpacing.md`.
