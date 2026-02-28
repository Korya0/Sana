# 🔍 Hadith Search Feature (البحث في الأحاديث)

هذا الموديول هو بوابة المستخدم للبحث والتدقيق في السنة النبوية المطهرة، حيث يوفر واجهة بحث ذكية مرتبطة بقاعدة بيانات "الدرر السنية" الضخمة، مع تقديم النتائج بشكل منظم وشامل.

## 🛠️ كيف تعمل الميزة؟

1.  **البحث الفوري (API Integration)**: 
    *   يتم جلب البيانات الحية من موقع "الدرر السنية" عبر API مخصص.
    *   يستخدم الموديول نظام "البحث في كل الكلمات" لضمان أقصى قدر من الدقة.
2.  **المعالج الذكي للنصوص (Smart Parser)**: 
    *   بما أن النتائج تعود بتنسيق HTML معقد، يقوم الـ `HadithModel` بتحليل النصوص واستخراج المعلومات الأساسية (الراوي، المحدث، المصدر، حكم المحدث) وفصلها عن متن الحديث بشكل برمجي دقيق.
3.  **تجربة البحث السلسة (Advanced UX)**:
    *   **Debouce Search**: تأخير عملية البحث لمدة 500ms أثناء الكتابة لتقليل استهلاك الـ API وتحسين الأداء.
    *   **Pagination**: تحميل تلقائي لنتائج إضافية (Infinite Scroll) عند الوصول لنهاية القائمة.
    *   **Highlighting**: تمييز كلمات البحث داخل متن الحديث مع تجاهل التشكيل والرموز باستخدام `ArabicRegexUtils`.
4.  **نظام المفضلة الذكي (Offline First & Optimistic Updates)**: 
    *   يتم تخزين الأحاديث المفضلة محلياً مع كافة بياناتها (Metadata) في `SharedPreferences`.
    *   يعتمد `HadithFavoritesCubit` على الـ **Optimistic Update**، حيث تتحدث حالة الواجهة (القلب) فور النقر بدون أي تأخير (Lag)، ويتم إرسال العمليات لتُحفظ في الخلفية باستخدام `unawaited` (مبدأ Fire and Forget).
    *   حالة المفضلة مخزنة ضمن طبقة الـ UI State لضمان تقليل استدعاءات `Repository` العشوائية بناءً على معايير `Clean Architecture` الصارمة.
5.  **المشاركة المتقدمة (Premium Sharing)**: 
    *   إمكانية تحويل أي حديث إلى صورة فنية جاهزة للمشاركة، مع إخفاء بعض البيانات التقنية (مثل المصدر) لتوفير مساحة لمتن الحديث وجعل الصورة أرقى بصرياً.

---

## ✨ المميزات التقنية وإعادة الهيكلة (Technical Refactoring)

تمت إعادة هيكلة هذا الموديول بالكامل للتماشي مع أقصى درجات **Clean Architecture** وجودة الكود (`very_good_analysis`):

- **فصل الطبقات (Clean Architecture)**: الاعتماد الصارم على `IHadithFavoritesRepository` في الـ `domain` للفصل بين الـ data والـ UI.
- **تفكيك الـ Widgets (Composition)**: تم تفريغ الكارت الرئيسي للحديث (`HadithItemCard`) ونقل المنطق المحوسب إلى `HadithFormatter` (ملونات الأحكام وتنسيقات النسخ وتمييز النصوص). كما استخرج ملف الـ `TextField` كعنصر مستقل `HadithSearchTextField`.
- **No Magic Strings**: تم تفريغ كافة النصوص الثابتة سواء الخاصة بواجهة المستخدم (الأزرار والرسائل) نحو `AppStrings` أو تلك الخاصة بالـ Domain (كبيانات المصدر ومفاتيح JSON والـ API Endpoint) نحو مُعرّف خاص `HadithApiConstants`.
- **الاعتمادية السليمة للـ Error Widgets**: التعامل بشكل مركزي باستخدام `AppErrorWidget` لحالات فشل البحث وإعادة المحاولة.

---

## 📂 هيكل الملفات (Structure)

-   `data/`
    - `data_sources/hadith_remote_data_source.dart`: إدارة الطلبات لـ API الدرر السنية.
    - `models/hadith_model.dart`: البيانات مع تحليل الـ HTML وفصل Metadata (مدعوم بمفاتيح من Constants).
    - `repositories/hadith_favorites_repository.dart`: تطبيق تنفيذ حفظ الأحاديث (Implementation).
-   `domain/`
    - `entities/hadith_entity.dart`: الكيان الأساسي للبيانات.
    - `repositories/i_hadith_favorites_repository.dart`: الواجهة الصريحة لمنع اقتران الـ UI بقاعدة البيانات.
    - `use_cases/search_hadith_use_case.dart`: ربط بحث التطبيق بمصادر البيانات.
-   `presentation/`
    - `controller/`:
        - `hadith_search/`: عمليات البحث، الصفحات، وحالات التحميل.
        - `hadith_favorites/`: إدارة تخزين واسترجاع وتحديث حالة تفضيل الأحاديث بطريقة التحديث المتفائل.
    - `widgets/`:
        - `HadithContentWidget`: المكون المسؤول عن رسم الحديث وتنسيقه بالـ HTML.
        - `HadithItemCard`: الكارت الأساسي للنتائج بجميع وظائفه مستنداً على Formatting Utils.
        - `HadithSearchTextField`: شريط البحث المستخرج.
-   `utils/` (المعالجات الرياضية والمنطق التجريدي للواجهة):
    - `hadith_api_constants.dart`: متغيرات الـ API والـ JSON.
    - `hadith_formatter.dart`: دوال تجميع النصوص وتلوين أحكام الأحاديث.
    - `arabic_regex_utils.dart`: معالجات الحروف المنطقية للبحث كـ Regexs.

---

## 📝 ملاحظات للمطور
*   **API Limits**: موقع الدرر قد يفرض قيوداً في حال كثرة الطلبات المتكررة جداً، لذا تم وضع نظام الـ Debounce.
*   **HTML Safety**: عند إضافة أي تنسيق جديد في الـ `HadithContentWidget` تأكد من اختبار ظهور النص في كروت المشاركة لضمان عدم حدوث Overflow.
*   **Search Suggestions**: يتم اقتراح كلمات بحث شهيرة في الشاشة الرئيسية للفيتشر بتصميم جذاب لتشجيع المستخدم على الاستكشاف.
