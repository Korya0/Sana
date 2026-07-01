# Home Feature (الشاشة الرئيسية)

هذه الميزة تمثل الشاشة الرئيسية في تطبيق "سَـنَـا"، وتتكون من عدة أقسام (Sections) تم تصميمها باستخدام **Clean Architecture** و **Sliver UI Pattern** لضمان أداء سلس وتجربة مستخدم ممتازة.

## 🏗 المعمارية والتصميم

1. **الطبقات (Layers):**
   - **Data Layer**: مسؤولة عن جلب قائمة ميزات التطبيق المحلية (Local Data) من خلال `FeaturesLocalDataSource`. يتم إرجاع الـ IDs فقط لضمان فصل الاهتمامات (DIP).
   - **Presentation Layer**: تتولى عرض الأقسام المختلفة وتحويل الـ IDs إلى واجهات ونصوص ورسومات، بالإضافة إلى إدارة الحالة عبر `Cubit`.

2. **الأداء والـ UI (Performance & UI):**
   - **Sliver Architecture**: يتم بناء الشاشة بالكامل باستخدام `CustomScrollView` و `SliverMainAxisGroup` مما يضمن مرور واحد للرسم (Single Render Pass) وسلاسة عالية أثناء التمرير (60 FPS) دون تداخل `ShrinkWrap`.
   - **Cubits كـ Singletons**: يتم تسجيل الـ Cubits (مثل `FeaturesListCubit` و `AzkarCategoriesCubit`) كـ `LazySingleton` في `home_di.dart` لضمان عدم إعادة البناء وطلب البيانات عند التنقل بين التبويبات (Bottom Navigation).

## 🧩 الأقسام (Sections)

1. **HomePrayerSection**: يعرض أوقات الصلاة الحالية بناءً على الموقع، ويتم تحديثه حياً.
2. **HomeFeaturesCategorySection**: شبكة دائرية (SliverGrid) تعرض الميزات الرئيسية للتطبيق (القرآن، الأذكار، القبلة، إلخ).
3. **HomeDailyWisdomSection**: يعرض محتوى يومي متجدد (حكمة، آية، أو حديث).
4. **HomeAzkarCategorySection**: شبكة إضافية مخصصة للوصول السريع لتصنيفات الأذكار (الصباح، المساء، إلخ).

## 🔒 الأمان (Security)
- تم تفعيل نظام تشفير بسيط (Hashing) للرقم السري (`adminSecretPinHash`) لضمان عدم تخزينه كنص صريح في الكود. 
- يظهر حوار `SecretPinDialog` مؤمن ومجهز بـ `SingleChildScrollView` لمنع مشاكل الـ Overflow عند ظهور لوحة المفاتيح.

## 🚀 كيفية الإضافة المستقبلي
لإضافة قسم جديد أو ميزة جديدة:
1. أضف الـ ID في `FeaturesLocalDataSource`.
2. قم بعمل Mapping للـ ID داخل `HomeFeaturesCategorySection` مع تحديد الـ Route المناسب من `AppRoutes`.
