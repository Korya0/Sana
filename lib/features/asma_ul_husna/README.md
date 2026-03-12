# 🤲 Asma ul Husna Feature

ميزة **أسماء الله الحسنى** مسؤولة عن عرض الأسماء الـ 99 مع معانيها المختصرة والتفصيلية، مع دعم التوسيع والمشاركة والنسخ.

## 🚀 المميزات الرئيسية
- عرض الأسماء الـ 99 باستخدام نظام Sliver متحرك (Animated Sliver List).
- توسيع كل بطاقة لعرض المعنى التفصيلي.
- مشاركة أي اسم كصورة جذابة.
- نسخ الاسم ومعناه للحافظة.
- عرض "اسم اليوم" من الأسماء الحسنى في الشاشة الرئيسية (عبر `DailyContentCubit`).
- تحميل سلس مع `Skeletonizer` أثناء الانتظار.

## 🏗 الهيكل المعماري

```
asma_ul_husna/
├── data/
│   ├── constants/       ← AsmaKeys (مفاتيح الـ JSON)
│   ├── datasources/     ← AsmaUlHusnaLocalDataSource (تحميل JSON + caching)
│   ├── models/          ← AsmaulHusnaModel (Equatable، نظيف)
│   └── repositories/    ← IAsmaUlHusnaRepository (Interface + Impl)
└── presentation/
    ├── controller/      ← AsmaUlHusnaCubit + AsmaUlHusnaState
    ├── routes/          ← AsmaUlHusnaRoutes
    ├── views/           ← AsmaUlHusnaPage
    └── widgets/
        ├── asma_ul_husna_card.dart
        ├── asma_ul_husna_name_of_the_day_card.dart
        ├── modern_asma_ul_husna_view.dart
        ├── skeletonizer_loading_asma_ul_husna_view.dart
        └── share_card/
            └── asma_ul_husna_share_card.dart
```

## 🔄 تدفق البيانات (Data Flow)

```
AsmaUlHusnaPage
  → sl<AsmaUlHusnaCubit>() [Factory]
    → IAsmaUlHusnaRepository [LazySingleton]
      → AsmaUlHusnaLocalDataSource (JSON + in-memory cache)
```

## 📦 الـ State (Sealed Classes — Manual)

```dart
abstract class AsmaUlHusnaState extends Equatable
  ├── AsmaUlHusnaInitial
  ├── AsmaUlHusnaLoading
  ├── AsmaUlHusnaLoaded { names: List<AsmaulHusnaModel> }
  └── AsmaUlHusnaError  { message: String }
```

## 🎨 رموز التصميم (Design Tokens)
- **Spacing:** `AppSpacing` (v8, v12, v16).
- **Radius:** `AppSpacing.radiusL` للبطاقات.
- **Colors:** `AppColors.gold.withValues(alpha: ...)` للحدود.
- **Typography:** `AppTextStyles` لكافة النصوص.

## ⚙️ الـ DI
| الكلاس | النوع | السبب |
|---|---|---|
| `IAsmaUlHusnaRepository` | `LazySingleton` | يُنشأ مرة واحدة، يحتفظ بـ Cache |
| `AsmaUlHusnaCubit` | `Factory` | يُنشأ عند فتح الصفحة ويُتلف عند إغلاقها |

## 📝 ملاحظات
- الـ Repository لا يعتمد على `ISharedPref` (تمت إزالة الـ Favorites غير المستخدمة).
- `AsmaUlHusnaLocalDataSource` يحتفظ بـ in-memory cache لتجنب قراءة الـ JSON عند كل فتح للصفحة.
- `AsmaUlHusnaNameOfTheDayCard` يعتمد على `DailyContentCubit` مباشرة (لا يحتاج `AsmaUlHusnaCubit`).
