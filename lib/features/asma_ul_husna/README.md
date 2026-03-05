# 🌟 مزية أسماء الله الحسنى (asma_ul_husna)

## نظرة عامة

مزية `asma_ul_husna` تعرض **أسماء الله التسعة والتسعين** مع معانيها المختصرة والتفصيلية. تُتيح للمستخدم الاطلاع على كل اسم، وتوسيعه لقراءة الشرح التفصيلي، وإضافته للمفضلة، ومشاركته أو نسخه. كذلك تعرض **اسماً مميزاً لكل يوم** في الصفحة الرئيسية.

---

## 📁 هيكل الملفات

```
asma_ul_husna/
├── data/
│   ├── datasources/
│   │   └── asma_ul_husna_local_data_source.dart    ← قراءة JSON من Assets
│   ├── models/
│   │   └── asmaul_husna_model.dart                  ← نموذج البيانات
│   └── repositories/
│       └── asma_ul_husna_repository.dart            ← منطق الأعمال + المفضلة
└── presentation/
    ├── controller/
    │   ├── asma_ul_husna_cubit.dart                 ← المتحكم
    │   └── asma_ul_husna_state.dart                 ← الحالات
    ├── views/
    │   └── asma_ul_husna_page.dart                  ← الصفحة الرئيسية
    └── widgets/
        ├── asma_ul_husna_card.dart                  ← بطاقة اسم واحد
        ├── asma_ul_husna_name_of_the_day_card.dart  ← بطاقة اسم اليوم
        ├── modern_asma_ul_husna_view.dart            ← قائمة الأسماء بأنيميشن
        ├── skeletonizer_loading_asma_ul_husna_view.dart ← شاشة التحميل
        └── share_card/
            └── asma_ul_husna_share_card.dart        ← بطاقة المشاركة
```

---

## 📦 طبقة البيانات (Data Layer)

### `asmaul_husna_model.dart` — نموذج البيانات

يُمثّل اسماً واحداً من أسماء الله الحسنى.

| الخاصية | النوع | الوصف |
|---------|------|-------|
| `id` | `int` | رقم الاسم (1 إلى 99) |
| `name` | `String` | الاسم بالخط العربي (مثل: "الله"، "الرحمن") |
| `meaningBrief` | `String` | المعنى المختصر |
| `meaningDetailed` | `String` | الشرح التفصيلي |

---

### `asma_ul_husna_local_data_source.dart` — مصدر البيانات المحلي

يقرأ بيانات الأسماء من ملف JSON موجود في Assets التطبيق.

**مميزاته:**
- يُخزّن البيانات في **ذاكرة Cache (`_cachedNames`)** بعد أول قراءة.
- عند الاستدعاءات اللاحقة، يرجع البيانات المخزنة مباشرة دون قراءة الـ JSON مرة أخرى.
- إذا حدث خطأ في القراءة، يُسجّل الخطأ في `AppLogger` ويرجع قائمة فارغة.

---

### `asma_ul_husna_repository.dart` — الريبوزيتوري

يُوفّر كل العمليات المتعلقة بأسماء الله الحسنى.

#### الواجهة `IAsmaUlHusnaRepository`:

| الدالة | الإرجاع | الوصف |
|--------|---------|-------|
| `getNames()` | `Either<Failure, List<AsmaulHusnaModel>>` | جلب كل الأسماء |
| `getNameOfTheDay()` | `Either<Failure, AsmaulHusnaModel>` | اسم اليوم |
| `toggleAsmaFavorite(item)` | `Future<bool>` | تبديل حالة المفضلة |
| `isAsmaFavorite(item)` | `bool` | هل الاسم في المفضلة؟ |
| `getAsmaFavorites()` | `List<AsmaulHusnaModel>` | كل الأسماء المفضلة |

#### آلية "اسم اليوم":
```dart
final dayOfYear = now.difference(DateTime(now.year)).inDays;
return names[dayOfYear % names.length];
```
يحسب رقم اليوم من بداية السنة، ثم يقسمه على عدد الأسماء (99) ليختار اسماً مميزاً مختلفاً كل يوم. هذا يعني أن اسم اليوم ثابت طوال اليوم ولا يتغير.

#### آلية المفضلة:
- المفضلة تُخزَّن كـ JSON في SharedPreferences.
- عند بداية التطبيق، تُحمّل في قائمة `_cachedAsmaFavorites` داخل الذاكرة للوصول السريع.
- `toggleAsmaFavorite` تضيف أو تُزيل الاسم وتحفظ القائمة الجديدة.

---

## 🧠 طبقة العرض (Presentation Layer)

### `asma_ul_husna_state.dart` — الحالات

| الحالة | الوصف |
|--------|-------|
| `AsmaUlHusnaInitial` | الحالة الأولية قبل أي تحميل |
| `AsmaUlHusnaLoading` | جاري تحميل البيانات |
| `AsmaUlHusnaLoaded` | تم التحميل بنجاح (يحمل القائمة) |
| `AsmaUlHusnaError` | فشل التحميل (يحمل رسالة الخطأ) |

---

### `asma_ul_husna_cubit.dart` — المتحكم

بسيط جداً، دالة واحدة:

```dart
Future<void> loadNames() async {
  emit(AsmaUlHusnaLoading());
  final result = await _repository.getNames();
  result.fold(
    (failure) => emit(AsmaUlHusnaError(message: failure.message)),
    (names)   => emit(AsmaUlHusnaLoaded(names: names)),
  );
}
```

---

### `asma_ul_husna_page.dart` — الصفحة الرئيسية

صفحة `AsmaUlHusnaPage` تستخدم `CustomScrollView` مع `SliverList`. تُدير 3 حالات:

| الحالة | ما يُعرض |
|--------|----------|
| `AsmaUlHusnaLoading` | `SkeletonizerLoadingAsmaUlHusnaView` — هيكل وهمي متحرك |
| `AsmaUlHusnaError` | `AppErrorWidget` مع زر "إعادة المحاولة" |
| `AsmaUlHusnaLoaded` | `ModernAsmaUlHusnaView` — القائمة الكاملة |

---

### `modern_asma_ul_husna_view.dart` — قائمة الأسماء

يستخدم `AnimatedSliverList` (من core) لعرض الأسماء بأنيميشن دخول سلسة لكل بطاقة.

---

### `asma_ul_husna_card.dart` — بطاقة اسم واحد

هي البطاقة التي تعرض كل اسم. تدعم التوسع والانطواء.

**ما تحتويه (الجزء الثابت دائماً):**
- دائرة صغيرة تحمل **رقم الاسم**.
- **الاسم** بخط القرآن الذهبي الكبير.
- **المعنى المختصر** على يمين الاسم.
- **أزرار المشاركة والنسخ** (`CombinedShareCopyButton`).

**الجزء الذي يظهر عند التوسع (النقر على البطاقة):**
- **خط فاصل** ثم **المعنى التفصيلي** بمحاذاة كاملة (RTL).
- توسع/انطواء بأنيميشن 300ms (`Curves.easeInOut`).
- حدود البطاقة تتغير من شفافية 10% إلى 30% ذهبي عند التوسع.

**إجراءات المستخدم:**
| الإجراء | الوصف |
|---------|-------|
| النقر على البطاقة | توسع/انطواء لعرض الشرح التفصيلي |
| زر المشاركة | ينشئ صورة من `AsmaUlHusnaShareCard` ويشاركها |
| زر النسخ | ينسخ الاسم + المعنى المختصر + التفصيلي للحافظة |

---

### `asma_ul_husna_name_of_the_day_card.dart` — بطاقة اسم اليوم

تُعرض في الصفحة الرئيسية للتطبيق (Home). تستمع لـ `DailyContentCubit` لجلب `state.dailyAsma`.

**ما تحتويه:**
- عنوان الاسم + شرحه التفصيلي.
- أيقونة إسلامية مميزة (`FlutterIslamicIcons.solidAllah`).
- بطاقة قابلة للنقر تنتقل بك لصفحة أسماء الله الكاملة.
- أزرار مشاركة ونسخ.

---

### `skeletonizer_loading_asma_ul_husna_view.dart` — شاشة التحميل

تُعرض 10 بطاقات وهمية باستخدام مكتبة `skeletonizer` بينما تُحمّل البيانات الحقيقية. هذا يمنع الشاشة الفارغة أثناء التحميل.

---

## 🔄 تدفق البيانات الكامل

```
فتح صفحة أسماء الله
      ↓
AsmaUlHusnaPage creates AsmaUlHusnaCubit
  → loadNames() → emit(Loading)
      ↓
AsmaUlHusnaLocalDataSource.getNames()
  → يقرأ JSON من Assets (أو يرجع Cache)
  → يُحوّل لـ List<AsmaulHusnaModel>
      ↓
AsmaUlHusnaRepository يُغلّف النتيجة كـ Either
      ↓
Cubit → emit(Loaded(names)) أو emit(Error)
      ↓
Page → ModernAsmaUlHusnaView → AnimatedSliverList
  → كل عنصر → AsmaUlHusnaCard
```

---

## 💾 البيانات المحفوظة (SharedPreferences)

| المفتاح | النوع | الوصف |
|---------|------|-------|
| `asmaFavorites` | `String` (JSON Array) | قائمة الأسماء المضافة للمفضلة |

---

## 📦 المكتبات المستخدمة

| المكتبة | الغرض |
|---------|-------|
| `flutter_bloc` | إدارة الحالة |
| `dartz` | نمط Either للتعامل مع الأخطاء |
| `skeletonizer` | شاشة التحميل الهيكلية |
| `shared_preferences` | حفظ المفضلة |
| `flutter_islamic_icons` | الأيقونات الإسلامية في بطاقة اليوم |

---

## 🔗 العلاقات مع المزايا الأخرى

- **`daily_content`**: يستخدم `IAsmaUlHusnaRepository.getNameOfTheDay()` لعرض اسم اليوم في الصفحة الرئيسية عبر `DailyContentCubit`.
- **`core/sharing`**: يستخدم `WidgetToImage.shareWidget()` لإنشاء صور للمشاركة.
