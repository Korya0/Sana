# 📖 ميزة القرآن (Quran Feature)

## 📌 نظرة عامة
ميزة القرآن تعرض القرآن الكريم للمستخدم بالاعتماد على حزمة `quran_library`. كان هناك خلل معماري أساسي بدمج مكتبة القرآن بشكل مباشر في واجهة المستخدم وطبقة الـ Data بدون وجود طبقة Domain وسيطة.

## 🏗 البنية المعمارية (Clean Architecture)

- **Domain Layer (NEW)**:
  - `repos`: تم استخراج الواجهة `IQuranRepo` من مجلد הـ `data` ونقلها للـ `domain` التزاماً بقواعد Clean Architecture وقاعدة الـ Dependency Inversion (DIP).

- **Data Layer**:
  - تم تحسين `QuranRepoImpl` لمعالجة أخطاء التهيئة (`Exception` و `Error`) بشكل سليم وتمرير تقارير الخطأ إلى `AppLogger.error(..., report: true)` لتسجيل المشاكل المتعلقة بعدم توافق ملفات القرآن في الفايربيز بشكل صحيح.

- **Presentation Layer**:
  - **الكيوبيت (Cubit)**: أصبح يعتمد على `IQuranRepo` من الـ Domain، وتم فصل الـ DI بشكل صحيح. إضافة الـ `operator ==` لـ `QuranState`.
  - **الواجهة (UI)**: تم التخلص من الـ `Scaffold` المتداخل في `quran_loading_widget` و `quran_error_widget` لضمان الانتقال السلس وعدم حدوث قفزات (Layout Jumps) في الواجهة الرئيسية `QuranView`.

## ⚡️ أبرز التحسينات
- تحقيق الاستقلالية (Decoupling) في تهيئة مصادر بيانات المصحف.
- القضاء التام على أخطاء الـ Scaffolds المتداخلة.
- الالتزام بالـ AppLogger لفلترة الأخطاء وعدم إرسال التنبيهات المزعجة.
