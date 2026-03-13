# 🏠 مزية الشاشة الرئيسية (home)

## نظرة عامة

مزية `home` هي النقطة المركزية للتطبيق (Dashboard). تقوم بتنظيم وتوزيع الوصول إلى جميع ميزات التطبيق الأخرى من خلال أقسام منظمة وبطاقات جذابة. الشاشة الرئيسية مصممة لتكون ديناميكية، حيث يختلف محتوى المميزات بناءً على نوع المنصة.

---

## 📁 هيكل الملفات

```
home/
├── data/
│   ├── datasources/
│   │   └── features_local_data_source.dart   ← تعريف قائمة المميزات وأيقوناتها
│   ├── models/
│   │   └── category_item.dart                ← نموذج عنصر الميزة
│   └── repositories/
│       └── features_repository.dart           ← مستودع جلب المميزات
└── presentation/
    ├── controller/
    │   ├── features_list_cubit.dart           ← المتحكم في قائمة المميزات
    │   └── features_list_state.dart           ← حالات القائمة (Sealed Classes)
    ├── views/
    │   └── home_view.dart                      ← واجهة الشاشة الرئيسية (CustomScrollView)
    └── widgets/
        ├── category/                          ← بطاقات التصنيفات
        └── sections/                          ← الأقسام الرئيسية (Prayer, Quran, Azkar...)
```

---

## 🏗️ التصميم والمعايير

### التوافق مع المعايير المعمارية:
- **SOLID Compliance**: فصل تام بين مصدر البيانات المحلي (`DataSource`) والمستودع (`Repository`).
- **Standard Spacing**: التخلص من الأرقام السحرية (Magic Numbers) واستخدام `AppSpacing` الموحد لضمان اتساق الواجهة.
- **Dependency Injection**: تسجيل جميع المكونات (`Cubit`, `Repository`, `DataSource`) في `home_di.dart` لضمان إدارة سليمة للذاكرة.

### المميزات المرئية:
- **Sliver Grid & Lists**: استخدام الـ Slivers لأداء تصفح سلس جداً.
- **Glassmorphism**: تطبيق تأثيرات الزجاج والظلال الذهبية على البطاقات.
- **Animations**: تأثيرات ضغط (Press Scale) عند التفاعل مع أي ميزة.

---

## 📦 المكتبات المستخدمة

| المكتبة | الغرض |
|---------|-------|
| `flutter_bloc` | إدارة حالة الصفحة الرئيسية |
| `go_router` | التنقل السلس بين الميزات |
| `solar_icons` | أيقونات عصرية متسقة |
| `freezed` | Sealed States للحالات مع code generation |

---

## 🔄 تدفق العمل

1. يتم طلب قائمة المميزات من `FeaturesRepository`.
2. يقوم الـ `Cubit` بتصفية القائمة بناءً على المنصة المتوفرة.
3. تعرض `HomeView` الأقسام المختلفة باستخدام `SliverToBoxAdapter` و `SliverPadding`.
4. تعتمد المسافات بين الأقسام على ثوابت `AppSpacing.v18` و `AppSpacing.v24` لضمان التناسق.
