# 📿 Azkar Feature

ميزة **الأذكار** هي ميزة التسبيح التفاعلية التي تُتيح للمستخدم تصفح أذكار متعددة الفئات والتسبيح بها مع تتبع العدد وإمكانية المشاركة.

## 🚀 المميزات الرئيسية
- عرض 23 فئة من الأذكار مُرتبة بالأولوية (أذكار الصباح والمساء أولاً).
- تسبيح تفاعلي بالضغط مع تأثيرات اهتزاز وعداد دائري متحرك.
- حماية ضد الضغط السريع (Debounce) لمنع التجاوز.
- دعم Optimistic Scroll للانتقال التلقائي للذكر التالي عند الاكتمال.
- مشاركة ونسخ أي ذكر.
- تأكيد الخروج عند وجود تقدم غير مكتمل.
- تحميل سلس مع Skeletonizer.

## 🏗 الهيكل المعماري

```
azkar/
├── data/
│   ├── constants/    ← AzkarKeys
│   ├── datasources/  ← AzkarLocalDataSource (JSON + in-memory cache + priority sorting)
│   ├── models/       ← AzkarCategoryModel, ZikrModel (Equatable)
│   └── repositories/ ← IAzkarRepository + AzkarRepository
└── presentation/
    ├── controller/
    │   ├── azkar_categories_cubit.dart  (+ State في نفس الملف)
    │   ├── azkar_category_loader_cubit.dart (+ State)
    │   ├── azkar_list_cubit.dart
    │   └── azkar_list_state.dart       ← الأغنى بالـ computed getters
    ├── views/
    │   ├── all_azkar_categories_view.dart
    │   ├── azkar_details_loader_view.dart
    │   └── azkar_list_view.dart
    └── widgets/
        ├── azkar_list_content.dart
        ├── zikr_item_card.dart
        ├── zikr_card/
        │   ├── zikr_actions_row.dart
        │   ├── zikr_content.dart
        │   └── zikr_counter.dart
        └── share_card/
            └── zikr_share_card.dart
```

## 📦 الـ States (Sealed Classes — Manual)

**`AzkarCategoriesState`** (في نفس ملف الـ Cubit):
```dart
AzkarCategoriesInitial → AzkarCategoriesLoading → AzkarCategoriesLoaded | AzkarCategoriesError
```

**`AzkarCategoryLoaderState`** (في نفس ملف الـ Cubit):
```dart
AzkarCategoryLoaderInitial → AzkarCategoryLoaderLoading → AzkarCategoryLoaderLoaded | AzkarCategoryLoaderError
```

**`AzkarListState`** (مستقل - الأكثر ثراءً):
```dart
AzkarListInitial → AzkarListInProgress { zikrProgress, currentIndex, completedCount }
               → AzkarListCompleted
```
يحتوي على computed getters: `isZikrCompleted()`, `getProgress()`, `isAllCompleted`, `hasProgress`.

## 🎨 رموز التصميم
- **Spacing:** `AppSpacing` (v4, v8, v12, v16, v20, v24).
- **Radius:** `AppSpacing.radiusL` للبطاقات، `radiusXL` (20) لبطاقات الذكر.
- **Colors:** `AppColors.gold.withValues(alpha: ...)` للحدود والعداد.

## ⚙️ الـ DI
| الكلاس | النوع | السبب |
|---|---|---|
| `AzkarLocalDataSource` | `LazySingleton` | يحتفظ بـ in-memory cache للـ JSON |
| `IAzkarRepository` | `LazySingleton` | يعتمد على DataSource |
| `AzkarCategoriesCubit` | `Factory` | يُنشأ مع الصفحة الرئيسية |
| `AzkarCategoryLoaderCubit` | `Factory` | يُنشأ لكل تصفح لفئة |
| `AzkarListCubit` | محلي (BlocProvider) | عمره = عمر صفحة التسبيح |

## 📝 ملاحظات
- `AzkarListCubit` لا يحتاج Repository — يستقبل `AzkarCategoryModel` جاهزاً من الـ View.
- `_categoryIcons` في الـ DataSource: خريطة ثابتة تربط ID الفئة بالأيقونة المناسبة.
- **نظام الأولويات:** أذكار الصباح (2) والمساء (3) والاستيقاظ (5) والنوم (4) والتسبيح (1) تظهر أولاً.
