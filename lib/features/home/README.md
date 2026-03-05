# 🏠 مزية الشاشة الرئيسية (home)

## نظرة عامة

مزية `home` هي النقطة المركزية للتطبيق (Dashboard). تقوم بتنظيم وتوزيع الوصول إلى جميع ميزات التطبيق الأخرى من خلال أقسام منظمة وبطاقات جذابة. الشاشة الرئيسية مصممة لتكون ديناميكية، حيث يختلف ترتيب ومحتوى المميزات بناءً على نوع المنصة (Android/iOS أو Web).

---

## 📁 هيكل الملفات

```
home/
├── data/
│   ├── datasources/
│   │   └── features_local_data_source.dart   ← تعريف قائمة المميزات وأيقوناتها
│   ├── models/
│   │   ├── category_item.dart                ← نموذج عنصر الميزة (ID, Title, Icon, Route)
│   │   └── category_model.dart                ← نموذج تصنيف المجموعات
│   └── repositories/
│       └── features_repository.dart           ← مستودع جلب المميزات
└── presentation/
    ├── controller/
    │   ├── features_list_cubit.dart           ← المتحكم في قائمة المميزات
    │   └── features_list_state.dart           ← حالات القائمة
    ├── views/
    │   └── home_view.dart                      ← واجهة الشاشة الرئيسية
    └── widgets/
        ├── category/
        │   ├── category_card.dart             ← بطاقة الميزة الواحدة
        │   └── category_section_header.dart   ← عنوان القسم (مثل: "الخدمات")
        ├── sections/                          ← أقسام الشاشة الرئيسية
        │   ├── home_prayer_section.dart       ← قسم أوقات الصلاة
        │   ├── home_quran_card_section.dart   ← قسم القرآن الكريم
        │   ├── home_azkar_category_section.dart ← قسم فئات الأذكار
        │   ├── home_daily_wisdom_section.dart ← قسم "محتوى اليوم"
        │   ├── home_features_category_section.dart ← قسم الخدمات الإضافية
        │   └── home_settings_section.dart     ← قسم الإعدادات السريعة
        └── secret_pin_dialog.dart             ← حوار سري للمطورين
```

---

## 🧩 نظام الأقسام (Sliver Layout)

تستخدم `HomeView` نظام `CustomScrollView` مع `Slivers` لضمان سلاسة التمرير وأداء عالي:

1. **قسم الصلاة (`HomePrayerSection`)**: يعرض مواقيت الصلاة والعد التنازلي للصلاة القادمة.
2. **قسم القرآن (`HomeQuranCardSection`)**: بطاقة كبيرة للوصول المباشر للمصحف الإلكتروني.
3. **قسم الأذكار (`HomeAzkarCategorySection`)**: قائمة أفقية لأهم فئات الأذكار (الصباح، المساء، إلخ).
4. **قسم محتوى اليوم (`HomeDailyWisdomSection`)**: يعرض الحديث والسنة اليومية بشكل مختصر.
5. **قسم الخدمات (`HomeFeaturesCategorySection`)**: يعرض بطاقات الميزات مثل (البحث في الأحاديث، القبلة، أسماء الله الحسنى، إلخ).
6. **قسم الإعدادات (`HomeSettingsSection`)**: وصول سريع لإعدادات التطبيق.

---

## 📦 طبقة البيانات (Data Layer)

### `features_local_data_source.dart`
هذا الملف هو "خريطة" التطبيق. يحدد أي الميزات تظهر للمستخدم بناءً على:
- **نظام التشغيل**: ميزات مثل "القبلة" قد تظهر بترتيب مختلف أو تختفي في نسخة الويب إذا لم تكن مدعومة.
- **المسارات (Routes)**: يربط كل بطاقة بالمسار الخاص بها في `go_router`.

### `category_item.dart`
يحتوي على بيانات البطاقة:
- `id`: معرف فريد.
- `title`: الاسم المعروض.
- `icon`: الأيقونة المستخدمة.
- `route`: المسار الذي سيتم الانتقال إليه عند الضغط.
- `isRestricted`: علامة تدل على أن الميزة تحت التطوير (تجربة).

---

## 🧠 طبقة العرض (Presentation Layer)

### `category_card.dart` — البطاقة التفاعلية
- **Animations**: تستخدم `AppAnimations.pressScale` لتعطي شعوراً حقيقياً بالضغط عند النقر.
- **Design**: تعتمد تصميم "Glassmorphism" مع حدود ذهبية خفيفة وتدرج لوني خلفي.
- **Badges**: تظهر علامة "قريباً" أو "Beta" إذا كانت الميزة `isRestricted`.

### `features_list_section.dart`
ويدجت ذكي يمكنه عرض الميزات بشكلين:
- **القائمة (ListView)**: تمرير أفقي بسيط.
- **الشبكة (GridView)**: صفوف متعددة (مثل ما نراه في قسم الخدمات الإضافية).

---

## 🔄 تدفق البيانات

```
HomeView (initState)
      ↓
MultiBlocProvider (FeaturesListCubit + AzkarCategoriesCubit)
      ↓
FeaturesListCubit.loadFeatures()
  → FeaturesRepository.getFeatures()
  → FeaturesLocalDataSource.getFeatures() (بناءً على Platform)
      ↓
emit(FeaturesListLoaded(items))
      ↓
HomeView → HomeFeaturesCategorySection → CategoryListSection
      ↓
CategoryCard (عند الضغط) → context.pushNamed(item.route)
```

---

## 🛠️ أدوات المطور (Secret PIN)
المزية تحتوي على `SecretPinDialog` يُفتح عند الضغط المطول على شعار التطبيق أو زر معين (حسب الإعداد)، يتيح للمطورين الوصول إلى ميزات تجريبية أو لوحة التحكم (`developer_dashboard`).

---

## 📦 المكتبات المستخدمة

| المكتبة | الغرض |
|---------|-------|
| `flutter_bloc` | إدارة حالة الواجهة |
| `go_router` | التنقل بين الصفحات |
| `flutter_islamic_icons` | أيقونات إسلامية متخصصة |
| `solar_icons` | أيقونات عصرية موحدة |
