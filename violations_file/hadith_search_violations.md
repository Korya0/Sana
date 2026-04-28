# تقرير التدقيق التشريحي لميزة Hadith Search (hadith_search_violations)

بناءً على التدقيق الصارم لملفات ميزة `hadith_search` ومقارنتها حرفياً بالقواعد المعمارية للمشروع الموثقة في `CLAUDE.md` و `PROJECT_CONTEXT.md`، تم رصد الانتهاكات التالية:

## 1. استخدام Code Generation في الـ State (انتهاك صارم)
- **الخطورة**: High
- **مسار الملف**: `lib/features/hadith_search/presentation/cubit/hadith_search/hadith_search_cubit.dart` (السطر 6) و `hadith_search_state.dart`
- **القاعدة المكسورة**: Section C.2 - No Code Generation ("No Freezed... Use Dart 3+ native features instead: sealed class for state unions").
- **الإجراء المطلوب**: إزالة الاعتماد على `Freezed` من الـ State واستخدام `sealed class` الأصلي في Dart 3 لتطبيق exhaustive pattern matching بدلاً من ذلك (كما هو مستخدم في نموذج `ApiResult`).

## 2. Hardcoding لسلاسل نصية (Strings Leak)
- **الخطورة**: High
- **مسار الملف**: `lib/features/hadith_search/presentation/widgets/suggestions_grid.dart` (الأسطر 18-42)
- **القاعدة المكسورة**: Section B.2 - Text & String Management ("All user-facing Arabic text MUST be centralized... No inline Arabic strings allowed") و Section F ("DON'T hardcode Arabic strings").
- **الإجراء المطلوب**: نقل جميع الكلمات المكتوبة في `categorizedSuggestions` (مثل 'الصلاة', 'الصيام', إلخ) إلى ملف `AppStrings` المركزي `core/constants/app_strings.dart` واستدعائها منه.

## 3. تعديل خصائص الـ Typography المحظورة عبر `.copyWith`
- **الخطورة**: Critical
- **مسار الملف**: `lib/features/hadith_search/presentation/widgets/suggestions_grid.dart` (السطر 148)
- **القاعدة المكسورة**: Section C.10 - Typography Purity ("NEVER use .copyWith to modify fontSize... Use it ONLY for secondary properties").
- **الإجراء المطلوب**: إزالة `.copyWith(fontSize: 13)` بالكامل. يجب استخدام Style جاهز من `AppTextStyles` يناسب حجم 13، وإذا لم يكن موجوداً يجب إضافته مركزياً في ملف `AppTextStyles`.

## 4. معالجة الأخطاء خارج طبقة الـ Error Handler
- **الخطورة**: High
- **مسار الملف**: `lib/features/hadith_search/data/repos/hadith_repository.dart` (الأسطر 23-27)
- **القاعدة المكسورة**: Section E - Error Flow Diagram و Section C.5 ("Data layer: catch exceptions and map to typed Failure classes via centralized error handler").
- **الإجراء المطلوب**: إزالة الفحص اليدوي لنوع الخطأ باستخدام `errorStr.contains('socketexception')`، وترك عملية التقاط الاستثناءات وتصنيفها بالكامل لـ `ApiErrorHandler.handle(e)`.

## 5. تسريب منطق (Logic Leak) إلى الـ UI
- **الخطورة**: Medium
- **مسار الملف**: `lib/features/hadith_search/presentation/views/hadith_search_view.dart` (الأسطر 48-55)
- **القاعدة المكسورة**: Section A.1 - Architecture ("UI/presentation layer has ZERO business logic") و Section C.9 ("Presentation widgets should be as simple and Stateless as possible").
- **الإجراء المطلوب**: نقل منطق الـ Debounce والتحقق من طول النص (`query.trim().length >= 2`) إلى داخل `HadithSearchCubit` باستخدام حزم مثل `rxdart` (عن طريق `debounceTime` في تحويل الـ events) لضمان خلو واجهة المستخدم من أي منطق معالجة.

## 6. اختراع UI Decorations مخصصة بدلاً من الموحدة
- **الخطورة**: Medium
- **مسار الملف**: `lib/features/hadith_search/presentation/widgets/hadith_item_card.dart` (الأسطر 28-34)
- **القاعدة المكسورة**: Section B.1 - Common Decorations ("Reuse shared decoration widgets for cards... Never create ad-hoc decorations") و Project Context Section C.
- **الإجراء المطلوب**: استبدال `BoxDecoration` الحالي باستخدام `featureCardDecoration()` الموجود في `core/common/decorations/feature_card_decoration.dart`.

## 7. قيم ثابتة للأبعاد (Magic Numbers & Hardcoded Sizing)
- **الخطورة**: Low
- **مسار الملفات**: 
  - `suggestions_grid.dart` (السطر 118): `size: 20`
  - `hadith_item_card.dart` (السطر 33): `width: 1.5`
  - `hadith_search_share_and_favorite_buttons.dart` (السطر 51): `iconSize: 20`
- **القاعدة المكسورة**: Section F ("DON'T use magic numbers — extract to named constants") و Section C.10 ("Explicit UI Scaling: Use .r(context) in the UI only for other dimensions").
- **الإجراء المطلوب**: استخدام دوال التصميم التفاعلي للـ UI `20.r(context)` للأيقونات، أو استخدام متغيرات المسافات `AppSpacing`.

---

## 8. طبقة الـ Domain بدون فائدة (Pass-through Leak)
- **الخطورة**: High
- **مسار الملف**: `lib/features/hadith_search/domain/use_cases/search_hadith_use_case.dart` وكل مجلد `domain/`.
- **القاعدة المكسورة**: Section C.3 - Domain Layer Purity (تم تحديثها لتمنع الطبقات المجردة من المنطق) و Project Context (Tier 1 Strict Rule).
- **الإجراء المطلوب**: حذف طبقة الـ `domain` بالكامل (بما فيها Entities و Use Cases) لميزة `hadith_search`، وجعل الـ `Cubit` يعتمد مباشرة على الـ `HadithRepoImpl` مع تغيير هيكلة الميزة لتصبح ثنائية الطبقات (Tier 2). سيتم دمج الكيانات مع النماذج (Models) مباشرة إن لزم الأمر.

---

## 💡 إعادة النظر الهندسية: بخصوص حذف طبقة الـ Domain

**سؤالك**: "هل الأفضل حذف طبقة الـ Domain لأنها تمرر بيانات فقط وليس لها دور أم لا؟"

**الإجابة الصارمة والتصحيح**: **نعم، يُنصح بشدة بحذف طبقة الـ Domain بأكملها من هذه الميزة.**

**التبرير المعماري الجديد (بعد تحديث القواعد):**
لقد كنتَ محقاً تماماً في ملاحظتك. بما أن `SearchHadithUseCase` لا يقوم بأي عمليات تحقق، دمج بيانات، أو معالجة (Business Logic) وهو مجرد ممر (Pass-through) من الـ `Cubit` إلى الـ `Repository`، فإن إبقاء طبقة الـ `Domain` يعتبر **(Over-engineering)** صريح ويضيف تعقيداً بلا فائدة (Boilerplate code).
بناءً على التحديث الجديد لقواعد المشروع:
1. تم نقل ميزة `hadith_search` من (Tier 1) إلى (Tier 2 - Simplified Clean Architecture).
2. سيقوم الـ `HadithSearchCubit` بالتخاطب المباشر مع واجهة الـ `Repository`.
هذا سيجعل الكود أنظف، أسهل للصيانة، ويتوافق مع مبدأ "Make the smallest change that solves the problem".
