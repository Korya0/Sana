# 🏠 Home Feature (الشاشة الرئيسية)

هذا الموديول يمثل قلب التطبيق، حيث يعمل كمركز تحكم (Control Center) يربط بين جميع المميزات الأخرى ويقدم وصولاً سريعاً ومباشراً لأهم الخدمات الإسلامية المتوفرة في "سنا".

## 🛠️ كيف تعمل الميزة؟

1.  **بوابة الخدمات (Features Portal)**: يعرض الموديول قائمة بميزات التطبيق (مثل تعلم الصلاة، الأسماء الحسنى، بوصلة القبلة) بشكل ديناميكي يعتمد على المنصة (Android vs Web).
2.  **المحتوى اليومي (Daily Content)**: يحتوي على قسم "الحكمة اليومية" أو المحتوى المتجدد (حديث، سنة مهجورة، اسم اليوم) الذي يتم تحديثه تلقائياً كل يوم.
3.  **تذكير الصلاة (Prayer Section)**: يدمج وجت مواقيت الصلاة والعداد التنازلي للصلاة القادمة ليكون أمام المستخدم دائماً.
4.  **الوصول السريع للأذكار**: يقدم قسماً مخصصاً لأهم فئات الأذكار كواجهة شبكية (Grid) مع ميزة "عرض المزيد" للانتقال لباقي الأذكار.
5.  **الإعدادات والدعم**: يوفر مدخلاً لإعدادات الصلاة، التواصل مع المطورين، ودعم التطبيق.

---

## ✨ المميزات التقنية (Technical Features)

-   **الاستجابة للمنصة (Platform Aware)**: يقوم `FeaturesLocalDataSource` بتصفية الميزات المتاحة تلقائياً؛ فمثلاً تظهر ميزات معينة على الأندرويد بينما يتم تقييدها أو تغيير سلوكها على الويب (Web Support) لضمان استقرار التجربة.
-   **إدارة الحالة المركزية**: يستخدم `FeaturesListCubit` معمارية الـ Clean Architecture لفصل جلب البيانات عن طريقة عرضها، مع استخدام `Either` لمعالجة الأخطاء بشكل احترافي.
-   **السرعة (Caching)**: يتم تحميل ميزات التطبيق من DataSource محلي لضمان ظهور الواجهة فوراً عند فتح التطبيق دون انتظار.
-   **التصميم الانسيابي**: استخدام `CustomScrollView` مع `Slivers` لضمان حركة تمرير ناعمة (Smooth Scrolling) وتجربة مستخدم متميزة.

---

## 📂 هيكل الملفات (Structure)

-   `data/datasources/features_local_data_source.dart`: المسؤول عن تحديد قائمة الميزات المتاحة بناءً على نوع الجهاز والمنصة.
-   `data/models/category_item.dart`: النموذج الموحد الذي يجمع (ID، العنوان، الأيقونة، والـ Route).
-   `data/repositories/features_repository.dart`: جسر الربط الذي يعالج البيانات ويحولها إلى `Either<Failure, T>`.
-   `presentation/controller/`:
    -   `features_list_cubit.dart`: المسؤول عن تحميل حالة الميزات وإدارتها.
    -   `features_list_state.dart`: تعريف حالات القائمة (Initial, Loading, Loaded, Error).
-   `presentation/views/home_view.dart`: الواجهة الرئيسية المجمعة لجميع الـ Widgets والـ Blocs.
-   `presentation/widgets/`:
    -   `sections/`: تحتوي على الأقسام الكبرى مثل `HomeFeaturesCategorySection` و `AzkarCategoryBlocBuilder`.
    -   `category/`: المكونات الصغيرة مثل `CategoryCard` و `CategoryListSection`.

---

## 📝 ملاحظات للمطور
-   **Adding New Feature**: عند إضافة ميزة جديدة للتطبيق، يجب إضافتها في `FeaturesLocalDataSource` وتحديد الربط (Routing) الخاص بها لكي تظهر في الشاشة الرئيسية.
-   **Dependency Injection**: يتم تسجيل جميع توابع هذا الموديول في ملف `lib/core/di/home_di.dart`.
-   **Web Restrictions**: راجع منطق التقييد (Restricted Features) في `HomeFeaturesCategorySection` عند محاولة تشغيل ميزات تعتمد على الحساسات (مثل البوصلة) أو الـ Background Services على الويب.
