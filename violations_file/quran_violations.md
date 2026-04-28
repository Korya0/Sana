# تقرير التدقيق المعماري الصارم: ميزة Quran

بناءً على الفحص التشريحي الدقيق (Hyper-Strict Deep Dive) لملفات الميزة `quran`، ومطابقتها حرفياً مع المعايير والقواعد المنصوص عليها في `CLAUDE.md` و `PROJECT_CONTEXT.md`، تم رصد الانتهاكات التالية:

---

## 1. تسريب معماري وتمرير وهمي (Pass-through Domain Leak)
- **نوع الانتهاك ومدى خطورته:** خطير جداً (Critical)
- **مسار الملف:** `lib/features/quran/domain/use_cases/initialize_quran_use_case.dart` (الأسطر 8-10)
- **نص القاعدة التي تم كسرها:** 
  - `CLAUDE.md` (Section C.3 - Domain Layer Purity): *"If the domain layer (UseCases) is purely a pass-through that only forwards data to repositories without adding any business logic... it MUST be deleted. The feature should then be downgraded to a 2-layer architecture."*
  - `PROJECT_CONTEXT.md` (Tier 1 Strict Rule): *"If the Domain layer is purely a pass-through... it MUST be deleted and the feature downgraded to Tier 2."*
- **الإجراء البرمجي المطلوب للإصلاح:**
  1. **حذف** مجلد `domain` بالكامل من هذه الميزة (حذف الـ UseCase).
  2. تعديل `QuranCubit` في `lib/features/quran/presentation/cubit/quran_cubit.dart` ليعتمد بشكل مباشر على الـ Repository interface (`IQuranRepo`) بدلاً من `InitializeQuranUseCase`.

---

## 2. تجاهل رسالة الخطأ الموجهة للمستخدم (Silent Error UI Mapping)
- **نوع الانتهاك ومدى خطورته:** عالي (High)
- **مسار الملف:** 
  - `lib/features/quran/presentation/views/quran_view.dart` (السطر 31-33)
  - `lib/features/quran/presentation/widgets/quran_error_widget.dart` (السطر 6، 14-16)
- **نص القاعدة التي تم كسرها:**
  - `CLAUDE.md` (Section E - Error Handling Contract): *"Every ApiResult.failure must carry a Failure with a user-friendly message... Widget renders error view with user-friendly message from centralized strings."*
- **الإجراء البرمجي المطلوب للإصلاح:**
  1. في `quran_error_widget.dart`: قم بإضافة المتغير `final String message;` إلى مُنشئ الكلاس (Constructor)، وتمرير هذه القيمة إلى `AppErrorView(message: message, onRetry: onRetry)`.
  2. في `quran_view.dart`: قم بتعديل الـ pattern matching في دالة الـ `switch` لالتقاط الرسالة من الـ State وتمريرها للـ Widget لكي لا تُفقد:
     ```dart
     QuranError(:final message) => QuranErrorWidget(
       message: message,
       onRetry: () => context.read<QuranCubit>().init(),
     ),
     ```

---

## 3. وضع الـ Interface في طبقة الـ Data (Inconsistent Clean Architecture)
- **نوع الانتهاك ومدى خطورته:** متوسط (Medium)
- **مسار الملف:** `lib/features/quran/data/repos/quran_repo.dart` (الأسطر 5-7)
- **نص القاعدة التي تم كسرها:**
  - `CLAUDE.md` (Section A.1 - Architecture & Separation of Concerns): *"Follow the project's architecture layer boundaries strictly"*
- **الإجراء البرمجي المطلوب للإصلاح:**
  - الميزة حاولت تطبيق Tier 1 بإنشاء طبقة `domain`، ولكنها قامت بتعريف الـ Interface `IQuranRepo` في طبقة الـ `data` جنباً إلى جنب مع كلاس التنفيذ (Implementation)، وهو ما يخالف فصل الطبقات (يجب أن يكون الـ Interface في `domain/repositories`). 
  - **الحل:** بمجرد تطبيق الإصلاح رقم (1) وتخفيض المعمارية إلى Tier 2، سيكون وجود الـ Interface في مجلد `data` قانونياً ومقبولاً لمعمارية الطبقتين، ولكن يجب التنويه أن الحالة الحالية للميزة هي معمارية "مهجنة/غير متناسقة".

---

## 4. استخدام قيمة سحرية (Magic Number) لشفافية اللون
- **نوع الانتهاك ومدى خطورته:** منخفض (Low)
- **مسار الملف:** `lib/features/quran/presentation/widgets/quran_success_widget.dart` (الأسطر 16-18)
- **نص القاعدة التي تم كسرها:**
  - `CLAUDE.md` (Section F - Do's and Don'ts): *"DON'T use magic numbers — extract to named constants"* & *"DON'T hardcode colors... use design tokens from core/theme/"*
- **الإجراء البرمجي المطلوب للإصلاح:**
  - السطر `AppColors.primary.withValues(alpha: 0.3)` يحتوي على قيمة رقمية صلبة (Magic Number) للشفافية (`0.3`). 
  - يجب تعريف هذا اللون مسبقاً داخل كلاس الـ `AppColors` كمتغير ثابت (مثلاً: `static final Color primaryTransparent = primary.withValues(alpha: 0.3);`)، ومن ثم استدعائه هنا للحفاظ على توحيد الـ Design Tokens.
