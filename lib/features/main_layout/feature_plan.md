# خطة تنفيذ ميزة التخطيط الرئيسي (Main Layout & Bottom Nav Bar)

الهدف: بناء شريط تنقل سفلي (Bottom Navigation Bar) ملاصق للشاشة، وتقسيم التطبيق إلى 3 تبويبات رئيسية مع الاحتفاظ بحالة كل تبويب (Stateful Navigation) لتجربة مستخدم مثالية.

## المعمارية المختارة
- **Tier 3 (Presentation Layer):** الميزة تقتصر على الواجهات والتنقل (Routing)، لذلك لن نحتاج لـ Domain أو Data layers خاصة بها.
- **التوجيه (Routing):** سنستخدم `StatefulShellRoute.indexedStack` من مكتبة `go_router` للحفاظ على حالة الشاشات أثناء التنقل.

## الكيوبيتس وتوزيعها (Cubits Distribution)
لضمان أفضل أداء واستهلاك للذاكرة:
- **الرئيسية (Home):** سيتم توفير (`FeaturesListCubit`, `AzkarCategoriesCubit`, `DailyContentCubit`, `AsmaUlHusnaCubit`, `LocationNameCubit`, `PrayerTimesCubit`, `AppDateCubit`) داخل مسار الرئيسية فقط لتجنب استهلاك الذاكرة في التبويبات الأخرى.
- **القرآن الكريم (Quran):** سيتم توفير `QuranCubit` فقط داخل مسار القرآن.
- **الإعدادات (Settings):** لن تحتاج لكيوبيتس معقدة (تعتمد على الـ `ThemeCubit` العام).

## واجهة المستخدم (UI/UX) والتصميم
- الشريط سيكون ملاصقاً تماماً للشاشة من الأسفل (بدون فراغات أو `margin`).
- استخدام مكتبة الأيقونات `solar_icons`:
  - **الرئيسية:** `SolarIconsOutline.home` (غير نشط) / `SolarIconsBold.home` (نشط).
  - **القرآن الكريم:** `SolarIconsOutline.book` (غير نشط) / `SolarIconsBold.book` (نشط).
  - **الإعدادات:** `SolarIconsOutline.settings` (غير نشط) / `SolarIconsBold.settings` (نشط).
- سيتم إزالة قسم الإعدادات `HomeSettingsSection` من الرئيسية وتحويله إلى شاشة كاملة `SettingsView`.

## قائمة المهام (Checklist)
- [ ] **1. ملفات الميزة الجديدة:** إنشاء `features/main_layout/presentation/views/main_layout_view.dart` يحتوي على الـ `Scaffold` وشريط التنقل السفلي المخصص.
- [ ] **2. الإعدادات:** نقل وتطوير `HomeSettingsSection` ليصبح شاشة مستقلة `SettingsView` داخل `features/settings/presentation/views/settings_view.dart`.
- [ ] **3. الروابط (Routing):** تعديل `app_router.dart`:
  - إعداد `StatefulShellRoute.indexedStack`.
  - تجهيز 3 فروع (Branches): الرئيسية، القرآن، الإعدادات.
  - حقن (Inject) الـ Cubits الخاصة بكل شاشة في مسارها المناسب.
- [ ] **4. الرئيسية (Home):** تحديث `HomeView` لإزالة قسم الإعدادات (وربما نحتاج لإزالة اختصار القرآن من قائمة الميزات إن وجد لمنع التكرار).
- [ ] **5. الفحص:** التأكد من سلاسة التنقل وبقاء الحالة (State preservation) ومراجعة الأداء.

> **بوابة التوقف الصارمة:**
> الخطة جاهزة الآن وتنتظر موافقتك الصريحة للبدء في كتابة الأكواد والتنفيذ خطوة بخطوة.
