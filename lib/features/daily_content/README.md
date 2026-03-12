# 📰 Daily Content Feature

ميزة **المحتوى اليومي** هي المحرك المركزي لعرض المحتوى الإسلامي المتجدد يومياً (الحديث، السنة، اسم الله الحسنى) في الصفحة الرئيسية. تعمل بنظام تقديم عشوائي منظم يضمن عدم التكرار وإمكانية الحفظ (المفضلة).

## 🚀 المميزات الرئيسية
- عرض حديث يومي، سنة يومية، واسم من أسماء الله الحسنى.
- نظام تقديم عشوائي (Shuffled Rotation) يضمن التنوع دون تكرار.
- تقدم تلقائي لليوم التالي عند منتصف الليل (مرتبط بـ `AppDateCubit`).
- إمكانية حفظ الحديث والسنة في المفضلة.
- تتبع ما إذا كان المستخدم شاهد المحتوى اليوم.

## 🏗 الهيكل المعماري

```
daily_content/
├── data/
│   ├── constants/  ← DailyContentKeys (مفاتيح JSON + معرّفات الفئات)
│   ├── datasources/ ← DailyContentDataSource (JSON local loading)
│   ├── models/     ← DailyContentModel (Equatable)
│   └── repositories/ ← IDailyContentRepository + DailyContentRepositoryImpl
└── presentation/
    ├── controller/ ← DailyContentCubit + DailyContentState (copyWith + Enum)
    ├── views/      ← DailyContentFavoritesView
    └── widgets/
        ├── card/   ← DailyContentBaseCard, DailyHadithCard, DailySunnahCard
        └── share_card/ ← DailyContentShareCard
```

## 🔄 تدفق البيانات

```
AppDateCubit (stream) → DailyContentCubit
  → IDailyContentRepository [LazySingleton]
    → ISharedPref (حفظ الفهرس، التاريخ، المفضلات)
    → DailyContentDataSource (JSON assets)
  → IAsmaUlHusnaRepository (أسماء اليوم)
```

## ⚙️ الـ State
يستخدم نمط `Enum + copyWith` (مقبول للحالات المتداخلة):
```dart
enum DailyContentStatus { initial, loading, success, failure }
class DailyContentState extends Equatable { ... }
```

## 🔑 الثوابت المعيارية
جميع معرّفات الفئات محدودة في `DailyContentKeys`:
```dart
static const String categoryHadith = 'hadith';
static const String categorySunnah = 'sunnah';
static const String categoryAsma   = 'asma';
```

## ⚙️ الـ DI
| الكلاس | النوع | السبب |
|---|---|---|
| `IDailyContentRepository` | `LazySingleton` | يحتفظ بـ cache المفضلات |
| `DailyContentCubit` | `LazySingleton` | مشترك في كامل التطبيق |

## 📝 ملاحظات
- الكيوبت يستمع لـ `AppDateCubit.stream` لتحديث المحتوى تلقائياً عند تغيّر اليوم.
- المستقبل: تحويل `DailyContentState` إلى Sealed Classes عند التحديث الكبير.
