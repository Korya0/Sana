# تقرير التدقيق المعماري الصارم: ميزة تعليم الصلاة (Teaching Prayer)

تم إجراء فحص تشريحي دقيق لميزة `teaching_prayer` ومطابقتها حرفياً مع قواعد المشروع المنصوص عليها في ملفي `CLAUDE.md` و `PROJECT_CONTEXT.md`. نتيجة الفحص أظهرت الكود بمستوى عالٍ من الجودة والامتثال لبنية Tier 2 Clean Architecture، ولكن تم رصد الانتهاكات التالية التي يجب معالجتها لتحقيق التوافق بنسبة 100%.

---

## ❌ الانتهاك الأول: كتم الأخطاء (Error Swallowing) في طبقة البيانات
- **مدى الخطورة:** 🔴 **Critical** (حرج)
- **مسار الملف:** `lib/features/teaching_prayer/data/datasources/teaching_prayer_local_data_source.dart`
- **أرقام الأسطر:** `36 - 45`
- **نص القاعدة المكسورة:** 
  - **Section F (DON'T):** "DON'T swallow errors silently — always log and surface to the user"
  - **Section A.3:** "Catch errors at the boundary (data layer), not deep inside business logic"
  - **Section E:** "Never throw raw exceptions from the data layer — always map to Failure"
- **وصف الانتهاك:** 
  تقوم دالة `getSections` بصيد الاستثناء (`catch Exception`)، وتقوم بتسجيله ثم إرجاع قائمة فارغة `[]`. هذا التصرف يكتم الخطأ تماماً (Swallowing the error). ونتيجة لذلك، عند استدعاء هذه الدالة من `TeachingPrayerRepoImpl`، سيرى الـ Repository قائمة فارغة وسيرجع خطأ من نوع `Failure.missingData` بدلاً من الخطأ الفعلي (مثل مشكلة في قراءة الملف أو الـ Parsing) والذي يجب أن يُترجم إلى `Failure.cache`.
- **الإجراء البرمجي الدقيق المطلوب:**
  يجب إزالة كتلة `try-catch` بالكامل من دالة `getSections` في `TeachingPrayerLocalDataSource`، أو على الأقل عمل `rethrow` للاستثناء. طبقة الـ Repository (`TeachingPrayerRepoImpl`) مجهزة بالفعل بكتلة `try-catch` تقوم بالتقاط الاستثناء وتحويله بشكل صحيح إلى `ApiResult.failure(Failure.cache(...))`. عدم كتم الخطأ هنا سيسمح بتدفق الأخطاء بشكل سليم حسب دورة حياة المشروع.

---

## ❌ الانتهاك الثاني: استخدام نصوص عربية مضمنة (Hardcoded Arabic Strings)
- **مدى الخطورة:** 🟡 **Medium** (متوسط)
- **مسار الملف:** `lib/features/teaching_prayer/presentation/widgets/teaching_prayer_loading_widget.dart`
- **أرقام الأسطر:** `25, 30, 31`
- **نص القاعدة المكسورة:** 
  - **Section B.2:** "All user-facing Arabic text MUST be centralized in a single strings constant. No inline Arabic strings allowed."
  - **Section F (DON'T):** "DON'T hardcode Arabic strings — add them to centralized strings"
- **وصف الانتهاك:**
  تم استخدام نصوص عربية بشكل مباشر (Hardcoded) كبيانات وهمية لحالة التحميل (`'جاري التحميل...'`، `'اسم الموضوع جاري التحميل'`، `'محتوى الموضوع جاري التحميل...'`). على الرغم من أن هذه النصوص تستخدم من قبل `Skeletonizer` لرسم هيكل التحميل (Skeleton Blocks)، إلا أن وجود أي نصوص عربية مضمنة في ملفات الـ Dart يُعد خرقاً صريحاً وقاطعاً لقاعدة مركزية النصوص.
- **الإجراء البرمجي الدقيق المطلوب:**
  استبدال هذه النصوص العربية بنصوص إنجليزية وهمية لا تحتاج لترجمة (مثل `'Loading...'` أو سلسلة من الحروف مثل `'xxxxxxxxxxxx'`) والتي تكفي تماماً لقيام الـ Skeletonizer برسم الأشكال الهيكلية. إذا كان هناك حاجة ملحة لنصوص مقروءة حتى أثناء التحميل، يجب سحبها حصرياً من `AppStrings`.
